// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:convert';

Future<Object> loadJsonFromFile(File input) async {
  return await input
      .openRead()
      .transform(utf8.decoder)
      .transform(json.decoder)
      .first;
}
