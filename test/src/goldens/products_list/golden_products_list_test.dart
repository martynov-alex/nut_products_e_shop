import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nut_products_e_shop/src/app.dart';

import '../../robot.dart';
import '../golden_file_comparator.dart';

void main() {
  final sizeVariant = ValueVariant<Size>({
    const Size(300, 600),
    const Size(600, 800),
    const Size(1000, 1000),
  });
  testWidgets(
    'Golden — product list',
    (tester) async {
      final r = Robot(tester);
      final currentSize = sizeVariant.currentValue!;
      await tester.runAsync(() async {
        await r.golden.setSurfaceSize(currentSize);
        await r.golden.loadRobotoFont();
        await r.golden.loadMaterialIconFont();
        await r.pumpMyApp();
      });
      await r.golden.precacheImages();

      goldenFileComparator = GoldenDiffComparator(
        '${(goldenFileComparator as LocalFileComparator).basedir}/goldens',
      );

      final goldenFileKey =
          'goldens/products_list_${currentSize.width.toInt()}x${currentSize.height.toInt()}.png';
      await expectLater(find.byType(MyApp), matchesGoldenFile(goldenFileKey));
    },
    variant: sizeVariant,
    tags: ['golden', 'products_list'],
  );
}
