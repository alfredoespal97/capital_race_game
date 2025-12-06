# 🎲 Monopoly Game - Flutter Edition

Un juego de Monopoly completo y moderno desarrollado con Flutter. Disfruta del clásico juego de mesa en tu navegador o dispositivo móvil con gráficos modernos y una interfaz intuitiva.

## ✨ Características

### 🎮 Gameplay Completo
- **Tablero Interactivo**: Tablero de Monopoly completo con las 40 casillas clásicas
- **2-6 Jugadores**: Soporta de 2 a 6 jugadores simultáneos
- **Dados Animados**: Dados 3D con animaciones realistas
- **Sistema de Turnos**: Gestión automática de turnos con indicadores visuales

### 🏠 Propiedades y Construcción
- **Compra de Propiedades**: Compra calles, estaciones de tren y servicios públicos
- **Construcción**: Construye casas y hoteles en tus propiedades
- **Monopolios**: Completa grupos de colores para aumentar las rentas
- **Hipotecas**: Sistema de hipotecas para obtener efectivo rápido

### 💰 Sistema Económico
- **Dinero Inicial**: Cada jugador comienza con $1,500
- **Cobro de Rentas**: Sistema automático de cobro de rentas
- **Impuestos**: Impuesto sobre la renta y impuesto de lujo
- **Pasa por GO**: Cobra $200 cada vez que pasas por GO

### 🎴 Tarjetas
- **Suerte**: Tarjetas de Suerte con eventos aleatorios
- **Caja de Comunidad**: Tarjetas de Caja de Comunidad con premios y penalizaciones

### 🚔 Sistema de Cárcel
- **Ir a la Cárcel**: Múltiples formas de ir a la cárcel
- **Salir de la Cárcel**: Paga $50, saca dobles, o usa una tarjeta de "Salir de la Cárcel"
- **Contador de Turnos**: Sistema automático de conteo de turnos en la cárcel

### 🎨 Diseño Moderno
- **Interfaz Premium**: Diseño moderno con gradientes y animaciones
- **Responsive**: Se adapta a diferentes tamaños de pantalla
- **Tema Oscuro**: Paleta de colores elegante y profesional
- **Iconos Personalizados**: Cada jugador tiene su propio icono y color

## 🚀 Cómo Jugar

### Inicio del Juego
1. Haz clic en "NEW GAME" en la pantalla principal
2. Selecciona el número de jugadores (2-6)
3. Personaliza los nombres de los jugadores
4. Haz clic en "START GAME"

### Durante el Juego
1. **Tirar Dados**: Haz clic en "ROLL DICE" para lanzar los dados
2. **Comprar Propiedades**: Cuando caigas en una propiedad sin dueño, haz clic en "BUY"
3. **Construir**: Usa el botón "BUILD" para construir casas y hoteles
4. **Terminar Turno**: Haz clic en "END TURN" cuando hayas terminado

### Reglas Especiales
- **Dobles**: Si sacas dobles, vuelves a tirar
- **Tres Dobles**: Si sacas tres dobles seguidos, vas a la cárcel
- **Bancarrota**: Si no puedes pagar, quedas en bancarrota
- **Victoria**: El último jugador que no esté en bancarrota gana

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo multiplataforma
- **Provider**: Gestión de estado
- **Google Fonts**: Tipografía moderna (Poppins)
- **Material Design 3**: Sistema de diseño moderno

## 📦 Instalación

### Requisitos Previos
- Flutter SDK (3.9.0 o superior)
- Dart SDK
- Chrome (para desarrollo web)

### Pasos de Instalación

```bash
# Clonar el repositorio
git clone https://github.com/alfredoespal97/capital_race_game.git

# Navegar al directorio
cd capital_race_game

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run -d chrome
```

## 🎯 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── data/
│   └── board_data.dart      # Datos del tablero (40 casillas)
├── models/
│   ├── player.dart          # Modelo de jugador
│   └── property.dart        # Modelo de propiedad y casilla
├── providers/
│   └── game_provider.dart   # Lógica del juego
├── screens/
│   ├── home_screen.dart     # Pantalla de inicio
│   └── game_screen.dart     # Pantalla de juego
└── widgets/
    ├── board_widget.dart           # Tablero de juego
    ├── dice_widget.dart            # Dados animados
    ├── game_controls.dart          # Controles del juego
    ├── player_info_panel.dart      # Panel de información de jugadores
    └── player_setup_dialog.dart    # Diálogo de configuración
```

## 🎮 Características del Tablero

### Propiedades por Color
- **Marrón**: Mediterranean Ave, Baltic Ave
- **Azul Claro**: Oriental Ave, Vermont Ave, Connecticut Ave
- **Rosa**: St. Charles Place, States Ave, Virginia Ave
- **Naranja**: St. James Place, Tennessee Ave, New York Ave
- **Rojo**: Kentucky Ave, Indiana Ave, Illinois Ave
- **Amarillo**: Atlantic Ave, Ventnor Ave, Marvin Gardens
- **Verde**: Pacific Ave, North Carolina Ave, Pennsylvania Ave
- **Azul Oscuro**: Park Place, Boardwalk

### Estaciones de Tren
- Reading Railroad
- Pennsylvania Railroad
- B&O Railroad
- Short Line

### Servicios Públicos
- Electric Company
- Water Works

## 🎨 Personalización

El juego permite personalizar:
- Nombres de jugadores
- Colores de fichas
- Iconos de jugadores

## 🐛 Solución de Problemas

### La aplicación no se ejecuta
```bash
flutter clean
flutter pub get
flutter run
```

### Errores de compilación
```bash
dart fix --apply
flutter analyze
```

## 📝 Próximas Características

- [ ] Modo multijugador en línea
- [ ] Guardado de partidas
- [ ] Estadísticas de jugadores
- [ ] Más temas visuales
- [ ] Efectos de sonido
- [ ] Animaciones mejoradas
- [ ] IA para jugadores bot

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Haz fork del proyecto
2. Crea una rama para tu característica (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👨‍💻 Autor

**Alfredo Espallargas**
- GitHub: [@alfredoespal97](https://github.com/alfredoespal97)

## 🙏 Agradecimientos

- Hasbro por el juego original de Monopoly
- La comunidad de Flutter por las excelentes herramientas
- Google Fonts por las tipografías

---

¡Disfruta del juego! 🎲🏠💰
