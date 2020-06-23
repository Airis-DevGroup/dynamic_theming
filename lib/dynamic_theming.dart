library dynamic_theming;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dynamic_theming/src/theme_provider.dart';
export 'package:dynamic_theming/src/theme_provider.dart';

class DynamicThemedApp extends StatefulWidget {
  final ThemeProvider controller;
  final String title;
  final Widget home;
  final bool automaticSystemBars;
  final Color statusBarColor;

  DynamicThemedApp({
    @required this.title,
    @required this.home,
    this.controller,
    this.automaticSystemBars = false,
    this.statusBarColor = Colors.transparent,
  })  : assert(title != null),
        assert(home != null);

  @override
  _DynamicThemedAppState createState() => _DynamicThemedAppState();
}

class _DynamicThemedAppState extends State<DynamicThemedApp> with WidgetsBindingObserver {
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (widget.controller != null &&
        widget.automaticSystemBars &&
        widget.controller.systemThemeEnabled)
      widget.controller.setSystemBarsColor(
          widget.controller.currentBrightness,
          widget.statusBarColor
      );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    Consumer _child = Consumer<ThemeProvider>(builder: (_, provider, __) {
      if (widget.automaticSystemBars && provider.systemThemeEnabled)
        provider.setSystemBarsColor(
          provider.currentBrightness,
          widget.statusBarColor,
        );

      return MaterialApp(
        title: this.widget.title,
        home: this.widget.home,
        theme: provider.appTheme,
        darkTheme: provider.systemThemeEnabled
            ? provider.darkTheme
            : provider.appTheme,
      );
    });
    if (widget.controller != null)
      return ChangeNotifierProvider.value(
        value: widget.controller,
        child: _child
      );
    else
      return ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: _child,
      );
  }
}

class DynamicTheming {
  static Future<ThemeProvider> init() async {
    return await ThemeProvider().init();
  }

  static ThemeProvider of(BuildContext context, {bool updateOnChange = true}) {
    assert(context != null);
    ThemeProvider result = Provider.of(context, listen: updateOnChange);
    if (result != null) return result;
    throw FlutterError(
        'DynamicTheming.of(context) called with a context that does not implement dynamic theming.');
  }
}
