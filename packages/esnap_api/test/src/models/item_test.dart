import 'dart:io';

import 'package:esnap_api/esnap_api.dart';
import 'package:test/test.dart';

void main() {
  group('Item', () {
    Item createSubject({
      String color = 'red',
      String classification = 'jumper',
      String? id = '1',
      List<String> occasions = const [],
    }) {
      return Item(
        id: id,
        color: EsnapColor(name: color, hexColor: 0xFF000000),
        classification: EsnapClassification(
          name: classification,
          classificationType: EsnapClassificationType(name: 'top'),
        ),
        occasions: occasions.map((e) => EsnapOccasion(name: e)).toList(),
        imagePath: '',
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(createSubject, returnsNormally);
      });
      test('throws AssertionError when id is empty', () {
        expect(() => createSubject(id: ''), throwsA(isA<AssertionError>()));
      });
      test('sets id if not provided', () {
        expect(createSubject(id: null).id, isNotEmpty);
      });
      test('supports value equality', () {
        expect(createSubject(), equals(createSubject()));
      });
      test('props are correct', () {
        expect(
          createSubject().props,
          equals([
            '1', // id
            'red', // color
            'jumper', // classification
            <String>[], // occasions
            oneFile
          ]),
        );
      });
      group('copyWith', () {
        test('returns the same object if not arguments are provided', () {
          expect(
            createSubject().copyWith(),
            equals(createSubject()),
          );
        });

        test('retains the old value for every parameter if null is provided',
            () {
          expect(
            createSubject().copyWith(),
            equals(createSubject()),
          );
        });

        test('replaces every non-null parameter', () {
          expect(
            createSubject().copyWith(
              id: '2',
              color: EsnapColor(name: 'new title', hexColor: 0xFF000000),
              classification: EsnapClassification(
                name: 'new description',
                classificationType: EsnapClassificationType(name: 'top'),
              ),
              occasions: [EsnapOccasion(name: 'casual')],
            ),
            equals(
              createSubject(
                id: '2',
                color: 'new title',
                classification: 'new description',
                occasions: ['casual'],
              ),
            ),
          );
        });
      });
    });
  });
}

final oneFile = File('');
