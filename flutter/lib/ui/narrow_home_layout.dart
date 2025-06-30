import 'package:flutter/material.dart';

import '../repo/account_repo.dart';
import '../services/account_manager_service.dart';
import '../services/account_service.dart';
import 'accounts.dart';
import 'conversation.dart';
import 'conversation_list.dart';

class NarrowHomeLayout extends StatelessWidget {
  final AccountManagerService accountManagerService;
  final SelectedAccountRepository selectedAccountRepository;

  NarrowHomeLayout(
      {required this.accountManagerService,
      required this.selectedAccountRepository})
      : super(key: const ValueKey('narrow-home-layout'));

  Widget _buildEmptyHome(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('No account selected'),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: () async {
                String? accountId = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RestoreAccountScreen(
                        accountManagerService: accountManagerService)));

                if (accountId != null) {
                  selectedAccountRepository.setLastSelectedAccount(accountId);
                }
              },
              child: const Text('Restore account')),
        ],
      ),
    );
  }

  Widget _buildLoadingHome() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildHome(BuildContext context, String selectedAccountId) {
    var accountService = HttpAccountService(
        baseUrl: accountManagerService.getAccountServiceUri(selectedAccountId),
        password: null);

    return ConversationList(
      accountService: accountService,
      key: ValueKey(selectedAccountId),
      onConversationTapped: (conversationId, title) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ConversationScreen(
            accountId: selectedAccountId,
            conversationId: conversationId,
            initialTitle: title,
            accountService: accountService,
          );
        }));
      },
      selectedConversationId: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: selectedAccountRepository.watchLatestSelectedAccount(),
        builder: (context, snapshot) {
          final Widget body;
          Drawer? drawer;
          if (snapshot.data?.isNotEmpty == true) {
            body = _buildHome(context, snapshot.data!);
            drawer = Drawer(child: AccountList(
              selectedAccountRepository: selectedAccountRepository,
              accountManagerService: accountManagerService,
            ));
          } else if (snapshot.data != null) {
            body = _buildEmptyHome(context);
          } else if (!snapshot.hasError) {
            body = _buildLoadingHome();
          } else {
            body = Center(
              child: Text('Failed to load essential components of the app ${snapshot.error?.toString()}'),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Session'),
            ),
            body: body,
            drawer: drawer,
          );
        });
  }
}
