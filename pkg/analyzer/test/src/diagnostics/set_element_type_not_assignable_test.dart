// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/error/codes.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../dart/resolution/driver_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(SetElementTypeNotAssignableTest);
    defineReflectiveTests(SetElementTypeNotAssignableWithUIAsCodeTest);
  });
}

@reflectiveTest
class SetElementTypeNotAssignableTest extends DriverResolutionTest {
  test_explicitTypeArgs_const() async {
    await assertErrorsInCode('''
var v = const <String>{42};
''', [StaticWarningCode.SET_ELEMENT_TYPE_NOT_ASSIGNABLE]);
  }

  test_explicitTypeArgs_const_actualTypeMatch() async {
    await assertNoErrorsInCode('''
const dynamic x = null;
var v = const <String>{x};
''');
  }

  @FailingTest(issue: 'https://github.com/dart-lang/sdk/issues/21119')
  test_explicitTypeArgs_const_actualTypeMismatch() async {
    await assertErrorsInCode('''
const dynamic x = 42;
var v = const <String>{x};
''', [CheckedModeCompileTimeErrorCode.SET_ELEMENT_TYPE_NOT_ASSIGNABLE]);
  }

  test_explicitTypeArgs_notConst() async {
    await assertErrorsInCode('''
var v = <String>{42};
''', [StaticWarningCode.SET_ELEMENT_TYPE_NOT_ASSIGNABLE]);
  }
}

@reflectiveTest
class SetElementTypeNotAssignableWithUIAsCodeTest
    extends SetElementTypeNotAssignableTest {
  @override
  AnalysisOptionsImpl get analysisOptions => AnalysisOptionsImpl()
    ..enabledExperiments = ['control-flow-collections', 'spread-collections'];

  test_spread_valid_const() async {
    await assertNoErrorsInCode('''
var v = const <String>{...['a', 'b']};
''');
  }

  test_spread_valid_nonConst() async {
    await assertNoErrorsInCode('''
var v = <String>{...['a', 'b']};
''');
  }
}
