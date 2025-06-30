
import 'package:flutter/material.dart';
import '../protos/message.pb.dart';

class ReactionRow extends StatelessWidget {
  final List<MessageReaction> reactions;
  final int maxReactions = 10;

  const ReactionRow(this.reactions, {super.key});

  @override
  Widget build(BuildContext context) {
    final reactionChildren = reactions
      .take(maxReactions)
      .map((reaction) => ReactionBadge(reaction) as Widget)
    .toList();

    if (reactions.length > maxReactions) {
      reactionChildren.add(
        _Badge(
          child: Text('MORE', style: Theme.of(context).textTheme.labelSmall),
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      spacing: 4,
      runSpacing: 4,
      children: reactionChildren,
    );
  }
}

class _Badge extends StatelessWidget {
  final Widget child;

  const _Badge({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: child,
    );

  }
}

class ReactionBadge extends StatelessWidget {
  final MessageReaction reaction;

  const ReactionBadge(this.reaction, {super.key});

  @override
  Widget build(BuildContext context) {
    // A rounded badge showing the reaction emoji and the count
    var textStyle = Theme.of(context).textTheme.labelSmall;

    return _Badge(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(reaction.emoji, style: textStyle),
          const SizedBox(width: 4),
          Text(reaction.count.toString(), style: textStyle),
        ],
      ),
    );
  }
}