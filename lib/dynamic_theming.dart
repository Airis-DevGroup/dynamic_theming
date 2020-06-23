library dynamic_theming;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dynamic_theming/src/theme_provider.dart';
export 'package:dynamic_theming/src/theme_provider.dart';

class DynamicThemedApp extends StatefulWidget {

  final String title;
  final Widget home;
  final bool automaticSystemBars;
  final Color statusBarColor;

  DynamicThemedApp({
    @required this.title,
    @required this.home,
    this.automaticSystemBars = false,
    this.statusBarColor = Colors.transparent,
  }) : assert(title != null),
       assert(home != null);

  @override
  _DynamicThemedAppState createState() => _DynamicThemedAppState();
}

class _DynamicThemedAppState extends State<DynamicThemedApp> with WidgetsBindingObserver {
  
    ThemeProvider theme;

    @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (theme != null && widget.automaticSystemBars && theme.systemThemeEnabled)
      theme.setSystemBarsColor(theme.currentBrightness, widget.statusBarColor);
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
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(builder: (_, provider, __) {
        theme = provider;
        if (widget.automaticSystemBars && provider.systemThemeEnabled)
          provider.setSystemBarsColor(provider.currentBrightness, widget.statusBarColor);

        return MaterialApp(
          title: this.widget.title,
          home: this.widget.home,
          theme: provider.appTheme,
          darkTheme: provider.systemThemeEnabled ? 
            provider.darkTheme : provider.appTheme,
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
