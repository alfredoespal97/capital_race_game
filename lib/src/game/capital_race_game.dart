
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';

import 'package:myapp/src/game_state.dart';
import 'package:myapp/src/game/board.dart';
import 'package:myapp/src/models/player.dart';
import 'package:myapp/src/models/bot_player.dart';
import 'package:myapp/src/models/bot_profile.dart';
import 'package:myapp/src/game/player_piece.dart';
import 'package:myapp/src/game/dice.dart';
import 'package:myapp/src/models/tile.dart';
import 'package:myapp/src/models/property.dart';
import 'package:myapp/src/game/tile_component.dart';
import 'package:myapp/src/game/house_component.dart';
import 'package:myapp/src/models/educational_content.dart';
import 'package:myapp/src/game/board_config.dart'; 

enum Turn { player1, bot }

class CapitalRaceGame extends FlameGame {
  late final Board board;
  late final Player player1;
  late final BotPlayer bot;
  late final PlayerPiece player1Piece;
  late final PlayerPiece botPiece;
  late final Dice dice;
  Turn currentTurn = Turn.player1;

  // Getter para obtener todas las propiedades del tablero
  List<Property> get _allProperties => board.properties; // Usamos el nuevo getter

  late GameState globalGameState;

  CapitalRaceGame({required BotProfile botProfile}) {
    player1 = Player(name: 'Jugador 1', capital: 1500, pieceColor: const Color(0xFF3E64FF));
    bot = BotPlayer(name: 'Bot', capital: 1500, pieceColor: const Color(0xFFFF4E4E), profile: botProfile);
    // CORREGIDO: Se instancia 'dice' en el constructor para evitar el LateInitializationError.
    dice = Dice(); 
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _initAudio();
    board = Board();
    add(board);
    player1Piece = PlayerPiece(player: player1, board: board, svgAssetPath: 'assets/images/player_avatar.svg');
    botPiece = PlayerPiece(player: bot, board: board, svgAssetPath: 'assets/images/bot_avatar.svg');
    add(player1Piece);
    add(botPiece);
    dice.position = Vector2(800, 600); // Se configura la posición
    add(dice); // Y se añade al juego
  }

  Future<void> _initAudio() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('background_music.mp3', volume: 0.3);
    await FlameAudio.audioCache.loadAll(['dice_roll.wav', 'buy_property.wav', 'pay_rent.wav', 'move_piece.wav', 'build_house.mp3']);
  }

  void rollDiceAndMove() async {
    if (currentTurn == Turn.player1) {
      FlameAudio.play('dice_roll.wav');
      currentTurn = Turn.bot;
      dice.roll();
      final newIndex = (player1Piece.currentTileIndex + dice.totalRoll) % board.tiles.length;
      await player1Piece.moveTo(newIndex);
      _handleTileAction(player1, newIndex);
      
      if(globalGameState.propertyToBuy == null) {
        _handleBotTurn();
      }
    }
  }

  void _handleBotTurn() {
    Future.delayed(const Duration(seconds: 1), () async {
      FlameAudio.play('dice_roll.wav');
      dice.roll();
      final newIndex = (botPiece.currentTileIndex + dice.totalRoll) % board.tiles.length;
      await botPiece.moveTo(newIndex);
      _handleTileAction(bot, newIndex);
      _executeBotBuildPhase();
      currentTurn = Turn.player1;
    });
  }

  void _handleTileAction(Player player, int tileIndex) {
    final tile = board.tiles[tileIndex];

    if (tile is PropertyTile) {
      final property = tile.property;
      if (property.owner == null) {
        // La propiedad no tiene dueño, la ponemos a la venta
        globalGameState.setPropertyToBuy(property);
      } else if (property.owner != player) {
        // Pagar alquiler
        player.payRent(property);
        property.owner!.receiveRent(property);
        FlameAudio.play('pay_rent.wav');
      } 
    } else if (tile is SpecialTile) {
      // Lógica para casillas especiales (impuestos, etc.)
       switch (tile.type) {
        case SpecialTileType.tax:
          player.pay(200);
          break;
        case SpecialTileType.subsidy:
          player.receive(100);
          break;
        default:
          break;
      }
    } else if (tile is EventTile) {
        globalGameState.setEducationalContent(getRandomEducationalContent(tile.type));
    }
  }

  void playerBuyProperty() {
    final property = globalGameState.propertyToBuy;
    if (property != null && player1.canAfford(property.price)) {
      player1.buyProperty(property);
      FlameAudio.play('buy_property.wav');
    }
    globalGameState.clearPropertyToBuy();
    _handleBotTurn();
  }

  void botDecideBuyOrPass() {
    final property = globalGameState.propertyToBuy;
    if (property != null) {
      if (bot.shouldBuyProperty(property, _allProperties)) {
        if (bot.canAfford(property.price)) {
          bot.buyProperty(property);
          FlameAudio.play('buy_property.wav');
        }
      }
      globalGameState.clearPropertyToBuy();
    }
  }

  void _executeBotBuildPhase() {
    for (final property in bot.ownedProperties.toList()) { 
      if (bot.shouldBuildHouse(property, _allProperties)) {
        bot.buildHouse(property, _allProperties); 
        FlameAudio.play('build_house.mp3');

        final tileIndex = board.tiles.indexWhere((t) => t is PropertyTile && t.property == property);
        if (tileIndex != -1) {
          final tileComp = board.children.firstWhere((c) => c is TileComponent && c.tile == board.tiles[tileIndex]) as TileComponent; 
          final house = HouseComponent(houseNumber: property.houseCount)..position = tileComp.size / 2;
          tileComp.add(house); 
        }
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Podríamos querer escalar o reposicionar elementos aquí si el tamaño cambia.
  }
}
