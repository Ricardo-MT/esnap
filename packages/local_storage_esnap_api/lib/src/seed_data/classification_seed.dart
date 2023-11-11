// ignore_for_file: constant_identifier_names

/// Classification types seed data
enum ClassificationType {
  /// Top (e.g. shirt, blouse, sweater, etc.)
  Top,

  /// Bottom (e.g. pants, shorts, etc.)
  Bottom,

  /// Shoes (e.g. sneakers, heels, etc.)
  Shoes,

  /// Assorted (e.g. accesories, bags, etc.)
  Other
}

/// Classification seed data
class ClassificationSeed {
  /// Basic constructor
  const ClassificationSeed({
    required this.name,
    required this.classificationType,
    required this.en,
    required this.es,
  });

  /// The original name of the classification
  final String name;

  /// The classification type
  final ClassificationType classificationType;

  /// The english name of the classification
  final String en;

  /// The spanish name of the classification
  final String es;
}

/// Seeds for the classification
const classificationSeeds = [
  ClassificationSeed(
    name: 'Accessory',
    classificationType: ClassificationType.Top,
    en: 'Accessory',
    es: 'Accesorio',
  ),
  ClassificationSeed(
    name: 'Activewear',
    classificationType: ClassificationType.Top,
    en: 'Activewear',
    es: 'Ropa deportiva',
  ),
  ClassificationSeed(
    name: 'Bag',
    classificationType: ClassificationType.Other,
    en: 'Bag',
    es: 'Bolso',
  ),
  ClassificationSeed(
    name: 'Blouse',
    classificationType: ClassificationType.Top,
    en: 'Blouse',
    es: 'Blusa',
  ),
  ClassificationSeed(
    name: 'Boots',
    classificationType: ClassificationType.Shoes,
    en: 'Boots',
    es: 'Botas',
  ),
  ClassificationSeed(
    name: 'Bottom',
    classificationType: ClassificationType.Bottom,
    en: 'Bottom',
    es: 'Parte inferior',
  ),
  ClassificationSeed(
    name: 'Dress',
    classificationType: ClassificationType.Top,
    en: 'Dress',
    es: 'Vestido',
  ),
  ClassificationSeed(
    name: 'Gloves',
    classificationType: ClassificationType.Other,
    en: 'Gloves',
    es: 'Guantes',
  ),
  ClassificationSeed(
    name: 'Headwear',
    classificationType: ClassificationType.Top,
    en: 'Headwear',
    es: 'Accesorios para la cabeza',
  ),
  ClassificationSeed(
    name: 'Heels',
    classificationType: ClassificationType.Shoes,
    en: 'Heels',
    es: 'Tacones',
  ),
  ClassificationSeed(
    name: 'Jacket',
    classificationType: ClassificationType.Top,
    en: 'Jacket',
    es: 'Chaqueta',
  ),
  ClassificationSeed(
    name: 'Jewelry',
    classificationType: ClassificationType.Top,
    en: 'Jewelry',
    es: 'Joyería',
  ),
  ClassificationSeed(
    name: 'Leggings',
    classificationType: ClassificationType.Bottom,
    en: 'Leggings',
    es: 'Leggings',
  ),
  ClassificationSeed(
    name: 'Lingerie',
    classificationType: ClassificationType.Bottom,
    en: 'Lingerie',
    es: 'Lencería',
  ),
  ClassificationSeed(
    name: 'Outerwear',
    classificationType: ClassificationType.Top,
    en: 'Outerwear',
    es: 'Ropa de abrigo',
  ),
  ClassificationSeed(
    name: 'Sandals',
    classificationType: ClassificationType.Shoes,
    en: 'Sandals',
    es: 'Sandalias',
  ),
  ClassificationSeed(
    name: 'Shirt',
    classificationType: ClassificationType.Top,
    en: 'Shirt',
    es: 'Camisa',
  ),
  ClassificationSeed(
    name: 'Shoes',
    classificationType: ClassificationType.Shoes,
    en: 'Shoes',
    es: 'Zapatos',
  ),
  ClassificationSeed(
    name: 'Skirt',
    classificationType: ClassificationType.Bottom,
    en: 'Skirt',
    es: 'Falda',
  ),
  ClassificationSeed(
    name: 'Sleepwear',
    classificationType: ClassificationType.Top,
    en: 'Sleepwear',
    es: 'Ropa de dormir',
  ),
  ClassificationSeed(
    name: 'Sneakers',
    classificationType: ClassificationType.Shoes,
    en: 'Sneakers',
    es: 'Zapatillas',
  ),
  ClassificationSeed(
    name: 'Suiting',
    classificationType: ClassificationType.Top,
    en: 'Suiting',
    es: 'Traje',
  ),
  ClassificationSeed(
    name: 'Sunglasses',
    classificationType: ClassificationType.Top,
    en: 'Sunglasses',
    es: 'Gafas de sol',
  ),
  ClassificationSeed(
    name: 'Sweater',
    classificationType: ClassificationType.Top,
    en: 'Sweater',
    es: 'Jersey',
  ),
  ClassificationSeed(
    name: 'Swimwear',
    classificationType: ClassificationType.Top,
    en: 'Swimwear',
    es: 'Traje de baño',
  ),
  ClassificationSeed(
    name: 'Top',
    classificationType: ClassificationType.Top,
    en: 'Top',
    es: 'Parte superior',
  ),
  ClassificationSeed(
    name: 'Tights',
    classificationType: ClassificationType.Bottom,
    en: 'Tights',
    es: 'Medias',
  ),
  ClassificationSeed(
    name: 'Underwear',
    classificationType: ClassificationType.Bottom,
    en: 'Underwear',
    es: 'Ropa interior',
  ),
  ClassificationSeed(
    name: 'Vest',
    classificationType: ClassificationType.Top,
    en: 'Vest',
    es: 'Chaleco',
  ),
  ClassificationSeed(
    name: 'Waistcoat',
    classificationType: ClassificationType.Bottom,
    en: 'Waistcoat',
    es: 'Chaleco formal',
  ),
  ClassificationSeed(
    name: 'Other',
    classificationType: ClassificationType.Top,
    en: 'Other',
    es: 'Otro',
  ),
];
