import 'package:path_provider/path_provider.dart';

import 'account_manager_service.dart';
import 'session_ui_library.dart';


Future<AccountManagerService> createDynamicLibraryAccountManagerService() async {
  var dataDir = (await getApplicationDocumentsDirectory()).path;
  Uri uri = SessionUiLibrary.instance.getSharedGlobalServiceUri(dataDir);
  return HttpAccountManagerService(baseUrl: uri);
}
