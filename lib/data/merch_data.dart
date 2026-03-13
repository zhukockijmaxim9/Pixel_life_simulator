import '../models/merch_item.dart';

class MerchData {
  static final List<MerchItem> shopItems = [
    const MerchItem(
      name: 'канцелярия',
      price: 150,
      icon: '📒',
      assetPath: 'assets/merch/stationery.png',
    ),
    const MerchItem(
      name: 'кружка',
      price: 120,
      icon: '☕',
      assetPath: 'assets/merch/mug.png',
    ),
    const MerchItem(
      name: 'футболка',
      price: 200,
      icon: '👕',
      assetPath: 'assets/merch/tshirt.png',
    ),
    const MerchItem(
      name: 'кепка',
      price: 180,
      icon: '🧢',
      assetPath: 'assets/merch/cap.png',
    ),
    const MerchItem(
      name: 'худи',
      price: 250,
      icon: '🧥',
      assetPath: 'assets/merch/hoodie.png',
    ),
  ];
}
