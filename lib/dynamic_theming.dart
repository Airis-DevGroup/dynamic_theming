library dynamic_theming;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dynamic_theming/src/theme_provider.dart';
export 'package:dynamic_theming/src/theme_provider.dart';

class DynamicThemedApp extends StatelessWidget {

  final String title;
  final Widget home;

  DynamicThemedApp({
    this.title,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(builder: (_, provider, __) {
        return MaterialApp(
          title: this.title,
          home: this.home,
          theme: provider.appTheme,
          darkTheme: provider.darkTheme,
        );
      }),
    );
  }
}

class DynamicTheming {
  static ThemeProvider of(BuildContext context, { bool updateOnChange = true }) {
    assert(context != null);
    ThemeProvider result = Provider.of(context, listen: updateOnChange);
    if (result != null) return result;
    throw FlutterError(
      'DynamicTheming.of(context) called with a context that does not implement dynamic theming.'
    );
  }
}
