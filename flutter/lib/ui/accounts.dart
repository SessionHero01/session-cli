import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:session/protos/accounts.pbserver.dart';
import 'package:session/ui/profile_pic.dart';

import '../repo/account_repo.dart';
import '../services/account_manager_service.dart';

class AccountList extends StatelessWidget {
  final AccountManagerService accountManagerService;
  final SelectedAccountRepository selectedAccountRepository;
  final Function(String)? onAccountSelected;

  const AccountList({
    required this.accountManagerService,
    required this.selectedAccountRepository,
    this.onAccountSelected,
  }) : super(key: const ValueKey('account-list'));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: selectedAccountRepository.watchLatestSelectedAccount(),
        builder: (context, selectedAccountSnapshot) {
          final selectedAccountId = selectedAccountSnapshot.data;
          return StreamBuilder(
              stream: accountManagerService.listAccounts(ListAccountsRequest()),
              builder: (context, accountsSnapshot) {
                final List<_AccountListItem> items = [];
                for (final account in accountsSnapshot.data?.accounts ?? []) {
                  items.add(_RegularAccountItem(account));
                }

                items.add(const _AddAccountItem());

                return AutoAnimatedList<_AccountListItem>(
                  items: items,
                  itemBuilder: (context, account, index, animation) {
                    if (account is _RegularAccountItem) {
                      return ContextMenuRegion(
                        contextMenu: GenericContextMenu(buttonConfigs: [
                          ContextMenuButtonConfig(' 🗑  Delete account',
                              onPressed: () async {
                            try {
                              await accountManagerService.delete(
                                  DeleteAccountRequest(
                                      sessionId: account.account.sessionId));

                              if (context.mounted) {
                                if (account.account.sessionId ==
                                    selectedAccountRepository
                                        .peekLastSelectedAccount()) {
                                  await selectedAccountRepository
                                      .clearLastSelectedAccount();
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error deleting account: $e')));
                              }
                            }
                          })
                        ]),
                        child: Container(
                          color: account.account.sessionId == selectedAccountId
                              ? Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1)
                              : null,
                          child: ListTile(
                            leading: SizedBox(
                                width: 48,
                                height: 48,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ProfilePicture.fromData(
                                      account.account.avatarImage),
                                )),
                            title: Text(account.account.name),
                            onTap: () {
                              selectedAccountRepository.setLastSelectedAccount(
                                  account.account.sessionId);
                              onAccountSelected
                                  ?.call(account.account.sessionId);
                            },
                          ),
                        ),
                      );
                    } else {
                      return ListTile(
                        leading: const SizedBox(
                            width: 48, height: 48, child: Icon(Icons.add)),
                        title: Text('Add account',
                            style: Theme.of(context).textTheme.bodyMedium),
                        onTap: () async {
                          // Add account
                          String? selected = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestoreAccountScreen(
                                      accountManagerService:
                                          accountManagerService)));

                          if (selected != null) {
                            selectedAccountRepository
                                .setLastSelectedAccount(selected);
                          }
                        },
                      );
                    }
                  },
                );
              });
        });
  }
}

sealed class _AccountListItem {
  const _AccountListItem();
}

class _RegularAccountItem extends _AccountListItem {
  final ListAccountsResponse_Account account;

  const _RegularAccountItem(this.account);

  @override
  bool operator ==(Object other) {
    if (other is _RegularAccountItem) {
      return account.sessionId == other.account.sessionId &&
          account.name == other.account.name &&
          account.avatarImage == other.account.avatarImage;
    }
    return false;
  }

  // Combine hash codes of fields
  @override
  int get hashCode =>
      account.sessionId.hashCode ^
      account.name.hashCode ^
      account.avatarImage.hashCode;
}

class _AddAccountItem extends _AccountListItem {
  const _AddAccountItem();

  @override
  bool operator ==(Object other) => other is _AddAccountItem;

  @override
  int get hashCode => 0;
}

class RestoreAccountScreen extends StatelessWidget {
  final AccountManagerService accountManagerService;
  final _controller = TextEditingController();

  RestoreAccountScreen({super.key, required this.accountManagerService});

  @override
  Widget build(BuildContext context) {
    // Widget with two rows, row one contains a text field that accepts a string,
    // another row contains the 'restore' button
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restore account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your secret key',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Restore account
                try {
                  final resp = await accountManagerService.restore(
                      RestoreAccountRequest(mnemonic: _controller.text));

                  if (context.mounted) {
                    Navigator.of(context).pop(resp.sessionId);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error restoring account: $e')));
                  }
                }
              },
              child: const Text('Restore'),
            ),
          ],
        ),
      ),
    );
  }
}
