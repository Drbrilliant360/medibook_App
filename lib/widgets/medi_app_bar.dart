import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/app_colors.dart';

/// A stunning, reusable AppBar for MediBook.
///
/// Supports two styles:
///  - [MediAppBarStyle.primary] — gradient blue header (default for main screens)
///  - [MediAppBarStyle.surface]  — clean white/surface header (for detail/inner screens)
///
/// Usage:
/// ```dart
/// appBar: MediAppBar(
///   title: 'Dashboard',
///   subtitle: 'Welcome back',
///   actions: [...],
/// )
/// ```
enum MediAppBarStyle { primary, surface }

class MediAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final MediAppBarStyle style;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final PreferredSizeWidget? bottom;
  final double? elevation;

  const MediAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.style = MediAppBarStyle.primary,
    this.actions,
    this.leading,
    this.showBack = false,
    this.bottom,
    this.elevation,
  });

  /// Quick constructor for inner / detail screens — surface style with back arrow.
  const MediAppBar.inner({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.bottom,
  })  : style = MediAppBarStyle.surface,
        leading = null,
        showBack = true,
        elevation = 0;

  @override
  Size get preferredSize {
    double h = kToolbarHeight;
    if (subtitle != null) h += 4;
    if (bottom != null) h += bottom!.preferredSize.height;
    return Size.fromHeight(h);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (style == MediAppBarStyle.surface) {
      return AppBar(
        title: _buildTitle(isDark ? Colors.white : AppColors.textPrimary),
        centerTitle: false,
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
        elevation: elevation ?? 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: showBack,
        leading: leading,
        actions: _wrappedActions(isDark ? Colors.white70 : AppColors.textSecondary),
        bottom: bottom != null ? _styledBottom(isDark) : null,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      );
    }

    // Primary gradient style
    return AppBar(
      title: _buildTitle(Colors.white),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: showBack,
      leading: leading,
      actions: _wrappedActions(Colors.white70),
      bottom: bottom != null ? _styledBottom(false, onPrimary: true) : null,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(Color color) {
    if (subtitle == null) {
      return Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: -0.3,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          subtitle!,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: color.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  List<Widget>? _wrappedActions(Color iconColor) {
    if (actions == null || actions!.isEmpty) return null;
    return [
      ...actions!,
      const SizedBox(width: 4),
    ];
  }

  PreferredSizeWidget _styledBottom(bool isDark, {bool onPrimary = false}) {
    if (bottom is TabBar) {
      final tab = bottom as TabBar;
      return TabBar(
        tabs: tab.tabs,
        isScrollable: tab.isScrollable,
        controller: tab.controller,
        indicatorColor: onPrimary ? Colors.white : AppColors.primary,
        indicatorWeight: 3,
        labelColor: onPrimary ? Colors.white : AppColors.primary,
        unselectedLabelColor: onPrimary
            ? Colors.white60
            : (isDark ? Colors.white54 : AppColors.textSecondary),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        dividerHeight: 0,
      );
    }
    return bottom!;
  }
}
