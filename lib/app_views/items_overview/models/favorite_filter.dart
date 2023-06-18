import 'package:esnap/app_views/items_overview/models/filter.dart';
import 'package:esnap_repository/esnap_repository.dart';

class FavoriteFilterItem extends Filter {
  FavoriteFilterItem(this.favorite) : super(favorite.toString());
  bool favorite;
  @override
  bool apply(Item item) {
    return item.favorite == favorite;
  }

  @override
  String getText() {
    return 'Favorites';
  }
}
