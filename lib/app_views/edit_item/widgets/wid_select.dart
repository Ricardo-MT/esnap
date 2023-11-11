import 'package:esnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:wid_design_system/wid_design_system.dart';

/// Multiple select
class WidSelectMultiple extends StatelessWidget {
  const WidSelectMultiple({
    required this.label,
    required this.values,
    required this.hint,
    required this.onChanged,
    required this.options,
    super.key,
    this.validator,
    this.required = false,
  });
  final String label;
  final List<String>? values;
  final String hint;
  final List<String> options;
  final String? Function(String?)? validator;
  final void Function(List<String>?)? onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await showDialog<void>(
            context: context,
            builder: (ctx) {
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final textStyles =
                  TextStyle(color: theme.textTheme.bodySmall?.color);
              final itemsTextStyles =
                  TextStyle(color: theme.textTheme.titleSmall?.color);
              return MultiSelectDialog(
                title: Text(
                  label,
                ),
                backgroundColor: colorScheme.background,
                cancelText: Text(
                  l10n.cancel,
                  style: textStyles,
                ),
                confirmText: Text(
                  l10n.ok,
                  style: const TextStyle(color: WidAppColors.callToAction),
                ),
                selectedColor: WidAppColors.callToAction,
                unselectedColor: theme.disabledColor,
                itemsTextStyle: itemsTextStyles,
                selectedItemsTextStyle: itemsTextStyles,
                width: 400,
                height: 600,
                items: [
                  for (var i = 0; i < options.length; i++)
                    MultiSelectItem(options[i], options[i]),
                ],
                initialValue: values ?? [],
                onConfirm: (values) {
                  onChanged?.call([
                    for (var i = 0; i < values.length; i++)
                      values[i].toString(),
                  ]);
                },
              );
            },
          );
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              label: Text(label),
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                size: 24,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.grey.shade700,
              ),
            ),
            key: ValueKey(values.hashCode),
            initialValue: (values ?? []).join(', '),
            readOnly: true,
            showCursor: false,
            validator: (val) {
              return validator?.call((values ?? []).join(', '));
            },
          ),
        ),
      ),
    );
  }
}
