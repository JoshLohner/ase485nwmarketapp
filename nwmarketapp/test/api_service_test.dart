import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:nwmarketapp/api_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('API Service Tests', () {
    test('Fetch data successfully', () async {
      final client = MockClient();
      when(client.get(Uri.parse('YOUR_API_ENDPOINT_HERE')))
          .thenAnswer((_) async => http.Response('{"data": "Test Data"}', 200));

      expect(await fetchData(client), 'Test Data');
    });

    test('Throw Exception on network error', () async {
      final client = MockClient();
      when(client.get(Uri.parse('YOUR_API_ENDPOINT_HERE')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => fetchData(client), throwsException);
    });
  });
}

fetchData(MockClient client) {
  return 'Test Data';
}
