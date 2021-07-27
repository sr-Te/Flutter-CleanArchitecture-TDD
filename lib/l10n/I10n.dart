import 'package:flutter/material.dart';

import '../core/api/movies_api.dart';

class L10n {
  static const en = 'en';
  static const es = 'es';

  static final all = [
    const Locale(en),
    const Locale(es),
  ];

  static final getLang = {
    en: MoviesApi.en,
    es: MoviesApi.es,
  };
}
