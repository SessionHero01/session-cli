import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../protos/conversation_list.pb.dart';
import '../services/account_service.dart';
import '../ui/profile_pic.dart';


class ConversationList extends StatefulWidget {
  final AccountService accountService;
  final Function(String convoId, String title) onConversationTapped;
  final String? selectedConversationId;

  const ConversationList(
      {required super.key,
      required this.accountService,
      required this.onConversationTapped,
      required this.selectedConversationId});

  @override
  State createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> with SignalsMixin {
  late final conversations = this.bindSignal(streamSignal(() => widget
      .accountService
      .watchConversations(ListConversationsRequest(approved: true))));

  @override
  Widget build(BuildContext context) {
    final items = conversations.value.value?.conversations ?? [];
    return AutoAnimatedList<ConversationSummary>(
      items: items,
      itemBuilder: (ctx, conversation, index, animation) {
        final messageContentStyle = Theme.of(context).textTheme.bodySmall;
        Widget messageContent;
        if (conversation.hasLastMessage()) {
          final lastMessage = conversation.lastMessage;
          String? content;
          String? author;

          if (lastMessage.hasControl()) {
            content = 'TODO: Control message';
          } else if (lastMessage.hasRegular()) {
            final regular = lastMessage.regular;
            final regularContent = regular.content;
            if (regularContent.hasText()) {
              content = regularContent.text;
            } else if (regularContent.hasFull()) {
              content = regularContent.full.text;
            } else if (regularContent.hasVoice()) {
              content = 'Voice message';
            } else if (regularContent.hasImages()) {
              content = '📷 Attachment';
            } else if (regularContent.hasVideos()) {
              content = '🎥 attachment';
            } else if (regularContent.hasFiles()) {
              content = 'File attachment';
            }

            author =
                regular.authorName.hasMe() ? 'You' : regular.authorName.other;
          }

          if (content == null) {
            content = 'No messages';
          } else if (author != null) {
            content = '$author: $content';
          }

          messageContent = Text(
            content,
            style: messageContentStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        } else {
          messageContent = Text(
            'No messages',
            style: messageContentStyle,
          );
        }

        var conversationName =
            conversation.name.isEmpty ? 'Unknown' : conversation.name;

        final selected = conversation.id == widget.selectedConversationId;

        Widget profilePicture = ProfilePicture.fromAvatar(
            widget.accountService, conversation.singleAvatar);

        if (conversation.unreadCount > 0) {
          profilePicture = Badge.count(
              count: conversation.unreadCount, child: profilePicture);
        }

        return FadeTransition(
          key: ValueKey(conversation.id),
          opacity: animation,
          child: ListTile(
            selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
            selected: selected,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            leading: SizedBox(width: 40, height: 40, child: profilePicture),
            onTap: () {
              widget.onConversationTapped(conversation.id, conversationName);
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversationName,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                messageContent,
              ],
            ),
          ),
        );
      },
    );
  }
}
