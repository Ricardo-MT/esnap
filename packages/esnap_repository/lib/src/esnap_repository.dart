import 'package:esnap_api/esnap_api.dart';

/// {@template esnap_repository}
/// A repository that handles esnap related requests
/// {@endtemplate}
class EsnapRepository {
  /// {@macro esnap_repository}
  const EsnapRepository({required EsnapApi esnapApi}) : _esnapApi = esnapApi;

  final EsnapApi _esnapApi;

  /// Provides a [Stream] of all items.
  Stream<List<Item>> getItems() => _esnapApi.getItems();

  /// Saves an [item].
  ///
  /// If an [item] with the same id already exists, it will be replaced.
  Future<void> saveItem(Item item) => _esnapApi.saveItem(item);

  /// Deletes the `item` with the given id.
  ///
  /// If no `item` with the given id exists, a [ItemNotFoundException] error is
  /// thrown.
  Future<void> deleteItem(String id) => _esnapApi.deleteItem(id);
}
