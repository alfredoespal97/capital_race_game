

class EducationalContent {
  final String sector;
  final String title;
  final String text;
  final String iconAsset; // Ruta a un icono representativo del sector

  const EducationalContent({
    required this.sector,
    required this.title,
    required this.text,
    required this.iconAsset,
  });
}

// Una pequeña "biblioteca" de contenido educativo para empezar
final Map<String, EducationalContent> educationalContentLibrary = {
  'Agricultura': const EducationalContent(
    sector: 'Agricultura',
    title: 'Impacto del Sector Agrícola',
    text: 'La agricultura es la base de nuestra cadena alimentaria. Un sector agrícola fuerte garantiza la seguridad alimentaria, genera empleo en zonas rurales y es clave para la exportación. En el juego, controlar este sector te da ingresos estables.',
    iconAsset: 'assets/icons/agriculture.svg', // Necesitaremos crear estos iconos
  ),
  'Tecnología': const EducationalContent(
    sector: 'Tecnología',
    title: 'El Motor de la Innovación',
    text: 'El sector tecnológico impulsa la productividad en toda la economía. Desde software hasta hardware, la innovación aquí crea nuevas industrias y trabajos de alto valor. En el juego, este sector tiene un alto potencial de crecimiento y rentabilidad.',
    iconAsset: 'assets/icons/technology.svg',
  ),
  'Industria': const EducationalContent(
    sector: 'Industria',
    title: 'La Fuerza de la Producción',
    text: 'La industria transforma materias primas en bienes de consumo. Un sector industrial robusto reduce la dependencia de las importaciones y crea una base económica sólida. Las propiedades industriales suelen tener costos de mejora altos pero rentas muy lucrativas.',
    iconAsset: 'assets/icons/industry.svg',
  ),
  // Podríamos añadir más contenido para otros sectores aquí
};
