/// Color seed data
class ColorSeed {
  /// Basic constructor
  const ColorSeed({
    required this.name,
    required this.hex,
    required this.en,
    required this.es,
  });

  /// The original name of the color
  final String name;

  /// The hex code of the color
  final int hex;

  /// The english name of the color
  final String en;

  /// The spanish name of the color
  final String es;
}

/// Seeds for the color
const colorSeeds = <ColorSeed>[
  // 0xFFF5F5DC,
  // 'Beige',
  ColorSeed(
    name: 'Beige',
    hex: 0xFFF5F5DC,
    en: 'Beige',
    es: 'Beige',
  ),
  // 0xFF000000,
  // 'Black',
  ColorSeed(
    name: 'Black',
    hex: 0xFF000000,
    en: 'Black',
    es: 'Negro',
  ),
  // 'Blue',
  // 0xFF2020DA,
  ColorSeed(
    name: 'Blue',
    hex: 0xFF2020DA,
    en: 'Blue',
    es: 'Azul',
  ),
  // 'Brown',
  // 0xFFA52A2A,
  ColorSeed(
    name: 'Brown',
    hex: 0xFFA52A2A,
    en: 'Brown',
    es: 'Marrón',
  ),
  // 'Coral',
  // 0xFFFF7F50,
  ColorSeed(
    name: 'Coral',
    hex: 0xFFFF7F50,
    en: 'Coral',
    es: 'Coral',
  ),
  // 'Gold',
  // 0xFFFFD700,
  ColorSeed(
    name: 'Gold',
    hex: 0xFFFFD700,
    en: 'Gold',
    es: 'Dorado',
  ),
  // 'Gray',
  // 0xFF808080,
  ColorSeed(
    name: 'Gray',
    hex: 0xFF808080,
    en: 'Gray',
    es: 'Gris',
  ),
  // 'Green',
  // 0xFF008000,
  ColorSeed(
    name: 'Green',
    hex: 0xFF008000,
    en: 'Green',
    es: 'Verde',
  ),
  // 'Maroon',
  // 0xFF800000,
  ColorSeed(
    name: 'Maroon',
    hex: 0xFF800000,
    en: 'Maroon',
    es: 'Granate',
  ),
  // 'Multicolor',
  // 0xFF000000,
  ColorSeed(
    name: 'Multicolor',
    hex: 0xFF000000,
    en: 'Multicolor',
    es: 'Multicolor',
  ),
  // 'Navy',
  // 0xFF000080,
  ColorSeed(
    name: 'Navy',
    hex: 0xFF000080,
    en: 'Navy',
    es: 'Navy',
  ),
  // 'Olive',
  // 0xFF808000,
  ColorSeed(
    name: 'Olive',
    hex: 0xFF808000,
    en: 'Olive',
    es: 'Olivo',
  ),
  // 'Orange',
  // 0xFFFFA500,
  ColorSeed(
    name: 'Orange',
    hex: 0xFFFFA500,
    en: 'Orange',
    es: 'Naranja',
  ),
  // 'Pink',
  // 0xFFFFC0CB,
  ColorSeed(
    name: 'Pink',
    hex: 0xFFFFC0CB,
    en: 'Pink',
    es: 'Rosa',
  ),
  // 'Purple',
  // 0xFF800080,
  ColorSeed(
    name: 'Purple',
    hex: 0xFF800080,
    en: 'Purple',
    es: 'Morado',
  ),
  // 'Red',
  // 0xFFFF0000,
  ColorSeed(
    name: 'Red',
    hex: 0xFFFF0000,
    en: 'Red',
    es: 'Rojo',
  ),
  // 'Silver',
  // 0xFFC0C0C0,
  ColorSeed(
    name: 'Silver',
    hex: 0xFFC0C0C0,
    en: 'Silver',
    es: 'Plateado',
  ),
  // 'Teal',
  // 0xFF008080,
  ColorSeed(
    name: 'Teal',
    hex: 0xFF008080,
    en: 'Teal',
    es: 'Verde azulado',
  ),
  // 'Turquoise',
  // 0xFF40E0D0,
  ColorSeed(
    name: 'Turquoise',
    hex: 0xFF40E0D0,
    en: 'Turquoise',
    es: 'Turquesa',
  ),
  // 'White',
  // 0xFFFFFFFF,
  ColorSeed(
    name: 'White',
    hex: 0xFFFFFFFF,
    en: 'White',
    es: 'Blanco',
  ),
  // 'Yellow',
  // 0xFFFFFF00,
  ColorSeed(
    name: 'Yellow',
    hex: 0xFFFFFF00,
    en: 'Yellow',
    es: 'Amarillo',
  ),
];
