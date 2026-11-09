import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/screens/home/widgets/no_internet_screen.dart';

void main() {
  group('AppLocalizations', () {
    test('Urdu and Arabic are translated, not just English fallbacks', () {
      final en = AppLocalizations(const Locale('en'));
      for (final code in ['ur', 'ar']) {
        final other = AppLocalizations(Locale(code));
        for (final key in ['retry', 'noInternetTitle', 'noInternetMessage']) {
          expect(other.t(key), isNot(en.t(key)), reason: '$code is missing "$key"');
        }
      }
    });

    test('unknown keys fall back to the key itself', () {
      expect(AppLocalizations(const Locale('en')).t('no_such_key'), 'no_such_key');
    });

    test('right-to-left detection', () {
      expect(AppLocalizations.isRtl('ur'), isTrue);
      expect(AppLocalizations.isRtl('ar'), isTrue);
      expect(AppLocalizations.isRtl('en'), isFalse);
    });
  });

  testWidgets('offline screen shows a message and Retry calls back', (tester) async {
    var retries = 0;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [AppLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
      home: NoInternetScreen(onRetry: () => retries++),
    ));
    await tester.pumpAndSettle();

    final l = AppLocalizations(const Locale('en'));
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    expect(find.text(l.t('noInternetTitle')), findsOneWidget);

    await tester.tap(find.text(l.t('retry')));
    expect(retries, 1);
  });
}
