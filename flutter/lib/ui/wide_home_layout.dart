import 'package:flutter/material.dart';
import '../repo/account_repo.dart';
import '../services/account_manager_service.dart';
import '../ui/accounts.dart';
import '../ui/conversation.dart';
import 'package:signals/signals_flutter.dart';

import '../services/account_service.dart';
import 'conversation_list.dart';

class WideHomeLayout extends StatefulWidget {
  final SelectedAccountRepository selectedAccountRepository;
  final AccountManagerService accountManagerService;

  const WideHomeLayout({super.key, required this.selectedAccountRepository, required this.accountManagerService});

  @override
  State<WideHomeLayout> createState() => _WideHomeLayoutState();
}

class _WideHomeLayoutState extends State<WideHomeLayout> with SignalsMixin {
  // Store the left panel's width for desktop layout
  late final _leftPanelWidth = this.createSignal(300.0);

  late final _selectedAccountId = this.bindSignal(streamSignal(widget.selectedAccountRepository.watchLatestSelectedAccount));
  late final _selectedConversationIdByAccount = this.bindSignal(createMapSignal<String, String?>({}));
  late final _selectedAccountService = this.createComputed(() {
    var selectedAccountId = _selectedAccountId.value.value;
    if (selectedAccountId?.isNotEmpty == true) {
      return HttpAccountService(
          baseUrl: widget.accountManagerService.getAccountServiceUri(selectedAccountId!),
          password: null);
    }
    return null;
  });

  @override
  Widget build(BuildContext context) {
    final selectedAccountId = _selectedAccountId.value.value;
    final selectedAccountService = _selectedAccountService.value;

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
              width: 200,
              child: AccountList(
                  selectedAccountRepository: widget.selectedAccountRepository,
                  accountManagerService: widget.accountManagerService)),
          SizedBox(
            width: _leftPanelWidth.value,
            child: selectedAccountService == null || selectedAccountId == null
                ? const Center(child: Text('No account selected'))
                : ConversationList(
                    key: ValueKey(selectedAccountId),
                    accountService: selectedAccountService,
                    onConversationTapped: (conversationId, title) {
                      _selectedConversationIdByAccount[selectedAccountId] = conversationId;
                    },
                    selectedConversationId: _selectedConversationIdByAccount[selectedAccountId],
                  ),
          ),
          Expanded(
              child: selectedAccountService == null ||
                  _selectedConversationIdByAccount[selectedAccountId] == null
                  ? const Center(child: Text('No conversation selected'))
                  : Conversation(
                      conversationId: _selectedConversationIdByAccount[selectedAccountId]!,
                      accountService: selectedAccountService,
                      onBackTap: null))
        ],
      ),
    );
  }
}
