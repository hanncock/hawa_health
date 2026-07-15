import 'package:flutter/material.dart';
import 'hawa_design_system.dart';

class HawaPrimaryButton extends StatelessWidget {
  const HawaPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: HawaColors.primary,
          disabledBackgroundColor: HawaColors.ink12,
          foregroundColor: HawaColors.white,
          disabledForegroundColor: HawaColors.ink60,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HawaRadius.pill),
          ),
          textStyle: HawaTypography.button(),
        ),
        child: Text(label),
      ),
    );
  }
}

class HawaSecondaryButton extends StatelessWidget {
  const HawaSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: HawaColors.primary,
          side: const BorderSide(color: HawaColors.primary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HawaRadius.pill),
          ),
          textStyle: HawaTypography.body(
            size: 16,
            weight: FontWeight.w700,
            color: HawaColors.primary,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class HawaCard extends StatelessWidget {
  const HawaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? HawaColors.white,
        borderRadius: BorderRadius.circular(HawaRadius.large),
        boxShadow: HawaShadows.card,
      ),
      child: child,
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HawaRadius.large),
        child: card,
      ),
    );
  }
}

class HawaChip extends StatelessWidget {
  const HawaChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: HawaCurves.smooth,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? HawaColors.primary : HawaColors.creamDark,
          borderRadius: BorderRadius.circular(HawaRadius.pill),
        ),
        child: Text(
          label,
          style: HawaTypography.body(
            size: 13,
            weight: FontWeight.w600,
            color: selected ? HawaColors.white : HawaColors.ink,
          ),
        ),
      ),
    );
  }
}

class HawaUnderlineField extends StatefulWidget {
  const HawaUnderlineField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  @override
  State<HawaUnderlineField> createState() => _HawaUnderlineFieldState();
}

class _HawaUnderlineFieldState extends State<HawaUnderlineField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          curve: HawaCurves.smooth,
          style: HawaTypography.label().copyWith(
            fontSize: _focused || widget.controller.text.isNotEmpty ? 11 : 13,
            color: _focused ? HawaColors.primary : HawaColors.ink60,
          ),
          child: Text(widget.label),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          style: HawaTypography.body(size: 16),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: HawaTypography.body(color: HawaColors.ink60),
            suffixIcon: widget.suffix,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: HawaColors.ink12, width: 1),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HawaColors.ink12, width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: HawaColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }
}

class HawaFeatureCard extends StatelessWidget {
  const HawaFeatureCard({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String number;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return HawaCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Text(
            number,
            style: HawaTypography.display(
              number,
              size: 32,
              style: FontStyle.normal,
            ).copyWith(color: HawaColors.secondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: HawaTypography.body(size: 16, weight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: HawaTypography.bodySecondary(size: 13)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: HawaColors.ink60),
        ],
      ),
    );
  }
}

class HawaPrivacyBadge extends StatelessWidget {
  const HawaPrivacyBadge({super.key, this.text = 'Your data is encrypted'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.shield_outlined, size: 16, color: HawaColors.secondary),
        const SizedBox(width: 6),
        Text(text, style: HawaTypography.bodySecondary(size: 12)),
      ],
    );
  }
}

class HawaPageHeader extends StatelessWidget {
  const HawaPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: HawaTypography.display(title, size: 30)),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(subtitle!, style: HawaTypography.bodySecondary(size: 14)),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class HawaSectionTitle extends StatelessWidget {
  const HawaSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: HawaTypography.body(size: 18, weight: FontWeight.w700, color: HawaColors.primary),
    );
  }
}

class HawaFab extends StatelessWidget {
  const HawaFab({super.key, required this.onPressed, this.icon = Icons.add});

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: HawaShadows.fab,
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: HawaColors.accent,
        elevation: 0,
        child: Icon(icon, color: HawaColors.white),
      ),
    );
  }
}

class HawaBottomNav extends StatelessWidget {
  const HawaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.lightbulb_outline, Icons.lightbulb, 'Tips'),
    (Icons.add_circle_outline, Icons.add_circle, 'Log'),
    (Icons.insert_chart_outlined, Icons.insert_chart, 'Report'),
    (Icons.person_outline, Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HawaColors.white,
        border: Border(top: BorderSide(color: HawaColors.ink6)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = currentIndex == i;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        active ? item.$2 : item.$1,
                        size: 22,
                        color: active ? HawaColors.primary : HawaColors.ink60,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$3,
                        style: HawaTypography.body(
                          size: 10,
                          weight: active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? HawaColors.primary : HawaColors.ink60,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class HawaProgressBar extends StatelessWidget {
  const HawaProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final active = index <= current;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: HawaCurves.smooth,
            height: 4,
            margin: EdgeInsets.only(right: index < total - 1 ? 8 : 0),
            decoration: BoxDecoration(
              color: active ? HawaColors.primary : HawaColors.ink12,
              borderRadius: BorderRadius.circular(HawaRadius.pill),
            ),
          ),
        );
      }),
    );
  }
}
