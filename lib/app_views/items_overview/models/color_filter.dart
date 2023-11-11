import 'package:esnap/app_views/items_overview/models/filter.dart';
import 'package:esnap_repository/esnap_repository.dart';

class ColorFilterItem extends Filter {
  ColorFilterItem(this.color) : super(color.id);
  EsnapColor color;
  @override
  bool apply(Item item) {
    return item.color?.id == color.id;
  }
}
