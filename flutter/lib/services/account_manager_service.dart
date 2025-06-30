import '../protos/accounts.pbserver.dart';
import 'http_service.dart';

abstract class AccountManagerService {
  Stream<ListAccountsResponse> listAccounts(ListAccountsRequest request);

  Future<LoggedInResponse> restore(RestoreAccountRequest request);

  Future<LoggedInResponse> create(CreateAccountRequest request);

  Future<LogoutResponse> logout(LogoutRequest request);

  Future<DeleteAccountResponse> delete(DeleteAccountRequest request);

  Uri getAccountServiceUri(String accountId);
}

class HttpAccountManagerService extends AccountManagerService
    with HttpServiceMixin {
  final Uri baseUrl;

  HttpAccountManagerService({required this.baseUrl});

  @override
  Future<LoggedInResponse> create(CreateAccountRequest request) {
    return httpSend(Uri.tryParse("$baseUrl/accounts")!, null,
        HttpSendMethod.post, request, LoggedInResponse.fromBuffer);
  }

  @override
  Future<DeleteAccountResponse> delete(DeleteAccountRequest request) {
    return httpSend(Uri.tryParse("$baseUrl/accounts")!, null,
        HttpSendMethod.delete, request, DeleteAccountResponse.fromBuffer);
  }

  @override
  Future<LogoutResponse> logout(LogoutRequest request) {
    return httpSend(Uri.tryParse("$baseUrl/accounts/logout")!, null,
        HttpSendMethod.post, request, LogoutResponse.fromBuffer);
  }

  @override
  Stream<ListAccountsResponse> listAccounts(ListAccountsRequest request) {
    return performHttpGetStreaming(Uri.tryParse("$baseUrl/accounts")!, null,
        ListAccountsResponse.fromBuffer);
  }

  @override
  Future<LoggedInResponse> restore(RestoreAccountRequest request) {
    return httpSend(Uri.tryParse("$baseUrl/accounts/restore")!, null,
        HttpSendMethod.post, request, LoggedInResponse.fromBuffer);
  }

  @override
  Uri getAccountServiceUri(String accountId) {
    return Uri.tryParse("$baseUrl/accounts/$accountId")!;
  }
}
