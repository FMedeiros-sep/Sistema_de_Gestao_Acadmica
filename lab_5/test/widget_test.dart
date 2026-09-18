import 'package:flutter_test/flutter_test.dart';
import 'package:lab_5/main.dart';

void main() {
  testWidgets('Carrega tela de autenticação', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());
    expect(find.text('ENTRAR'), findsOneWidget);
  });
}
