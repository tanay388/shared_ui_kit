import 'package:flutter/material.dart';

import '../theme/shared_ui_theme.dart';

enum SharedAvatarSize { xs, sm, md, lg, xl }

class SharedAvatar extends StatelessWidget {
  const SharedAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = SharedAvatarSize.md,
    this.isOnline,
  });

  final String? imageUrl;
  final String? initials;
  final SharedAvatarSize size;
  final bool? isOnline;

  double get _dim => switch (size) {
        SharedAvatarSize.xs => 24,
        SharedAvatarSize.sm => 32,
        SharedAvatarSize.md => 40,
        SharedAvatarSize.lg => 56,
        SharedAvatarSize.xl => 80,
      };

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    final dim = _dim;

    final body = Container(
      width: dim,
      height: dim,
      decoration: BoxDecoration(
        color: theme.colors.secondary,
        shape: BoxShape.circle,
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      alignment: Alignment.center,
      child: imageUrl == null
          ? Text(
              (initials ?? '?').toUpperCase(),
              style: theme.typography.label.copyWith(
                color: theme.colors.onSecondary,
                fontSize: dim * 0.4,
              ),
            )
          : null,
    );

    if (isOnline == null) return body;
    final dotSize = dim * 0.25;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        body,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isOnline! ? theme.colors.success : theme.colors.muted,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colors.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
