import 'package:esnap/app_views/items_overview/models/filter.dart';
import 'package:esnap_repository/esnap_repository.dart';

class OccasionFilterItem extends Filter {
  OccasionFilterItem(this.occasion) : super(occasion.id);
  EsnapOccasion occasion;
  @override
  bool apply(Item item) {
    return item.occasions
        .where((element) => element.id == occasion.id)
        .isNotEmpty;
  }

  @override
  String getText() {
    return occasion.name;
  }
}
