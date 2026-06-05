import 'package:flutter/material.dart';
import 'package:shared_ui_kit/shared_ui_kit.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shared_ui_kit demo',
      debugShowCheckedModeBanner: false,
      home: SharedUiTheme(
        data: SharedUiThemeData.light,
        child: const DemoHome(),
      ),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});
  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  bool _saving = false;
  bool _favourited = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;

  SuperListStatus _listStatus = SuperListStatus.loading;
  final List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _listStatus = SuperListStatus.loading;
      _items.clear();
    });
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {
      _items.addAll(List.generate(8, (i) => 'Item #${i + 1}'));
      _listStatus = SuperListStatus.idle;
    });
  }

  Future<void> _refresh() async {
    setState(() => _listStatus = SuperListStatus.refreshing);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    setState(() {
      _items
        ..clear()
        ..addAll(List.generate(8, (i) => 'Fresh item #${i + 1}'));
      _listStatus = SuperListStatus.idle;
    });
  }

  Future<void> _loadMore() async {
    setState(() => _listStatus = SuperListStatus.loadingMore);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    setState(() {
      final offset = _items.length;
      _items.addAll(List.generate(4, (i) => 'Item #${offset + i + 1}'));
      _listStatus = SuperListStatus.idle;
    });
  }

  Future<void> _onSave() async {
    setState(() {
      _saving = true;
      _emailError = !_email.text.contains('@') ? 'Enter a valid email' : null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _saving = false);
    SharedToast.show(context, message: 'Saved!', tone: ToastTone.success);
  }

  @override
  Widget build(BuildContext context) {
    final theme = SharedUiTheme.of(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        title: const Text('shared_ui_kit'),
        backgroundColor: theme.colors.surface,
        foregroundColor: theme.colors.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(theme.spacing.lg),
        children: [
          SharedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SharedAvatar(initials: 'TD', isOnline: true),
                    SizedBox(width: theme.spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanay D.', style: theme.typography.title),
                          Text('Admin · just now',
                              style: theme.typography.caption
                                  .copyWith(color: theme.colors.muted)),
                        ],
                      ),
                    ),
                    const SharedBadge(label: 'PRO', tone: SharedBadgeTone.primary),
                  ],
                ),
                SizedBox(height: theme.spacing.lg),
                SharedTextField(
                  controller: _email,
                  label: 'Email',
                  hint: 'you@company.com',
                  prefixIcon: Icons.mail_outline,
                  errorText: _emailError,
                  isDisabled: _saving,
                ),
                SizedBox(height: theme.spacing.md),
                SharedPasswordField(
                  controller: _password,
                  label: 'Password',
                  hint: 'Your password',
                  isDisabled: _saving,
                ),
                SizedBox(height: theme.spacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: LoaderButton(
                        label: 'Save changes',
                        isLoading: _saving,
                        onPressed: _onSave,
                        icon: Icons.check,
                        expand: true,
                      ),
                    ),
                    SizedBox(width: theme.spacing.sm),
                    LoaderIconButton(
                      icon: _favourited ? Icons.favorite : Icons.favorite_border,
                      variant: SharedButtonVariant.secondary,
                      onPressed: () => setState(() => _favourited = !_favourited),
                    ),
                    SizedBox(width: theme.spacing.sm),
                    LoaderButton(
                      label: 'Delete',
                      variant: SharedButtonVariant.danger,
                      onPressed: () => showSharedConfirmDialog(
                        context: context,
                        title: 'Delete account?',
                        message: 'This action cannot be undone.',
                        tone: SharedDialogTone.danger,
                        confirmLabel: 'Delete',
                        onConfirm: () =>
                            Future.delayed(const Duration(seconds: 1)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: theme.spacing.md),
                Wrap(
                  spacing: theme.spacing.xs,
                  runSpacing: theme.spacing.xs,
                  children: const [
                    SharedChip(label: 'Flutter', selected: true),
                    SharedChip(label: 'Dart'),
                    SharedChip(label: 'Loading', isLoading: true),
                    SharedChip(label: 'Disabled', isDisabled: true),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          Text('SuperList', style: theme.typography.title),
          SizedBox(height: theme.spacing.sm),
          SharedCard(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 360,
              child: SuperList<String>(
                items: _items,
                status: _listStatus,
                onRefresh: _refresh,
                onLoadMore: _loadMore,
                onRetry: _loadInitial,
                itemBuilder: (context, i) => SuperListTile(
                  title: _items[i],
                  subtitle: 'Tap to mark as read',
                  leading: const SharedAvatar(initials: 'A', size: SharedAvatarSize.sm),
                  trailing: const SharedBadge(label: 'NEW', tone: SharedBadgeTone.info),
                  onTap: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.xl),
        ],
      ),
    );
  }
}
