import 'dart:io';

import 'package:esnap_api/esnap_api.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_esnap_api/src/adapters/outfit.dart';
import 'package:local_storage_esnap_api/src/esnap_boxes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

/// {@template local_storage_esnap_api}
/// A Flutter implementation of the EsnapApi that uses local storage
/// {@endtemplate}
class LocalStorageOutfitApi extends OutfitApi {
  /// {@macro local_storage_esnap_api}
  LocalStorageOutfitApi(this.box, String applicationDocumentsDirectory) {
    final outfitsRes = box.values;
    _outfitStreamController.add(
      outfitsRes.map((e) {
        final outfit = e.toOutfit();
        return outfit.copyWith(
          top: outfit.top?.copyWith(
            imagePath:
                '$applicationDocumentsDirectory/${outfit.top!.imagePath}',
          ),
          bottom: outfit.bottom?.copyWith(
            imagePath:
                '$applicationDocumentsDirectory/${outfit.bottom!.imagePath}',
          ),
          shoes: outfit.shoes?.copyWith(
            imagePath:
                '$applicationDocumentsDirectory/${outfit.shoes!.imagePath}',
          ),
        );
      }).toList(),
    );
  }

  final _outfitStreamController =
      BehaviorSubject<List<Outfit>>.seeded(const []);

  /// The box for handling colors
  final Box<OutfitSchema> box;

  /// This method opens the box, runs the initial migrations and
  /// returns an instance of the LocalStorageColorApi class.
  static Future<LocalStorageOutfitApi> initializer() async {
    Hive.registerAdapter(OutfitSchemaAdapter());
    final box = await Hive.openBox<OutfitSchema>(EsnapBoxes.outfit);
    final directory = await getApplicationDocumentsDirectory();
    final itemImages = Directory('${directory.path}/item_images');
    return LocalStorageOutfitApi(box, itemImages.path);
  }

  @override
  Stream<List<Outfit>> getOutfits() =>
      _outfitStreamController.asBroadcastStream();

  @override
  Future<void> saveOutfit(Outfit outfit) async {
    final outfits = [..._outfitStreamController.value];
    final outfitIndex = outfits.indexWhere((t) => t.id == outfit.id);
    if (outfitIndex >= 0) {
      outfits[outfitIndex] = outfit;
    } else {
      outfits.add(outfit);
    }
    _outfitStreamController.add(outfits);
    final outfit0 = await OutfitSchema.fromOutfit(outfit);
    return Hive.box<OutfitSchema>(EsnapBoxes.outfit).put(outfit.id, outfit0);
  }

  @override
  Future<void> deleteOutfit(String id) async {
    final outfits = [..._outfitStreamController.value];
    final outfitIndex = outfits.indexWhere((t) => t.id == id);
    if (outfitIndex == -1) {
      throw OutfitNotFoundException();
    } else {
      outfits.removeAt(outfitIndex);
      _outfitStreamController.add(outfits);
      return Hive.box<OutfitSchema>(EsnapBoxes.outfit).delete(id);
    }
  }
}
