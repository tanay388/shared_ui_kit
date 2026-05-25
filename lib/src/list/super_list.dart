import 'package:flutter/material.dart';

import '../feedback/shimmer.dart';
import '../theme/shared_ui_theme.dart';

/// High-level state of a [SuperList].
enum SuperListStatus { idle, loading, refreshing, empty, error, loadingMore }

/// A list view that wraps the five most common async states:
///   * initial load (skeletons)
///   * loaded with data (with optional pull-to-refresh and pagination)
///   * empty
///   * error (with retry)
///   * loading-more footer
///
/// Pass [items] + a [itemBuilder]; the status flags drive what's rendered.
class SuperList<T> extends StatelessWidget {
  const SuperList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.status,
    this.onRefresh,
    this.onLoadMore,
    this.onRetry,
    this.emptyTitle = 'Nothing here yet',
    this.emptyMessage,
    this.errorTitle = 'Something went wrong',
    this.errorMessage,
    this.skeletonCount = 6,
    this.separator,
    this.padding,
  });

  final List<T> items;
  final IndexedWidgetBuilder itemBuilder;
  final SuperListStatus status;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final VoidCallback? onRetry;
  final String emptyTitle;
  final String? emptyMessage;
  final String errorTitle;
  final String? errorMessage;
  final int skeletonCount;
  final Widget? separator;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);

    if (status == SuperListStatus.loading && items.isEmpty) {
      return _SkeletonList(count: skeletonCount, padding: padding);
    }
    if (status == SuperListStatus.error && items.isEmpty) {
      return _ErrorState(
        title: errorTitle,
        message: errorMessage,
        onRetry: onRetry,
      );
    }
    if (status == SuperListStatus.empty ||
        (items.isEmpty && status == SuperListStatus.idle)) {
      return _EmptyState(title: emptyTitle, message: emptyMessage);
    }

    final list = NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (onLoadMore == null) return false;
        if (status == SuperListStatus.loadingMore) return false;
        if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
          onLoadMore!();
        }
        return false;
      },
      child: ListView.separated(
        padding: padding ?? EdgeInsets.all(theme.spacing.md),
        itemCount: items.length + (status == SuperListStatus.loadingMore ? 1 : 0),
        separatorBuilder: (_, _) => separator ?? SizedBox(height: theme.spacing.sm),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: theme.spacing.md),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          return itemBuilder(context, index);
        },
      ),
    );

    if (onRefresh == null) return list;
    return RefreshIndicator(onRefresh: onRefresh!, child: list);
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList({required this.count, this.padding});
  final int count;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    return ListView.separated(
      padding: padding ?? EdgeInsets.all(theme.spacing.md),
      itemCount: count,
      separatorBuilder: (_, _) => SizedBox(height: theme.spacing.sm),
      itemBuilder: (_, _) => ShimmerBox(
        height: 72,
        borderRadius: BorderRadius.circular(theme.radius.md),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, this.message});
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: theme.colors.muted),
            SizedBox(height: theme.spacing.md),
            Text(title, style: theme.typography.title.copyWith(color: theme.colors.onSurface)),
            if (message != null) ...[
              SizedBox(height: theme.spacing.xs),
              Text(message!,
                  textAlign: TextAlign.center,
                  style: theme.typography.body.copyWith(color: theme.colors.muted)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.title, this.message, this.onRetry});
  final String title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colors.danger),
            SizedBox(height: theme.spacing.md),
            Text(title, style: theme.typography.title.copyWith(color: theme.colors.onSurface)),
            if (message != null) ...[
              SizedBox(height: theme.spacing.xs),
              Text(message!,
                  textAlign: TextAlign.center,
                  style: theme.typography.body.copyWith(color: theme.colors.muted)),
            ],
            if (onRetry != null) ...[
              SizedBox(height: theme.spacing.md),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
