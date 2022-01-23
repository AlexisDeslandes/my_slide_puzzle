import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('ThemeSelector', () {
    testWidgets(
        'Given SimpleTheme & MyTheme to ThemeBloc, '
        'tap on Switch should change theme state to MyTheme.', (tester) async {
      final themeBloc = ThemeBloc(themes: const [SimpleTheme(), MyTheme()]);
      await tester.pumpApp(const ThemeSelector(), themeBloc: themeBloc);
      expect(themeBloc.state.theme, const SimpleTheme());
      await tester.tap(find.byType(Switch));
      expect(themeBloc.state.theme, const MyTheme());
    });
  });
}
