import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplikasicuaca/data/local/favorite_service.dart';
import 'package:aplikasicuaca/main.dart';

void main() {
  testWidgets('App boots to HomeView with empty state', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await FavoriteService.init();

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Cuaca'), findsOneWidget);
    expect(find.text('Pilih kota untuk melihat cuaca'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsWidgets);
  });
}
