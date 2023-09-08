import 'dart:html' as html;

import 'platform_specific_abstract.dart';

class PlatformSpecificImpl implements PlatformSpecific {
  static void setPageTitle(String title) {
    html.document.title = title;
  }
}
