// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.7

import 'package:expect/expect.dart';

class SuperA {
  method(a, [b = 'foo']) => 'A$a$b';
}

class SuperB extends SuperA {
  method(a, [b = 'foo']) => 'B$a$b';
}

mixin Mixin on SuperA {
  method2(a) => super.method('M$a');
}

class Class extends SuperB with Mixin {}

main() {
  var c = new Class();
  Expect.equals("BMCfoo", c.method2('C'));
}
