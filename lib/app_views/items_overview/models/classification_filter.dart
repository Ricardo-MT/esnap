import 'package:esnap/app_views/items_overview/models/filter.dart';
import 'package:esnap_repository/esnap_repository.dart';

class ClassificationFilterItem extends Filter {
  ClassificationFilterItem(this.classification) : super(classification.id);
  EsnapClassification classification;
  @override
  bool apply(Item item) {
    return item.classification?.id == classification.id;
  }

  @override
  String getText() {
    return classification.name;
  }
}
