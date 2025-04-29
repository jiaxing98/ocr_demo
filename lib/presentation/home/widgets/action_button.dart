import 'package:flutter/material.dart';
import 'package:ocr_demo/core/extensions/build_context.dart';

class ActionButton extends StatelessWidget {
  final Locale locale;
  final void Function(Locale)? onPressed;

  const ActionButton({
    super.key,
    required this.locale,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: context.colorScheme.secondary,
      ),
      onPressed: () => onPressed?.call(locale),
      child: Text(locale.languageCode.toUpperCase()),
    );
  }
}
