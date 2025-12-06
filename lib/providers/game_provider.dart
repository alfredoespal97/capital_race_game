import 'package:flutter/material.dart';
import 'dart:math';
import '../models/player.dart';
import '../models/property.dart';
import '../models/bot_player.dart';
import '../data/board_data.dart';
import 'dart:async'; // For Timer/Future
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameProvider with ChangeNotifier {
  List<Player> _players = [];
  List<BoardSpace> _boardSpaces = [];
  int _currentPlayerIndex = 0;
  int _dice1 = 1;
  int _dice2 = 1;
  String _gameMessage = 'Welcome to Monopoly!';
  bool _isRolling = false;
  int _doublesCount = 0;
  bool _hasRolledDice = false;

  bool _hasSaveFile = false;
  bool get hasSaveFile => _hasSaveFile;

  Map<String, dynamic>? _currentCardDialog;
  Map<String, dynamic>? get currentCardDialog => _currentCardDialog;

  GameProvider() {
    _initGame();
    _checkSaveFile();
  }

  Future<void> _checkSaveFile() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSaveFile = prefs.containsKey('monopoly_save_game');
    notifyListeners();
  }

  List<Player> get players => _players;
  List<BoardSpace> get boardSpaces => _boardSpaces;
  Player get currentPlayer => _players[_currentPlayerIndex];
  int get dice1 => _dice1;
  int get dice2 => _dice2;
  String get gameMessage => _gameMessage;
  bool get isRolling => _isRolling;
  bool get hasRolledDice => _hasRolledDice;
  bool get isCurrentPlayerBot => currentPlayer is BotPlayer;
  int get currentPlayerIndex => _currentPlayerIndex;

  void _initGame() {
    _boardSpaces = BoardData.getBoardSpaces();
  }

  void initializeGame(List<Player> players) {
    setPlayers(players);
  }

  void setPlayers(List<Player> players) {
    _players = players;
    _currentPlayerIndex = 0;
    _gameMessage = '${currentPlayer.name}\'s turn!';
    notifyListeners();
  }

  void clearCardDialog() {
    _currentCardDialog = null;
    notifyListeners();
    if (isCurrentPlayerBot && !currentPlayer.isBankrupt) {
      Future.delayed(const Duration(milliseconds: 500), endTurn);
    }
  }

  Future<void> rollDice() async {
    if (_isRolling ||
        (_hasRolledDice && _doublesCount == 0 && !currentPlayer.isInJail) ||
        currentPlayer.isBankrupt)
      return;

    _isRolling = true;
    notifyListeners();

    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      _dice1 = Random().nextInt(6) + 1;
      _dice2 = Random().nextInt(6) + 1;
      notifyListeners();
    }

    _isRolling = false;
    _dice1 = Random().nextInt(6) + 1;
    _dice2 = Random().nextInt(6) + 1;
    // _dice1 = 6; _dice2 = 6; // Testing doubles

    bool isDoubles = _dice1 == _dice2;
    int total = _dice1 + _dice2;
    _hasRolledDice = true;

    if (currentPlayer.isInJail) {
      _handleJailRoll(isDoubles);
    } else {
      if (isDoubles) {
        _doublesCount++;
        if (_doublesCount >= 3) {
          _sendToJail();
          return;
        }
      } else {
        _doublesCount = 0;
      }

      _movePlayer(total);

      await Future.delayed(const Duration(milliseconds: 500));
      _handleLanding();

      if (isDoubles) {
        if (!currentPlayer.isBankrupt && !currentPlayer.isInJail) {
          _gameMessage += ' Doubles! Roll again.';
          _hasRolledDice = false;
          if (isCurrentPlayerBot) {
            Future.delayed(const Duration(seconds: 1), rollDice);
          }
        }
      } else {
        if (currentPlayer is! BotPlayer && !currentPlayer.isBankrupt) {
          _gameMessage += ' Turn complete.';
        }
      }
    }
    notifyListeners();
  }

  void _handleJailRoll(bool isDoubles) {
    if (isDoubles) {
      currentPlayer.releaseFromJail();
      _gameMessage =
          '${currentPlayer.name} rolled doubles and got out of jail!';
      _movePlayer(_dice1 + _dice2);
      _handleLanding();

      if (currentPlayer is BotPlayer) {
        Future.delayed(const Duration(seconds: 1), endTurn);
      } else {
        _hasRolledDice = true;
      }
    } else {
      currentPlayer.jailTurns++;
      if (currentPlayer.jailTurns >= 3) {
        _handlePayment(50, null); // Provide bank payment for jail
        if (!currentPlayer.isBankrupt) {
          currentPlayer.releaseFromJail();
          _gameMessage =
              '${currentPlayer.name} paid \$50 to get out (3 attempts).';
          _movePlayer(_dice1 + _dice2);
          _handleLanding();
        }
        if (currentPlayer is BotPlayer && !currentPlayer.isBankrupt) {
          Future.delayed(const Duration(seconds: 1), endTurn);
        }
      } else {
        _gameMessage = 'Failed to roll doubles. Still in Jail.';
        if (currentPlayer is BotPlayer) {
          Future.delayed(const Duration(seconds: 1), endTurn);
        }
      }
    }
    _doublesCount = 0;
  }

  void _movePlayer(int spaces) {
    int oldPosition = currentPlayer.position;
    currentPlayer.position = (currentPlayer.position + spaces) % 40;

    if (currentPlayer.position < oldPosition) {
      currentPlayer.addMoney(200);
      _gameMessage = 'Passed GO! Collected \$200.';
    }
    notifyListeners();
  }

  void _handleLanding() {
    if (currentPlayer.isBankrupt) return;
    BoardSpace space = _boardSpaces[currentPlayer.position];
    bool isBot = currentPlayer is BotPlayer;

    switch (space.type) {
      case SpaceType.property:
      case SpaceType.railroad:
      case SpaceType.utility:
        _handlePropertyLanding(space);
        break;
      case SpaceType.chance:
        _handleChance();
        break;
      case SpaceType.communityChest:
        _handleCommunityChest();
        break;
      case SpaceType.tax:
        _handleTax(space);
        if (isBot && !currentPlayer.isBankrupt)
          Future.delayed(const Duration(seconds: 1), endTurn);
        break;
      case SpaceType.corner:
        _handleCorner(space);
        if (space.action != 'go_to_jail' &&
            isBot &&
            !currentPlayer.isBankrupt) {
          Future.delayed(const Duration(seconds: 1), endTurn);
        }
        break;
    }
  }

  void _handlePropertyLanding(BoardSpace space) {
    Property? property = space.property;
    if (property == null) return;

    if (property.owner == null) {
      _gameMessage = 'Landed on ${property.name}. Buy for \$${property.price}?';
      if (currentPlayer is BotPlayer) {
        (currentPlayer as BotPlayer).decideToBuy(property, this);
      }
    } else {
      if (property.owner == currentPlayer.id) {
        _gameMessage = 'Landed on your own property.';
      } else if (property.isMortgaged) {
        _gameMessage = '${property.name} is mortgaged. No rent.';
      } else {
        int rent = _calculateRent(property);
        _payRent(property, rent);
      }
      if (currentPlayer is BotPlayer && !currentPlayer.isBankrupt) {
        Future.delayed(const Duration(seconds: 1), endTurn);
      }
    }
  }

  int _calculateRent(Property property) {
    if (property.isMortgaged) return 0;
    if (property.type == PropertyType.utility) {
      int count = _countPlayerUtilities(property.owner!);
      return count == 2 ? (_dice1 + _dice2) * 10 : (_dice1 + _dice2) * 4;
    } else if (property.type == PropertyType.railroad) {
      int count = _countPlayerRailroads(property.owner!);
      return [25, 50, 100, 200][count - 1];
    }
    return property.getCurrentRent();
  }

  int _countPlayerUtilities(String playerId) {
    return _boardSpaces
        .where(
          (s) =>
              s.property?.type == PropertyType.utility &&
              s.property?.owner == playerId,
        )
        .length;
  }

  int _countPlayerRailroads(String playerId) {
    return _boardSpaces
        .where(
          (s) =>
              s.property?.type == PropertyType.railroad &&
              s.property?.owner == playerId,
        )
        .length;
  }

  // ---- NEW PAYMENT & BANKRUPTCY SYSTEM ----

  void _payRent(Property property, int rent) {
    if (rent == 0) return;
    Player owner = _players.firstWhere((p) => p.id == property.owner);
    _handlePayment(rent, owner);
    if (!currentPlayer.isBankrupt) {
      _gameMessage = 'Paid \$$rent rent to ${owner.name}.';
    }
  }

  void _handleTax(BoardSpace space) {
    int amount = (space.action == 'pay_200') ? 200 : 100;
    _handlePayment(amount, null);
    if (!currentPlayer.isBankrupt) {
      _gameMessage = 'Paid \$$amount Tax.';
    }
  }

  void _handlePayment(int amount, Player? creditor) {
    // 1. Check if enough money
    if (currentPlayer.money >= amount) {
      currentPlayer.subtractMoney(amount);
      if (creditor != null) creditor.addMoney(amount);
      return;
    }

    // 2. Not enough money, try to auto-mortgage
    _gameMessage = 'Insufficient funds! Auto-mortgaging...';
    notifyListeners();

    // Loop through properties to mortgage until we have enough
    int needed = amount - currentPlayer.money;

    // Get unmortgaged properties (sorted by lowest mortgage value first to save big ones? Or doesn't matter much here)
    var mortgageable = currentPlayer.properties
        .map((name) {
          var s = _boardSpaces.firstWhere((sp) => sp.property?.name == name);
          return s.property!;
        })
        .where((p) => !p.isMortgaged)
        .toList();

    for (var prop in mortgageable) {
      if (currentPlayer.money >= amount) break;
      // Mortgage logic
      // First sell houses if any (simplified: auto sell homes to bank?)
      // Note: Standard rules say sell houses first.
      // Current impl simplified: assumes no houses or auto sells them?
      // Let's just mortgage property (getMortgageValue).
      int val = prop.getMortgageValue();
      prop.isMortgaged = true;
      currentPlayer.addMoney(val);
      needed -= val;
    }

    // 3. Check again
    if (currentPlayer.money >= amount) {
      currentPlayer.subtractMoney(amount);
      if (creditor != null) creditor.addMoney(amount);
      _gameMessage = 'Paid \$$amount after mortgaging.';
    } else {
      // 4. BANKRUPTCY
      _handleBankruptcy(creditor);
    }
    notifyListeners();
  }

  void _handleBankruptcy(Player? creditor) {
    _gameMessage = '${currentPlayer.name} is BANKRUPT! Game Over for them.';
    currentPlayer.isBankrupt = true;

    // Transfer everything
    int remainingCash = currentPlayer.money;
    currentPlayer.subtractMoney(remainingCash);

    if (creditor != null) {
      creditor.addMoney(remainingCash);
      // Transfer properties
      for (var propName in List.from(currentPlayer.properties)) {
        var space = _boardSpaces.firstWhere(
          (s) => s.property?.name == propName,
        );
        var prop = space.property!;
        prop.owner = creditor.id;
        creditor.properties.add(propName);
        // According to rules, creditor must pay interest on mortgaged property immediately.
        // Simplified: just transfer logic.
      }
    } else {
      // To Bank: Reset properties
      for (var propName in currentPlayer.properties) {
        var space = _boardSpaces.firstWhere(
          (s) => s.property?.name == propName,
        );
        var prop = space.property!;
        prop.owner = null;
        prop.isMortgaged = false;
        prop.houses = 0;
      }
    }
    currentPlayer.properties.clear();

    // Auto end turn since they are out
    Future.delayed(const Duration(seconds: 3), endTurn);
  }

  // ------------------------------------------

  void buyProperty() {
    BoardSpace space = _boardSpaces[currentPlayer.position];
    Property? property = space.property;

    if (property == null || property.owner != null) return;

    if (currentPlayer.money >= property.price) {
      currentPlayer.subtractMoney(property.price);
      property.owner = currentPlayer.id;
      currentPlayer.addProperty(property.name);
      _gameMessage = 'Bought ${property.name} for \$${property.price}.';
      notifyListeners();
    } else {
      _gameMessage = 'Not enough money!';
      notifyListeners();
    }
  }

  void mortgageProperty(Property property) {
    if (property.isMortgaged) return;
    if (_hasHousesOnGroup(property.group)) {
      _gameMessage = 'Must sell houses in group first!';
      notifyListeners();
      return;
    }
    int value = property.getMortgageValue();
    Player owner = _players.firstWhere((p) => p.id == property.owner);
    owner.addMoney(value);
    property.isMortgaged = true; // Directly set bool
    _gameMessage = '${owner.name} mortgaged ${property.name} for \$$value';
    notifyListeners();
  }

  void unmortgageProperty(Property property) {
    if (!property.isMortgaged) return;
    Player owner = _players.firstWhere((p) => p.id == property.owner);
    int cost = (property.getMortgageValue() * 1.1).round();

    // Use handlePayment? No, unmortgage is voluntary.
    if (owner.money >= cost) {
      owner.subtractMoney(cost);
      property.isMortgaged = false;
      _gameMessage = '${owner.name} unmortgaged ${property.name} for \$$cost';
      notifyListeners();
    } else {
      _gameMessage = 'Not enough money (Need \$$cost)';
      notifyListeners();
    }
  }

  bool _hasHousesOnGroup(PropertyGroup group) {
    return _boardSpaces
        .where((s) => s.property?.group == group)
        .any((s) => (s.property?.houses ?? 0) > 0);
  }

  void buildHouse(String propertyName) {
    var space = _boardSpaces.firstWhere(
      (s) => s.property?.name == propertyName,
    );
    Property? property = space.property;
    if (property == null || property.owner != currentPlayer.id) return;
    if (property.isMortgaged) return;

    if (!_ownsMonopoly(property.group)) {
      _gameMessage = 'Must own full color group to build.';
      notifyListeners();
      return;
    }
    if (_boardSpaces
        .where((s) => s.property?.group == property.group)
        .any((s) => s.property?.isMortgaged ?? false)) {
      _gameMessage = 'Cannot build if any property in group is mortgaged.';
      notifyListeners();
      return;
    }
    if (property.houses >= 5 || currentPlayer.money < property.housePrice)
      return;

    currentPlayer.subtractMoney(property.housePrice);
    property.houses++;
    _gameMessage = 'Built on ${property.name}.';
    notifyListeners();
  }

  bool _ownsMonopoly(PropertyGroup group) {
    var groupProps = _boardSpaces
        .where((s) => s.property?.group == group)
        .map((s) => s.property!)
        .toList();
    if (groupProps.isEmpty) return false;
    return groupProps.every((p) => p.owner == currentPlayer.id);
  }

  void _handleChance() {
    List<Map<String, dynamic>> cards = [
      {'text': 'Advance to GO', 'action': 'move', 'target': 0},
      {'text': 'Bank dividend \$50', 'action': 'money', 'amount': 50},
      {'text': 'Go Back 3 Spaces', 'action': 'move_relative', 'amount': -3},
      {'text': 'Go to Jail', 'action': 'jail'},
      {'text': 'Repairs', 'action': 'repairs'},
      {'text': 'Pay Poor Tax \$15', 'action': 'money', 'amount': -15},
      {
        'text': 'Take a trip to Reading Railroad',
        'action': 'move',
        'target': 5,
      },
      {
        'text': 'Elected Chairman - Pay All \$50',
        'action': 'pay_all',
        'amount': 50,
      },
    ];
    var card = cards[Random().nextInt(cards.length)];
    _gameMessage = 'Chance: ${card['text']}';
    _applyCardEffect(card);
    _currentCardDialog = {
      'title': 'CHANCE',
      'content': card['text'],
      'type': 'chance',
    };
    notifyListeners();
  }

  void _handleCommunityChest() {
    List<Map<String, dynamic>> cards = [
      {'text': 'Advance to GO', 'action': 'move', 'target': 0},
      {
        'text': 'Bank error in your favor \$200',
        'action': 'money',
        'amount': 200,
      },
      {'text': 'Doctor\'s fees \$50', 'action': 'money', 'amount': -50},
      {'text': 'Stock sale \$50', 'action': 'money', 'amount': 50},
      {'text': 'Get Out of Jail Free', 'action': 'jail_free'},
      {'text': 'Go to Jail', 'action': 'jail'},
      {
        'text': 'Grand Opera Night - Collect \$50',
        'action': 'collect_all',
        'amount': 50,
      },
      {'text': 'Holiday Fund \$100', 'action': 'money', 'amount': 100},
    ];
    var card = cards[Random().nextInt(cards.length)];
    _gameMessage = 'Community Chest: ${card['text']}';
    _applyCardEffect(card);
    _currentCardDialog = {
      'title': 'COMMUNITY CHEST',
      'content': card['text'],
      'type': 'community_chest',
    };
    notifyListeners();
  }

  void _applyCardEffect(Map<String, dynamic> card) {
    String action = card['action'];
    switch (action) {
      case 'move':
        int target = card['target'];
        int current = currentPlayer.position;
        // Check PASS GO logic: if target < current (and target is not 10 for jail? No, standard move)
        // Note: Moving BACKWARDS (Go back 3 spaces) is handled in move_relative.
        // If I move from 35 to 5, 5 < 35 -> Passed Go.
        if (target < current && target != 10) {
          currentPlayer.addMoney(200);
        }
        currentPlayer.position = target;
        Future.microtask(() => _handleLanding());
        break;
      case 'move_relative':
        int amount = card['amount'];
        // _movePlayer handles Pass GO logic already!
        _movePlayer(amount);
        Future.microtask(() => _handleLanding());
        break;
      case 'money':
        int amount = card['amount'];
        if (amount > 0)
          currentPlayer.addMoney(amount);
        else
          _handlePayment(amount.abs(), null);
        break;
      case 'jail_free':
        currentPlayer.getOutOfJailCards++;
        _gameMessage = 'Received a Get Out of Jail Free Card!';
        break;
      case 'jail':
        _sendToJail();
        break;
      case 'repairs':
        _handlePayment(50, null);
        break;
      case 'pay_all':
        int amount = card['amount'];
        for (var p in _players) {
          if (p != currentPlayer && !p.isBankrupt) {
            _handlePayment(amount, p);
          }
        }
        break;
      case 'collect_all':
        int amount = card['amount'];
        for (var p in _players) {
          if (p != currentPlayer && !p.isBankrupt) {
            // Other plays pay current player. We can't use _handlePayment easily as 'currentPlayer' is hardcoded there.
            // We need to deduct from p and add to currentPlayer.
            // We should implement p.payOrBankrupt logic?
            // For simplicity, just direct deduct/add or implement handlePaymentFor(p, amount, creditor).
            if (p.money >= amount) {
              p.subtractMoney(amount);
              currentPlayer.addMoney(amount);
            } else {
              // If bot cannot pay, they go bankrupt to currentPlayer?
              // This is getting complex. Let's subtract what they have.
              int avail = p.money;
              p.subtractMoney(avail);
              currentPlayer.addMoney(avail);
            }
          }
        }
        break;
    }
  }

  void _handleCorner(BoardSpace space) {
    if (space.action == 'go_to_jail') {
      _sendToJail();
    }
  }

  void _sendToJail() {
    currentPlayer.goToJail();
    _gameMessage = 'Go to Jail! Turn Ended.';
    _doublesCount = 0;
    _hasRolledDice = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), endTurn);
  }

  void endTurn() {
    if (_isRolling) return;
    _nextTurn();
  }

  void _nextTurn() {
    int activePlayers = _players.where((p) => !p.isBankrupt).length;
    if (activePlayers <= 1) {
      _gameMessage =
          'GAME OVER! Winner is ${_players.firstWhere((p) => !p.isBankrupt).name}';
      notifyListeners();
      return;
    }

    do {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
    } while (currentPlayer.isBankrupt);

    _hasRolledDice = false;
    _doublesCount = 0;
    _gameMessage = '${currentPlayer.name}\'s turn!';
    notifyListeners();

    if (currentPlayer is BotPlayer) {
      _handleBotTurn();
    }
  }

  void _handleBotTurn() {
    Future.delayed(const Duration(seconds: 1), () {
      if (currentPlayer.isInJail) {
        rollDice(); // Simpler jail logic
      } else {
        rollDice();
      }
    });
  }

  void payToLeaveJail() {
    _handlePayment(50, null);
    if (!currentPlayer.isBankrupt) {
      currentPlayer.releaseFromJail();
      _gameMessage = 'Paid \$50 to leave Jail.';
      notifyListeners();
    }
  }

  void useGetOutOfJailCard() {
    if (currentPlayer.getOutOfJailCards > 0 && currentPlayer.isInJail) {
      currentPlayer.getOutOfJailCards--;
      currentPlayer.releaseFromJail();
      _gameMessage = '${currentPlayer.name} used a Get Out of Jail Free Card!';
      notifyListeners();
    }
  }

  // --- Persistence Methods ---

  Future<void> saveGame() async {
    final prefs = await SharedPreferences.getInstance();

    // Serialize Players
    List<Map<String, dynamic>> playersJson = _players
        .map((p) => p.toJson())
        .toList();

    // Serialize Properties (Only owned or modified ones to save space/time, or all)
    List<Map<String, dynamic>> propertiesJson = [];
    for (var space in _boardSpaces) {
      if (space.property != null) {
        propertiesJson.add(space.property!.toJson());
      }
    }

    Map<String, dynamic> gameState = {
      'players': playersJson,
      'properties': propertiesJson,
      'currentPlayerIndex': _currentPlayerIndex,
      'dice1': _dice1,
      'dice2': _dice2,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await prefs.setString('monopoly_save_game', jsonEncode(gameState));
    _hasSaveFile = true;
    _gameMessage = "Game Saved!";
    notifyListeners();
  }

  Future<bool> hasSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('monopoly_save_game');
  }

  Future<bool> loadGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonStr = prefs.getString('monopoly_save_game');
      if (jsonStr == null) return false;

      Map<String, dynamic> gameState = jsonDecode(jsonStr);

      _initGame(); // Reset board to defaults first

      // Restore Players
      List<dynamic> playersList = gameState['players'];
      _players = playersList.map<Player>((pJson) {
        if (pJson['type'] == 'bot') {
          return BotPlayer.fromJson(pJson);
        } else {
          return Player.fromJson(pJson);
        }
      }).toList();

      // Restore Properties
      List<dynamic> propsList = gameState['properties'];
      for (var propJson in propsList) {
        String name = propJson['name'];
        try {
          var space = _boardSpaces.firstWhere((s) => s.property?.name == name);
          space.property!.updateFromJson(propJson);
        } catch (e) {
          print("Error restoring property $name: $e");
        }
      }

      _currentPlayerIndex = gameState['currentPlayerIndex'];
      _dice1 = gameState['dice1'] ?? 1;
      _dice2 = gameState['dice2'] ?? 1;
      _gameMessage =
          "Game Loaded! ${_players[_currentPlayerIndex].name}'s Turn.";

      notifyListeners();
      return true;
    } catch (e) {
      print("Error loading game: $e");
      _gameMessage = "Failed to load game.";
      notifyListeners();
      return false;
    }
  }
}
