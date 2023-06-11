import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    required this.item,
    super.key,
    this.onTap,
  });

  final Item item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return ListTile(
      onTap: onTap,
      title: Text(
        item.classification,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: captionColor,
          decoration: TextDecoration.lineThrough,
        ),
      ),
      subtitle: Text(
        item.color,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
    );
  }
}
