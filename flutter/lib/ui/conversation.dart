import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../time_format.dart';
import '../ui/profile_pic.dart';
import '../ui/reaction_row.dart';
import '../protos/conversation.pb.dart';
import '../protos/message.pb.dart';
import '../services/account_service.dart';
import 'package:signals/signals_flutter.dart';

import 'message_bubble.dart';

class ConversationScreen extends StatelessWidget {
  final String accountId;
  final String conversationId;
  final String? initialTitle;
  final AccountService accountService;

  ConversationScreen(
      {required this.accountId,
      required this.conversationId,
        required this.accountService,
      this.initialTitle})
      : super(key: ValueKey('conversation-$conversationId'));

  @override
  Widget build(BuildContext context) {
    return Conversation(
      conversationId: conversationId,
      accountService: accountService,
      onBackTap: () {
         Navigator.of(context).pop();
      },
    );
  }
}

class Conversation extends StatefulWidget {
  final String conversationId;
  final AccountService accountService;
  final Function()? onBackTap;
  final String? initialTitle;

  Conversation(
      {required this.conversationId,
      required this.accountService,
      required this.onBackTap,
      this.initialTitle})
      : super(key: ValueKey('conversation-$conversationId'));

  @override
  State createState() {
    return _ConversationState();
  }
}

class _ConversationState extends State<Conversation> with SignalsMixin {
  final PagingController<Int64?, Message> _pagingController =
      PagingController(firstPageKey: null);

  late final details = this.bindSignal(streamSignal(() {
    return widget.accountService.watchConversationInfo(
        GetConversationDetailsRequest(id: widget.conversationId));
  }));

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(Int64? untilTimestamp) async {
    try {
      final resp = await widget.accountService
          .getConversationMessages(GetConversationMessagesRequest(
        id: widget.conversationId,
        until: untilTimestamp,
        limit: 100,
      ));

      if (resp.messages.isEmpty) {
        _pagingController.appendLastPage([]);
      } else {
        final earliestTimestamp = resp.messages.last.createdAt;
        _pagingController.appendPage(resp.messages, earliestTimestamp);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget subTitle;
    var info = details.value.value?.details;

    if (info?.hasActiveCommunityMembers() == true) {
      subTitle = Text('${info!.activeCommunityMembers} active members',
          style: Theme.of(context).textTheme.labelSmall);
    } else if (info?.hasTotalGroupMembers() == true) {
      subTitle = Text('${info!.totalGroupMembers} members',
          style: Theme.of(context).textTheme.labelSmall);
    } else {
      subTitle = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: FittedBox(
          child: Row(
            children: [
              info?.singleAvatar != null ? SizedBox(
                width: 32,
                height: 32,
                child: ProfilePicture.fromAvatar(widget.accountService, info!.singleAvatar),
              ) :const SizedBox.shrink(),
              const SizedBox(width: 16),
              Column(
                children: [
                  Text(
                    info?.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subTitle
                ],
              ),
            ],
          ),
        ),
        leading: widget.onBackTap != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back), onPressed: widget.onBackTap)
            : null,
      ),
      body: SelectionArea(
        child: PagedListView(
            pagingController: _pagingController,
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 32),
            builderDelegate: PagedChildBuilderDelegate<Message>(
              itemBuilder: (context, message, index) {
                return _buildMessageItemContent(message, index, context);
              },
            )),
      ),
    );
  }

  Widget _buildMessageItemContent(
      Message message, int index, BuildContext context) {
    final itemLength = _pagingController.itemList!.length;

    final List<Widget> dateMessageLines;

    if (index >= itemLength - 1 ||
        (message.createdAt - _pagingController.itemList![index + 1].createdAt) >
            120000) {
      var messageCreatedAt =
          DateTime.fromMillisecondsSinceEpoch(message.createdAt.toInt());
      dateMessageLines = [
        Text(messageCreatedAt.formatForMessageRelative(),
            style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8)
      ];
    } else {
      dateMessageLines = [const SizedBox.shrink()];
    }

    if (message.hasControl()) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: dateMessageLines);
    }

    assert(message.hasRegular());

    final shouldShowName = index >= itemLength - 1 ||
        message.regular.authorId !=
            _pagingController.itemList![index + 1].regular.authorId;

    final shouldShowAvatar = index == 0 ||
        message.regular.authorId !=
            _pagingController.itemList![index - 1].regular.authorId;

    final reactionRow = message.reactions.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ReactionRow(message.reactions),
          )
        : const SizedBox.shrink();

    if (message.regular.authorName.hasOther()) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ...dateMessageLines,
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: shouldShowAvatar
                      ? ProfilePicture.fromAvatar(
                          widget.accountService, message.regular.authorAvatar)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                Expanded(
                    flex: 7,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shouldShowName
                                ? Text(message.regular.authorName.other,
                                    style:
                                        Theme.of(context).textTheme.labelSmall)
                                : const SizedBox.shrink(),
                            shouldShowAvatar
                                ? const SizedBox(height: 4)
                                : const SizedBox.shrink(),
                            RegularMessageBubble(
                                accountService: widget.accountService,
                                message: message.regular.content),
                            reactionRow
                          ],
                        ))),
                const Spacer(
                  flex: 2,
                )
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...dateMessageLines,
        Row(
          children: [
            const Spacer(flex: 2),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RegularMessageBubble(
                          accountService: widget.accountService,
                          message: message.regular.content),
                      reactionRow
                    ],
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
