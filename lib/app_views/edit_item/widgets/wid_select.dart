import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:wid_design_system/wid_design_system.dart';

/// Multiple select
class WidSelectMultiple extends StatelessWidget {
  WidSelectMultiple({
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
  List<String>? values;
  String hint;
  List<String> options;
  String? Function(String?)? validator;
  void Function(List<String>?)? onChanged;
  bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: WidAppColors.error),
                    )
                  ]
                : [],
          ),
        ),
        spacerS,
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              await showDialog(
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
                      'cancel',
                      style: textStyles,
                    ),
                    confirmText: const Text(
                      'ok',
                      style: TextStyle(color: WidAppColors.callToAction),
                    ),
                    selectedColor: WidAppColors.callToAction,
                    unselectedColor: theme.disabledColor,
                    itemsTextStyle: itemsTextStyles,
                    selectedItemsTextStyle: itemsTextStyles,
                    width: 400,
                    height: 600,
                    items: [
                      for (var i = 0; i < options.length; i++)
                        MultiSelectItem(options[i], options[i])
                    ],
                    initialValue: values ?? [],
                    onConfirm: (values) {
                      onChanged?.call([
                        for (var i = 0; i < values.length; i++)
                          values[i].toString()
                      ]);
                    },
                  );
                },
              );
            },
            child: AbsorbPointer(
              child: TextFormField(
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
        )
      ],
    );
  }
}
