import 'package:flutter_test/flutter_test.dart';
import 'package:phone_recap/app/app.dart';
import 'package:phone_recap/home/home.dart';

void main() {
  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
