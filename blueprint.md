# Capital Race - Blueprint de Desarrollo (Versión Final)

## Descripción General

"Capital Race" es un juego de mesa digital de estrategia económica, implementado en Flutter con el motor Flame. El objetivo es que los jugadores tomen decisiones de inversión inteligentes para aumentar su capital y dominar el tablero. El juego cuenta con un oponente de IA con perfiles de comportamiento personalizables y un componente educativo que introduce conceptos financieros básicos de forma contextual.

---

## Características Principales (Completadas)

### 1. Bucle de Juego Central
*   **Motor Flame:** Construido sobre una base sólida con el motor de juegos Flame.
*   **Tablero Interactivo:** Un tablero de juego visualmente atractivo con casillas de propiedad, salida y otros elementos.
*   **Sistema de Turnos:** Flujo de turnos robusto que alterna entre el jugador humano y el bot de IA.
*   **Dados y Movimiento:** Piezas de jugador que se mueven por el tablero según el resultado de un lanzamiento de dados virtual, con efectos de sonido y animación de movimiento.

### 2. Sistema Económico
*   **Propiedades y Sectores:** El tablero se divide en propiedades agrupadas por sectores de color.
*   **Compra de Activos:** Los jugadores pueden comprar propiedades si caen en una casilla libre y tienen el capital necesario.
*   **Pago de Alquiler:** Si un jugador cae en una propiedad que pertenece a otro, debe pagar un alquiler, que aumenta con las mejoras.
*   **Gestión de Capital:** El capital de cada jugador se actualiza en tiempo real en la interfaz.

### 3. Profundidad Estratégica
*   **Monopolios:** Para construir mejoras, un jugador debe poseer todas las propiedades de un mismo sector (monopolio), añadiendo una capa estratégica clave.
*   **Construcción de Casas:** Los jugadores con un monopolio pueden invertir en la construcción de hasta 4 casas en sus propiedades.
*   **Alquiler Dinámico:** El coste del alquiler de una propiedad aumenta significativamente con cada casa construida, incentivando la inversión.

### 4. Oponente de IA Inteligente
*   **Perfiles de Dificultad:** El jugador puede elegir entre tres perfiles de bot antes de empezar: `Conservador`, `Equilibrado` y `Agresivo`.
*   **Toma de Decisiones (Valor Esperado):** El bot no compra al azar. Calcula un "Valor Esperado" para cada propiedad, considerando la rentabilidad, su afinidad por el sector (según su perfil) y el precio.
*   **Estrategia de Monopolio:** La IA prioriza activamente la compra de propiedades que le permitan completar o acercarse a un monopolio, otorgando un "bonus" estratégico en su cálculo de Valor Esperado.
*   **Lógica de Construcción Inteligente:** El bot solo construye casas cuando tiene un monopolio y su capital se lo permite, en línea con su perfil de agresividad y umbral de liquidez.

### 5. Componente Educativo
*   **Popups Contextuales:** Al comprar la primera propiedad de un nuevo sector, aparece un popup no intrusivo.
*   **Contenido Financiero:** Cada popup explica un concepto financiero básico relacionado con el sector (ej: "Tecnología - Innovación y Riesgo", "Bienes Raíces - Flujo de Caja").
*   **Diseño Atractivo:** Los popups tienen un diseño visualmente agradable con iconos y tipografía clara para facilitar la lectura.

### 6. Interfaz y Experiencia de Usuario (UI/UX)
*   **HUD de Jugador:** Cada jugador tiene un "Head-Up Display" que muestra su avatar, nombre, capital actual y una lista de propiedades poseídas.
*   **Diálogos Interactivos:** El juego utiliza diálogos para acciones clave como la decisión de comprar una propiedad.
*   **Feedback Visual:** Las casas construidas aparecen visualmente en las casillas del tablero.
*   **Sistema de Audio:** Música de fondo para ambientar la partida y efectos de sonido para acciones importantes (lanzar dados, comprar, pagar alquiler, construir), mejorando la inmersión.

---

## Estado del Proyecto

**Completado.**

El juego ha alcanzado todos los objetivos de diseño y funcionalidad establecidos para este ciclo de desarrollo. Es una experiencia jugable, completa y pulida desde el inicio (selección de dificultad) hasta el final del bucle de juego.

---

## Posibles Mejoras Futuras

Aunque el juego está completo en su versión actual, la base de código es robusta y permite futuras expansiones. Algunas ideas incluyen:

*   **Sistema de Subastas:** Implementar una subasta cuando un jugador decide no comprar una propiedad en la que ha caído.
*   **Casillas de Evento:** Añadir casillas de "Caja de Comunidad" o "Suerte" que activen eventos aleatorios (positivos o negativos).
*   **Lógica de Victoria/Derrota:** Definir condiciones claras para el final del juego (ej: un jugador se queda sin capital o se alcanza un número de turnos).
*   **Guardado de Partida:** Utilizar Hive (que ya está inicializado) para permitir a los jugadores guardar y reanudar sus partidas.
*   **Soporte Multijugador:** Expandir el juego para permitir partidas con más jugadores, ya sea en el mismo dispositivo (local) o en línea.
