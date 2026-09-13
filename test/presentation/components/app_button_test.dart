import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/presentation/components/app_button.dart';

// アイコンは SVG の読み込みを避けるため空の SizedBox で代える。AppButton はアイコンを Widget で受け取るので差し替えられる。
// ラベルを 1 文字にしているのは、テスト環境の既定フォントが 1 文字を fontSize 四方で描き、
// 実際のラベルでは幅 40px のボタンで折り返して高さがあふれるため。
const iconKey = Key('icon');

Future<void> pumpButton(
  WidgetTester tester, {
  required VoidCallback? onPressed,
  AppButtonSizeType sizeType = AppButtonSizeType.regular,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Center(
        child: AppButton.primary(
          icon: const SizedBox(key: iconKey),
          label: 'A',
          onPressed: onPressed,
          sizeType: sizeType,
        ),
      ),
    ),
  );
}

void main() {
  group('押下', () {
    testWidgets('onPressed を渡すとタップでコールバックが呼ばれる', (tester) async {
      var count = 0;
      await pumpButton(tester, onPressed: () => count++);

      await tester.tap(find.byType(AppButton));

      expect(count, 1);
    });

    testWidgets('onPressed が null なら disabled になり、不透明度で表現される', (tester) async {
      await pumpButton(tester, onPressed: null);

      expect(
        tester.widget<TextButton>(find.byType(TextButton)).enabled,
        isFalse,
      );
      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        AppColors.disabledOpacity,
      );
    });

    testWidgets('有効なときは不透明度をかけない', (tester) async {
      await pumpButton(tester, onPressed: () {});

      expect(find.byType(Opacity), findsNothing);
    });
  });

  group('寸法 [A03]', () {
    testWidgets('regular は高さ 40px・幅 90px', (tester) async {
      await pumpButton(tester, onPressed: () {});

      expect(
        tester.getSize(find.byType(TextButton)),
        const Size(AppDimens.buttonWidth, AppDimens.buttonHeight),
      );
    });

    testWidgets('mini は高さ 40px・幅 40px', (tester) async {
      await pumpButton(
        tester,
        onPressed: () {},
        sizeType: AppButtonSizeType.mini,
      );

      expect(
        tester.getSize(find.byType(TextButton)),
        const Size(AppDimens.buttonMinWidth, AppDimens.buttonHeight),
      );
    });

    // 空の SizedBox は自分でサイズを持たないため、24px になっていればボタン側が揃えていると言える。
    testWidgets('アイコンは中身に依らず 24px 四方に揃える', (tester) async {
      await pumpButton(tester, onPressed: () {});

      expect(
        tester.getSize(find.byKey(iconKey)),
        const Size.square(AppDimens.buttonIconSize),
      );
    });
  });
}
