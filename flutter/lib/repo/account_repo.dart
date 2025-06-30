
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

const String _lastSelectedAccountIdKey = "last_selected_account_id";

class SelectedAccountRepository {
  String _lastSelectedAccountId = '';

  SelectedAccountRepository();

  Stream<String> watchLatestSelectedAccount() async* {
    final prefs = await StreamingSharedPreferences.instance;
    final stream = prefs.getString(_lastSelectedAccountIdKey, defaultValue: '');
    await for (final value in stream) {
      _lastSelectedAccountId = value;
      yield value;
    }
  }

  String? peekLastSelectedAccount() {
    return _lastSelectedAccountId;
  }

  Future<void> setLastSelectedAccount(String accountId) async {
    final prefs = await StreamingSharedPreferences.instance;
    await prefs.setString(_lastSelectedAccountIdKey, accountId);
  }

  Future<void> clearLastSelectedAccount() async {
    final prefs = await StreamingSharedPreferences.instance;
    await prefs.remove(_lastSelectedAccountIdKey);
  }
}