String getAssetByClassification(String classification) {
  return 'assets/img/${_classificationAssetPairs[classification] ?? "default"}.webp';
}

List<String> getAllClassificationItemsAssets() {
  return _classificationAssetPairs.values
      .map((e) => 'assets/img/$e.webp')
      .toList();
}

const _classificationAssetPairs = {
  'Accessory': 'accessory',
  'Activewear': 'activewear',
  'Bag': 'bag',
  'Blouse': 'blouse',
  'Boots': 'boots',
  'Bottom': 'bottom',
  'Dress': 'dress',
  'Gloves': 'gloves',
  'Headwear': 'headwear',
  'Heels': 'heels',
  'Jacket': 'jacket',
  'Jewelry': 'jewelry',
  'Leggings': 'leggings',
  'Lingerie': 'lingerie',
  'Outerwear': 'outerwear',
  'Sandals': 'sandals',
  'Shirt': 'shirt',
  'Shoes': 'shoes',
  'Skirt': 'skirt',
  'Sleepwear': 'sleepwear',
  'Sneakers': 'sneakers',
  'Suiting': 'suiting',
  'Sunglasses': 'sunglasses',
  'Sweater': 'sweater',
  'Swimwear': 'swimwear',
  'Top': 'top',
  'Tights': 'tights',
  'Underwear': 'underwear',
  'Vest': 'vest',
  'Waistcoat': 'waistcoat',
  'Other': 'other',
};
