// ignore_for_file: omit_local_variable_types

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const _kGoldenDiffTolerance = 0.05;

class GoldenDiffComparator extends LocalFileComparator {
  GoldenDiffComparator(
    String testFile, {
    this.tolerance = _kGoldenDiffTolerance,
  }) : super(Uri.parse(testFile));

  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent > tolerance) {
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }

    // ignore: avoid_print
    print('''
      A tolerable difference of ${result.diffPercent * 100}% was found when comparing $golden.
      The current golden test maximum tolerance setting is ${tolerance * 100}%.
      ''');
    return result.passed || result.diffPercent <= tolerance;
  }
}
