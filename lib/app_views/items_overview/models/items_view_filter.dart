import 'package:esnap_repository/esnap_repository.dart';

// List of all filter types
enum ItemsViewFilter {
  all,
}

extension ItemsViewFilterX on ItemsViewFilter {
  bool apply(Item item) {
    switch (this) {
      case ItemsViewFilter.all:
        return true;
      // case TodosViewFilter.activeOnly:
      //   return !item.isCompleted;
      // case TodosViewFilter.completedOnly:
      //   return item.isCompleted;
    }
  }

  Iterable<Item> applyAll(Iterable<Item> items) {
    return items.where(apply);
  }
}
