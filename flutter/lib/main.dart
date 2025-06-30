import 'dart:io' show Platform;

import 'package:context_menus/context_menus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:relative_time/relative_time.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:session/ui/narrow_home_layout.dart';
import 'repo/account_repo.dart';
import 'ui/wide_home_layout.dart';
import 'services/dynamic_manager.dart';
import 'services/account_manager_service.dart';

class MyImageCache extends ImageCache {
  @override
  void clear() {
    print('Clearing cache');
    super.clear();
  }
}

class MyWidgetsBinding extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    return MyImageCache();
  }
}

void main() async {
  MyWidgetsBinding();

  runApp(MyApp());
}

Future<AccountManagerService> createAccountManagerService() async {
  if (!kDebugMode) {
    return createDynamicLibraryAccountManagerService();
  } else {
    return HttpAccountManagerService(
        baseUrl: Uri.parse('http://localhost:4002'));
  }
}

class MyApp extends StatelessWidget {
  final selectedAccountRepository = SelectedAccountRepository();

  MyApp({super.key});

  Widget _createHomePage() {
    return FutureBuilder(
        future: createAccountManagerService(),
        builder: (context, snapshot) {
          var accountManagerService = snapshot.data;
          if (accountManagerService != null) {
            final isWide = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
            if (isWide) {
              return WideHomeLayout(
                  selectedAccountRepository: selectedAccountRepository,
                  accountManagerService: accountManagerService);
            } else {
              return NarrowHomeLayout(
                  accountManagerService: accountManagerService,
                  selectedAccountRepository: selectedAccountRepository);
            }
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: SizedBox(
                child: Text(
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    'Failed to load essential components of the app ${snapshot.error?.toString()}'),
              )),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        RelativeTimeLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: ResponsiveBreakpoints.builder(breakpoints: const [
        Breakpoint(start: 0, end: 800, name: MOBILE),
        Breakpoint(start: 800, end: double.infinity, name: DESKTOP),
      ], child: ContextMenuOverlay(child: _createHomePage())),
    );
  }
}
