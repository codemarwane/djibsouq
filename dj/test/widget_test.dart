// Test minimal : vérifie que [MyApp] se monte. Le démarrage réel appelle l’API via
// [ProductRepository.initialize] dans main — ici on ne teste que la présence de [MaterialApp].

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dj/main.dart';

void main() {
  testWidgets('App se lance sans erreur', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(MaterialApp), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
