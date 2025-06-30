import 'package:flutter/material.dart';
import 'package:session/services/account_service.dart';
import '../protos/message.pbserver.dart';
import '../protos/control_messages.pb.dart';

class RegularMessageBubble extends StatelessWidget {
  final AccountService accountService;
  final MessageContent message;

  const RegularMessageBubble(
      {super.key, required this.message, required this.accountService});

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).colorScheme.primaryContainer;

    ImageAttachments? images;
    String? text;

    if (message.hasDeleted()) {
      images = null;
    } else if (message.hasImages()) {
      images = message.images;
    } else if (message.hasFull() && message.full.hasImages()) {
      images = message.full.images;
    }

    if (message.hasDeleted()) {
      text = 'This message is deleted';
    } else if (message.hasText()) {
      text = message.text;
    } else if (message.hasFull() && message.full.hasText()) {
      text = message.full.text;
    } else if (message.hasVoice()) {
      text = 'Voice message';
    } else if (message.hasFiles()) {
      text = 'File attachment';
    } else if (message.hasVideos()) {
      text = 'Video attachment';
    }

    final textWidget = Text(
      text ?? '',
      style: Theme.of(context).textTheme.bodyMedium,
      softWrap: true,
      maxLines: 80,
    );

    final Widget child;
    if (images != null) {
      child = Column(
        children: [
          Wrap(
            children: images.images
                .where((a) =>
                    a.hasContent() &&
                    (a.content.hasFile() || a.content.hasCommunityFile()))
                .map((e) => SizedBox(
                      height: 80,
                      child: Image.network(
                        e.content.hasFile()
                            ? accountService
                                .getFileDownloadUri(
                                    Uri.tryParse(e.content.file.url)!,
                                    e.content.file.key)
                                .toString()
                            : accountService
                                .getCommunityFileDownloadUri(
                                    Uri.tryParse(
                                        e.content.communityFile.communityUrl)!,
                                    e.content.communityFile.communityFileId
                                        .toInt())
                                .toString(),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          textWidget,
        ],
      );
    } else {
      child = textWidget;
    }

    return Container(
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(8),
        child: child);
  }
}

class ControlMessageBubble extends StatelessWidget {
  final ControlMessage message;

  const ControlMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final String text;

    if (message.hasMessageApprovalFromMe()) {
      text = message.messageApprovalFromMe
          ? 'You accepted the message request'
          : 'The participant has accepted the message request';
    } else {
      text = message.toDebugString();
    }

    return Text(text, style: Theme.of(context).textTheme.labelSmall);
  }
}
