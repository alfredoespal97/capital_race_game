import 'package:flutter/material.dart';
import 'dart:math';
import '../models/player.dart';
import '../models/property.dart';
import '../models/bot_player.dart';
import '../data/board_data.dart';
import 'dart:async'; // For Timer/Future

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

  Map<String, dynamic>? _currentCardDialog;
  Map<String, dynamic>? get currentCardDialog => _currentCardDialog;

  GameProvider() {
    _initGame();
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

  // --- Card Dialog Logic ---
  void clearCardDialog() {
    _currentCardDialog = null;
    notifyListeners();
    // Logic after dialog closes:
    // If Bot, it means the "viewing time" is over, proceed to end turn.
    if (isCurrentPlayerBot) {
      Future.delayed(const Duration(milliseconds: 500), endTurn);
    }
    // If Human, they just closed the dialog, now they are back to board,
    // and can choose to End Turn (or do other things if allowed).
    // The dialog interaction is effectively "done".
  }

  Future<void> rollDice() async {
    if (_isRolling ||
        (_hasRolledDice && _doublesCount == 0 && !currentPlayer.isInJail))
      return;

    _isRolling = true;
    notifyListeners();

    // Animation effect
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      _dice1 = Random().nextInt(6) + 1;
      _dice2 = Random().nextInt(6) + 1;
      notifyListeners();
    }

    _isRolling = false;
    _dice1 = Random().nextInt(6) + 1;
    _dice2 = Random().nextInt(6) + 1;
    // For testing:
    // _dice1 = 5; _dice2 = 5;

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

      // Allow UI to update before processing landing
      await Future.delayed(const Duration(milliseconds: 500));
      _handleLanding();

      if (isDoubles) {
        _gameMessage += ' Doubles! Roll again.';
        _hasRolledDice =
            false; // Allow rolling again, NO automatic continuation
        if (isCurrentPlayerBot) {
          // Bot needs to roll again automatically
          Future.delayed(const Duration(seconds: 1), rollDice);
        }
      } else {
        // Not doubles.
        if (currentPlayer is! BotPlayer) {
          // Human: Wait for End Turn click.
          _gameMessage += ' Turn complete.';
        }
        // Bot: _handleLanding handles its own turn ending logic.
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
      // If doubles to get out, normally you move and play.
      // If Human -> End Turn manually or roll again? Rules say "move number rolled". usually turn ends unless doubles meant "roll again" (Monopoly rules vary on getting out with doubles).
      // Standard: Roll doubles -> Get out -> Move -> Turn Ends (do not roll again).

      if (currentPlayer is BotPlayer) {
        Future.delayed(const Duration(seconds: 1), endTurn);
      } else {
        _hasRolledDice = true; // Prevent re-roll
      }
    } else {
      currentPlayer.jailTurns++;
      if (currentPlayer.jailTurns >= 3) {
        currentPlayer.subtractMoney(50);
        currentPlayer.releaseFromJail();
        _gameMessage =
            '${currentPlayer.name} paid \$50 to get out (3 attempts).';
        _movePlayer(_dice1 + _dice2);
        _handleLanding();
        if (currentPlayer is BotPlayer) {
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
        if (isBot) Future.delayed(const Duration(seconds: 1), endTurn);
        break;
      case SpaceType.corner:
        _handleCorner(space);
        // If corner is Go to Jail, it checks inside _handleCorner -> _sendToJail -> endTurn
        // If Just Visiting or Free Parking:
        if (space.action != 'go_to_jail' && isBot) {
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
        // Bot decision (calls endTurn internally)
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
      // If bot landed on owned/mortgaged property, end turn
      if (currentPlayer is BotPlayer) {
        Future.delayed(const Duration(seconds: 1), endTurn);
      }
    }
  }

  int _calculateRent(Property property) {
    if (property.isMortgaged) return 0;

    if (property.type == PropertyType.utility) {
      int count = _countPlayerUtilities(property.owner!);
      // Counts include mortgaged properties for ownership count
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

  void _payRent(Property property, int rent) {
    if (rent == 0) return;
    Player owner = _players.firstWhere((p) => p.id == property.owner);
    currentPlayer.subtractMoney(rent);
    owner.addMoney(rent);
    _gameMessage = 'Paid \$$rent rent to ${owner.name}.';

    if (currentPlayer.isBankrupt) {
      _handleBankruptcy(owner);
    }
  }

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
    property.isMortgaged = true;
    _gameMessage = '${owner.name} mortgaged ${property.name} for \$$value';
    notifyListeners();
  }

  void unmortgageProperty(Property property) {
    if (!property.isMortgaged) return;
    Player owner = _players.firstWhere((p) => p.id == property.owner);

    int cost = (property.getMortgageValue() * 1.1).round();
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
    // Find property
    var space = _boardSpaces.firstWhere(
      (s) => s.property?.name == propertyName,
    );
    Property? property = space.property;
    if (property == null) return;

    if (property.owner != currentPlayer.id) return;

    if (property.isMortgaged) {
      _gameMessage = 'Cannot build on mortgaged property.';
      notifyListeners();
      return;
    }

    if (!_ownsMonopoly(property.group)) {
      _gameMessage = 'Must own full color group to build.';
      notifyListeners();
      return;
    }

    bool anyMortgaged = _boardSpaces
        .where((s) => s.property?.group == property.group)
        .any((s) => s.property?.isMortgaged ?? false);

    if (anyMortgaged) {
      _gameMessage = 'Cannot build if any property in group is mortgaged.';
      notifyListeners();
      return;
    }

    if (property.houses >= 5) {
      _gameMessage = 'Max buildings reached.';
      notifyListeners();
      return;
    }

    if (currentPlayer.money >= property.housePrice) {
      currentPlayer.subtractMoney(property.housePrice);
      property.houses++;
      String type = property.houses == 5 ? 'Hotel' : 'House';
      _gameMessage = 'Built a $type on ${property.name}.';
      notifyListeners();
    } else {
      _gameMessage = 'Not enough money.';
      notifyListeners();
    }
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

    // Show Dialog
    _currentCardDialog = {
      'title': 'CHANCE',
      'content': card['text'],
      'type': 'chance',
    };
    notifyListeners();
    // Turn is NOT ended here. It waits for dialog cycle.
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

    // Show Dialog
    _currentCardDialog = {
      'title': 'COMMUNITY CHEST',
      'content': card['text'],
      'type': 'community_chest',
    };
    notifyListeners();
    // Turn is NOT ended here.
  }

  void _applyCardEffect(Map<String, dynamic> card) {
    String action = card['action'];
    switch (action) {
      case 'move':
        int target = card['target'];
        if (target == 0 && currentPlayer.position > 0)
          currentPlayer.addMoney(200);
        currentPlayer.position = target;
        // Do NOT recurse _handleLanding for target unless advanced rules.
        // Standard Monopoly: If you advance to Utility (e.g. Reading RR), you handle it if unowned.
        // For simplicity, we won't chain landings infinite, but we SHOULD handle the target landing.
        Future.microtask(() => _handleLanding());
        break;
      case 'move_relative':
        int amount = card['amount'];
        _movePlayer(
          amount,
        ); // Reuse move logic which calls handleLanding via movePlayer? No movePlayer only moves.
        // We need to handle landing after move.
        Future.microtask(() => _handleLanding());
        break;
      case 'money':
        int amount = card['amount'];
        if (amount > 0)
          currentPlayer.addMoney(amount);
        else
          currentPlayer.subtractMoney(amount.abs());
        break;
      case 'jail':
        _sendToJail();
        break;
      case 'repairs':
        currentPlayer.subtractMoney(50);
        break;
      case 'pay_all':
        int amount = card['amount'];
        for (var p in _players) {
          if (p != currentPlayer && !p.isBankrupt) {
            currentPlayer.subtractMoney(amount);
            p.addMoney(amount);
          }
        }
        break;
      case 'collect_all':
        int amount = card['amount'];
        for (var p in _players) {
          if (p != currentPlayer && !p.isBankrupt) {
            p.subtractMoney(amount);
            currentPlayer.addMoney(amount);
          }
        }
        break;
    }
  }

  void _handleTax(BoardSpace space) {
    if (space.action == 'pay_200') {
      currentPlayer.subtractMoney(200);
      _gameMessage = 'Paid \$200 Income Tax.';
    } else {
      currentPlayer.subtractMoney(100);
      _gameMessage = 'Paid \$100 Luxury Tax.';
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
    _hasRolledDice = true; // Block rolling
    notifyListeners();

    // Jail ALWAYS ends turn automatically for everyone after a brief delay
    Future.delayed(const Duration(seconds: 2), endTurn);
  }

  void endTurn() {
    if (_isRolling) return;
    _nextTurn();
  }

  void _nextTurn() {
    do {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
    } while (currentPlayer.isBankrupt &&
        _players.where((p) => !p.isBankrupt).length > 1);

    _hasRolledDice = false;
    _doublesCount = 0;
    _gameMessage = '${currentPlayer.name}\'s turn!';
    notifyListeners();

    if (currentPlayer is BotPlayer) {
      _handleBotTurn();
    }
  }

  void _handleBotTurn() {
    // Bot logic: Roll, then decisions happen in Landing.
    Future.delayed(const Duration(seconds: 1), () {
      if (currentPlayer.isInJail) {
        // Simple jail strategy
        rollDice();
      } else {
        rollDice();
      }
    });
  }

  void _handleBankruptcy(Player? creditor) {
    _gameMessage = '${currentPlayer.name} went Bankrupt!';
    for (var s in _boardSpaces) {
      if (s.property?.owner == currentPlayer.id) {
        s.property!.owner = null;
        s.property!.houses = 0;
        s.property!.isMortgaged = false;
      }
    }
    currentPlayer.properties.clear();
    notifyListeners();
  }

  void payToLeaveJail() {
    if (currentPlayer.money >= 50) {
      currentPlayer.subtractMoney(50);
      currentPlayer.releaseFromJail();
      _gameMessage = 'Paid \$50 to leave Jail.';
      notifyListeners();
    }
  }
}
