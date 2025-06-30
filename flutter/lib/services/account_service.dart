import 'package:uri/uri.dart';

import '../protos/conversation.pbserver.dart';
import '../protos/contact.pbserver.dart';
import '../protos/conversation_list.pbserver.dart';
import 'http_service.dart';

abstract class AccountService {
  Future<ListContactsResponse> listContacts(ListContactsRequest request);

  Stream<ListConversationsResponse> watchConversations(
      ListConversationsRequest request);

  Future<GetConversationMessagesResponse> getConversationMessages(
      GetConversationMessagesRequest request);

  Stream<GetConversationDetailsResponse> watchConversationInfo(
      GetConversationDetailsRequest request);

  Uri getFileDownloadUri(Uri networkUri, String key);

  Uri getCommunityFileDownloadUri(Uri communityUrl, int fileId);
}

class HttpAccountService extends AccountService with HttpServiceMixin {
  final Uri baseUrl;
  final String? password;

  HttpAccountService({required this.baseUrl, required this.password});

  @override
  Future<ListContactsResponse> listContacts(ListContactsRequest request) {
    return httpSend(baseUrl, password, HttpSendMethod.post, request,
        ListContactsResponse.fromBuffer);
  }

  @override
  Stream<ListConversationsResponse> watchConversations(
      ListConversationsRequest request) {
    final builder = UriBuilder.fromUri(Uri.tryParse("$baseUrl/conversations")!);

    if (request.hasApproved()) {
      builder.queryParameters = {"approved": request.approved.toString()};
    }

    return performHttpGetStreaming(
        builder.build(), password, ListConversationsResponse.fromBuffer);
  }

  @override
  Future<GetConversationMessagesResponse> getConversationMessages(
      GetConversationMessagesRequest request) {
    final builder =
        UriBuilder.fromUri(Uri.tryParse("$baseUrl/conversation/messages")!);
    builder.queryParameters = {
      "id": request.id,
    };

    if (request.hasUntil()) {
      builder.queryParameters['until'] = request.until.toString();
    }

    if (request.hasLimit() && request.limit > 0) {
      builder.queryParameters['limit'] = request.limit.toString();
    } else if (request.hasAfter()) {
      builder.queryParameters['after'] = request.after.toString();
    }

    return httpGet(
        builder.build(), password, GetConversationMessagesResponse.fromBuffer);
  }

  @override
  Stream<GetConversationDetailsResponse> watchConversationInfo(
      GetConversationDetailsRequest request) {
    final builder = UriBuilder.fromUri(Uri.tryParse("$baseUrl/conversation")!);
    builder.queryParameters = {
      "id": request.id,
    };

    return performHttpGetStreaming(
        builder.build(), password, GetConversationDetailsResponse.fromBuffer);
  }

  @override
  Uri getFileDownloadUri(Uri networkUri, String key) {
    final builder = UriBuilder.fromUri(Uri.tryParse("$baseUrl/files")!)
      ..queryParameters['url'] = networkUri.toString();

    if (key.isNotEmpty) {
      builder.queryParameters['key'] = key;
    }

    return builder.build();
  }

  @override
  Uri getCommunityFileDownloadUri(Uri communityUrl, int fileId) {
    final builder = UriBuilder.fromUri(Uri.tryParse("$baseUrl/files")!)
      ..queryParameters['community_url'] = communityUrl.toString()
      ..queryParameters['file_id'] = fileId.toString();

    return builder.build();
  }
}
