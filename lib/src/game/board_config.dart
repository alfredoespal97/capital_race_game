
import 'package:flutter/material.dart';
import 'package:myapp/src/models/property.dart';
import 'package:myapp/src/models/tile.dart';
import 'package:myapp/src/models/educational_content.dart'; // Importación añadida

final Map<String, Color> sectorColors = {
  'Agricultura': Colors.green.shade700,
  'Tecnología': Colors.blue.shade800,
  'Industria': Colors.orange.shade900,
  'Transporte': Colors.red.shade600,
  'Lujo': Colors.purple.shade800,
  'Genérico': Colors.grey.shade600,
};

final List<Tile> boardTiles = [
  SpecialTile(name: 'Salida'),
  PropertyTile(property: Property(name: 'Trigo', price: 60, sector: 'Agricultura', houseCost: 50, rentByHouseCount: [2, 10, 30, 90, 160, 250])),
  PropertyTile(property: Property(name: 'Ganado', price: 60, sector: 'Agricultura', houseCost: 50, rentByHouseCount: [4, 20, 60, 180, 320, 450])),
  SpecialTile(name: 'Impuestos'),
  PropertyTile(property: Property(name: 'Software', price: 100, sector: 'Tecnología', houseCost: 50, rentByHouseCount: [6, 30, 90, 270, 400, 550])),
  EventTile(name: 'Evento Económico'),
  PropertyTile(property: Property(name: 'Electrónica', price: 100, sector: 'Tecnología', houseCost: 50, rentByHouseCount: [6, 30, 90, 270, 400, 550])),
  PropertyTile(property: Property(name: 'Automatización', price: 120, sector: 'Tecnología', houseCost: 50, rentByHouseCount: [8, 40, 100, 300, 450, 600])),
  SpecialTile(name: 'Subsidio'),
  PropertyTile(property: Property(name: 'Textiles', price: 140, sector: 'Industria', houseCost: 100, rentByHouseCount: [10, 50, 150, 450, 625, 750])),
  PropertyTile(property: Property(name: 'Automotriz', price: 140, sector: 'Industria', houseCost: 100, rentByHouseCount: [10, 50, 150, 450, 625, 750])),
  EventTile(name: 'Crisis Financiera'),
  PropertyTile(property: Property(name: 'Acero', price: 160, sector: 'Industria', houseCost: 100, rentByHouseCount: [12, 60, 180, 500, 700, 900])),
  SpecialTile(name: 'Inversión Extranjera'),
  PropertyTile(property: Property(name: 'Aerolínea', price: 180, sector: 'Transporte', houseCost: 100, rentByHouseCount: [14, 70, 200, 550, 750, 950])),
  PropertyTile(property: Property(name: 'Ferrocarril', price: 200, sector: 'Transporte', houseCost: 100, rentByHouseCount: [16, 80, 220, 600, 800, 1000])),
  PropertyTile(property: Property(name: 'Propiedad 17', price: 220, sector: 'Genérico', houseCost: 150, rentByHouseCount: [18, 90, 250, 700, 875, 1050])),
  PropertyTile(property: Property(name: 'Propiedad 18', price: 220, sector: 'Genérico', houseCost: 150, rentByHouseCount: [18, 90, 250, 700, 875, 1050])),
  SpecialTile(name: 'Descanso'),
  PropertyTile(property: Property(name: 'Propiedad 20', price: 240, sector: 'Genérico', houseCost: 150, rentByHouseCount: [20, 100, 300, 750, 925, 1100])),
  PropertyTile(property: Property(name: 'Propiedad 21', price: 260, sector: 'Genérico', houseCost: 150, rentByHouseCount: [22, 110, 330, 800, 975, 1150])),
  EventTile(name: 'Burbuja Tecnológica'),
  PropertyTile(property: Property(name: 'Propiedad 23', price: 260, sector: 'Genérico', houseCost: 150, rentByHouseCount: [22, 110, 330, 800, 975, 1150])),
  PropertyTile(property: Property(name: 'Propiedad 24', price: 280, sector: 'Genérico', houseCost: 150, rentByHouseCount: [24, 120, 360, 850, 1025, 1200])),
  SpecialTile(name: 'Auditoría'),
  PropertyTile(property: Property(name: 'Propiedad 26', price: 300, sector: 'Lujo', houseCost: 200, rentByHouseCount: [26, 130, 390, 900, 1100, 1275])),
  PropertyTile(property: Property(name: 'Propiedad 27', price: 300, sector: 'Lujo', houseCost: 200, rentByHouseCount: [26, 130, 390, 900, 1100, 1275])),
  EventTile(name: 'Descubrimiento'),
  PropertyTile(property: Property(name: 'Propiedad 29', price: 320, sector: 'Lujo', houseCost: 200, rentByHouseCount: [28, 150, 450, 1000, 1200, 1400])),
  PropertyTile(property: Property(name: 'Propiedad 30', price: 350, sector: 'Lujo', houseCost: 200, rentByHouseCount: [35, 175, 500, 1100, 1300, 1500])),
  SpecialTile(name: 'Bono del Gobierno'),
  PropertyTile(property: Property(name: 'Propiedad 32', price: 400, sector: 'Lujo', houseCost: 200, rentByHouseCount: [50, 200, 600, 1400, 1700, 2000])),
];

// DATOS EDUCATIVOS AÑADIDOS
final List<EducationalContent> educationalContentData = [
  EducationalContent(
    sector: 'Agricultura',
    title: 'Inversión en Agricultura',
    text: 'La agricultura es la base de la economía. Al invertir aquí, aseguras el suministro de alimentos y materias primas. ¡Una apuesta segura y estable!',
    iconAsset: 'assets/images/sector_agricultura.svg',
  ),
  EducationalContent(
    sector: 'Tecnología',
    title: 'Potencial de la Tecnología',
    text: 'El sector tecnológico es volátil pero ofrece los mayores retornos. Invierte en innovación para liderar el mercado del futuro.',
    iconAsset: 'assets/images/sector_tecnologia.svg',
  ),
  EducationalContent(
    sector: 'Industria',
    title: 'El Motor de la Industria',
    text: 'La industria transforma materias primas en productos valiosos. Controlar este sector te da poder sobre la cadena de producción.',
    iconAsset: 'assets/images/sector_industria.svg',
  ),
  EducationalContent(
    sector: 'Transporte',
    title: 'Conectando el Mundo: Transporte',
    text: 'Sin transporte, no hay comercio. Ser dueño de las rutas logísticas te garantiza un flujo constante de ingresos de todos los demás sectores.',
    iconAsset: 'assets/images/sector_transporte.svg',
  ),
  EducationalContent(
    sector: 'Lujo',
    title: 'El Mercado del Lujo',
    text: 'Los bienes de lujo tienen altos márgenes y una clientela exclusiva. Es una inversión de prestigio con enormes ganancias potenciales.',
    iconAsset: 'assets/images/sector_lujo.svg',
  ),
  EducationalContent(
    sector: 'Genérico',
    title: 'Sector Diversificado',
    text: 'Este sector representa una mezcla de oportunidades de inversión. Es ideal para diversificar tu cartera y mitigar riesgos.',
    iconAsset: 'assets/images/sector_generico.svg',
  ),
];
