// ignore_for_file: prefer_const_constructors
import 'package:esnap_api/esnap_api.dart';
import 'package:test/test.dart';

class TestEsnapApi extends EsnapApi {
  TestEsnapApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('TodosApi', () {
    test('can be constructed', () {
      expect(TestEsnapApi.new, returnsNormally);
    });
  });
}
