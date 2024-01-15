// ignore_for_file: omit_local_variable_types

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const _kGoldenDiffTolerance = 0.01;

class GoldenDiffComparator extends LocalFileComparator {
  final double tolerance;

  GoldenDiffComparator(
    String testFile, {
    this.tolerance = _kGoldenDiffTolerance,
  }) : super(Uri.parse(testFile));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    print(basedir);

    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent > tolerance) {
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    if (!result.passed) {
      log('A tolerable difference of ${result.diffPercent * 100}% was found when comparing $golden.');
    }
    return result.passed || result.diffPercent <= tolerance;
  }
}
