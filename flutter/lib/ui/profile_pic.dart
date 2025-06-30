import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:session/services/account_service.dart';
import '../protos/avatar.pbserver.dart' as protos;

class ProfilePicture extends StatelessWidget {
  final AccountService? service;
  final Uri? url;
  final String? encKey;

  final Uri? communityUrl;
  final int? fileId;

  final Uint8List? data;

  final String fallbackText;

  const ProfilePicture(
      {super.key,
      required this.url,
      required this.encKey,
      required this.data,
      required this.communityUrl,
      required this.fileId,
      required this.fallbackText,
      required this.service});

  Widget _buildFallback(BuildContext context) {
    if (fallbackText.length < 2) {
      return const Icon(Icons.account_circle_outlined);
    }

    final fallback = fallbackText.substring(0, 2);
    return Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: Text(
            fallback.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;

    if (url != null && encKey != null && service != null) {
      final networkUrl =
          service!.getFileDownloadUri(url!, encKey!);

      child = Image.network(
        networkUrl.toString(),
        key: ValueKey(networkUrl),
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback(context);
        },
      );
    } else if (communityUrl != null && fileId != null && service != null) {
      final networkUrl = service!
          .getCommunityFileDownloadUri(communityUrl!, fileId!);

      child = Image.network(
        networkUrl.toString(),
        key: ValueKey(networkUrl),
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback(context);
        },
      );
    } else if (data != null) {
      child = Image.memory(
        data!,
        key: ValueKey(data.hashCode),
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback(context);
        },
      );
    } else {
      child = _buildFallback(context);
    }

    return ClipOval(
      child: child,
    );
  }

  factory ProfilePicture.fromAvatar(AccountService service, protos.Avatar avatar) {
    if (avatar.hasCommunityImage()) {
      final image = avatar.communityImage;
      return ProfilePicture(
        key: ValueKey(image.communityUrl + image.communityFileId.toString()),
        url: null,
        encKey: null,
        fallbackText: avatar.fallbackText,
        data: null,
        communityUrl: Uri.tryParse(image.communityUrl),
        fileId: image.communityFileId.toInt(),
        service: service,
      );
    } else if (avatar.hasImage()) {
      final image = avatar.image;
      return ProfilePicture(
        key: ValueKey(image.url),
        url: Uri.tryParse(image.url),
        encKey: image.key,
        fallbackText: avatar.fallbackText,
        data: null,
        communityUrl: null,
        fileId: null,
        service: service,
      );
    } else {
      return ProfilePicture(
        key: ValueKey(avatar.fallbackText),
        url: null,
        encKey: null,
        fallbackText: avatar.fallbackText,
        data: null,
        communityUrl: null,
        fileId: null,
        service: service,
      );
    }
  }

  factory ProfilePicture.fromData(List<int> data) {
    var uint8Data = data.isEmpty ? null : Uint8List.fromList(data);
    return ProfilePicture(
      key: ValueKey(uint8Data),
      url: null,
      encKey: null,
      fallbackText: '',
      data: uint8Data,
      communityUrl: null,
      fileId: null,
      service: null,
    );
  }
}
