import 'package:esnap_api/esnap_api.dart';

/// An abstract class for implementing filters
abstract class Filter {
  Filter(this.id);
  final String id;
  bool apply(Item item);
}
