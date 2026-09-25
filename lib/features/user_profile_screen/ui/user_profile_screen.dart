import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/add_my_recipe_screen/ui/add_my_recipe_screen.dart';
import 'package:recipebook/features/user_profile_screen/model/user_profile.dart';
import 'package:recipebook/features/user_profile_screen/provider/user_content_provider.dart';
import 'package:recipebook/shared/provider/shared_provider.dart';
import 'package:recipebook/features/save_recipe_screen/ui/save_recipe_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          tooltip: 'Edit profile',
          onPressed: () => _editProfile(context),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: 'About Recipe Book',
          onPressed: () => _showAbout(context),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    ),
    body: Consumer<UserContentProvider>(
      builder: (context, content, _) {
        if (content.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (content.loadError != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(content.loadError!, textAlign: TextAlign.center),
                TextButton.icon(
                  onPressed: content.retryLoad,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return Consumer<SharedProvider>(
          builder: (context, saved, _) {
            final profile = content.profile;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
              children: [
                Center(
                  child: Column(
                    children: [
                      _ProfileAvatar(profile: profile),
                      const SizedBox(height: 14),
                      Text(
                        profile.name.isEmpty
                            ? 'Your kitchen profile'
                            : profile.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      if (profile.email.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          profile.email,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                      if (profile.bio.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(profile.bio, textAlign: TextAlign.center),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'My recipes',
                        count: content.recipes.length,
                        icon: Icons.menu_book_outlined,
                        onTap: () => _open(context, const AddMyRecipeScreen()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Favorites',
                        count: saved.favorites.length,
                        icon: Icons.bookmark_border,
                        onTap: () => _open(context, const SaveRecipeScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Your kitchen',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.menu_book_outlined),
                        title: const Text('My recipes'),
                        subtitle: Text(
                          '${content.recipes.length} recipes saved on this device',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _open(context, const AddMyRecipeScreen()),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.bookmark_border),
                        title: const Text('Favorite recipes'),
                        subtitle: Text(
                          '${saved.favorites.length} recipes saved',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _open(context, const SaveRecipeScreen()),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Edit profile'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _editProfile(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About Recipe Book'),
                    subtitle: const Text(
                      'Locally saved recipes and profile stay on this device.',
                    ),
                    onTap: () => _showAbout(context),
                  ),
                ),
              ],
            );
          },
        );
      },
    ),
  );

  void _open(BuildContext context, Widget screen) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

  Future<void> _editProfile(BuildContext context) async {
    final state = context.read<UserContentProvider>();
    final saved = await showDialog<UserProfile>(
      context: context,
      builder: (_) => _EditProfileDialog(profile: state.profile),
    );
    if (saved == null || !context.mounted) return;
    try {
      await state.saveProfile(saved);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile saved.')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save your profile. Please retry.'),
          ),
        );
      }
    }
  }

  void _showAbout(BuildContext context) => showAboutDialog(
    context: context,
    applicationName: 'Recipe Book',
    applicationVersion: '1.0.0',
    children: const [
      Text(
        'Organize recipes you create and save your favorites locally on this device.',
      ),
    ],
  );
}

class _ProfileAvatar extends StatelessWidget {
  final UserProfile profile;
  const _ProfileAvatar({required this.profile});

  @override
  Widget build(BuildContext context) {
    final image = profile.imageUrl.trim();
    final uri = Uri.tryParse(image);
    final validImageUrl =
        image.isNotEmpty &&
        uri != null &&
        uri.hasAuthority &&
        ['http', 'https'].contains(uri.scheme);
    return Semantics(
      label: profile.name.isEmpty
          ? 'Profile image placeholder'
          : 'Profile image for ${profile.name}',
      child: validImageUrl
          ? CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, provider) =>
                  CircleAvatar(radius: 48, backgroundImage: provider),
              placeholder: (context, url) => _fallback(context),
              errorWidget: (context, url, error) => _fallback(context),
            )
          : _fallback(context),
    );
  }

  Widget _fallback(BuildContext context) => CircleAvatar(
    radius: 48,
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    child: Icon(
      Icons.person,
      size: 48,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final VoidCallback onTap;
  const _StatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ),
  );
}

class _EditProfileDialog extends StatefulWidget {
  final UserProfile profile;
  const _EditProfileDialog({required this.profile});

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.name);
  late final _email = TextEditingController(text: widget.profile.email);
  late final _bio = TextEditingController(text: widget.profile.bio);
  late final _image = TextEditingController(text: widget.profile.imageUrl);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _bio.dispose();
    _image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Edit profile'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                maxLength: 60,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? 'Enter your name.' : null,
              ),
              TextFormField(
                controller: _email,
                maxLength: 120,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isNotEmpty &&
                      !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                    return 'Enter a valid email.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bio,
                maxLength: 180,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              TextFormField(
                controller: _image,
                maxLength: 500,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Profile image URL (optional)',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return null;
                  final uri = Uri.tryParse(text);
                  return uri != null &&
                          uri.hasAuthority &&
                          ['http', 'https'].contains(uri.scheme)
                      ? null
                      : 'Enter a valid http or https URL.';
                },
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _saving ? null : _submit,
        child: _saving
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Save'),
      ),
    ],
  );

  void _submit() {
    if (!(_key.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    Navigator.pop(
      context,
      UserProfile(
        name: _name.text.trim(),
        email: _email.text.trim(),
        bio: _bio.text.trim(),
        imageUrl: _image.text.trim(),
      ),
    );
  }
}
