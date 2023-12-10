import 'package:esnap_api/esnap_api.dart';

/// {@template esnap_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class EsnapApi {
  /// {@macro esnap_api}
  const EsnapApi();

  /// Provides a [Stream] of all todos.
  Stream<List<Item>> getItems();

  /// Saves an [item].
  ///
  /// If an [item] with the same id already exists, it will be replaced.
  Future<void> saveItem(Item item, List<int> image);

  /// Deletes the `item` with the given id.
  ///
  /// If no `item` with the given id exists, a [ItemNotFoundException] error is
  /// thrown.
  Future<void> deleteItem(String id);
}

/// Error thrown when a [Item] with a given id is not found.
class ItemNotFoundException implements Exception {}
