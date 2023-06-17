import 'package:esnap_repository/esnap_repository.dart';

// List of all filter types
enum ItemsViewFilter {
  all,
  favorite,
}

extension ItemsViewFilterX on ItemsViewFilter {
  bool apply(Item item) {
    switch (this) {
      case ItemsViewFilter.all:
        return true;
      case ItemsViewFilter.favorite:
        return item.favorite;
      // case ItemsViewFilter.completedOnly:
      //   return item.isCompleted;
    }
  }

  Iterable<Item> applyAll(Iterable<Item> items) {
    return items.where(apply);
  }
}
