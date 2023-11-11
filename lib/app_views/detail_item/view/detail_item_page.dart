import 'dart:io';

import 'package:esnap/app_views/detail_item/bloc/detail_item_bloc.dart';
import 'package:esnap/app_views/edit_item/view/edit_item_page.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/utils/text_button_helpers.dart';
import 'package:esnap/widgets/color_indicator.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class DetailItemPage extends StatelessWidget {
  const DetailItemPage({super.key});

  static Route<void> route({required Item item}) {
    return MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DetailItemBloc(
              esnapRepository: context.read<EsnapRepository>(),
              item: item,
            ),
          ),
        ],
        child: const DetailItemPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DetailItemBloc, DetailItemState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == DetailItemStatus.success,
          listener: (context, state) => Navigator.of(context).pop(),
        ),
      ],
      child: const WidTapToHideKeyboard(child: DetailItemView()),
    );
  }
}

class DetailItemView extends StatelessWidget {
  const DetailItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((DetailItemBloc bloc) => bloc.state.status);
    final state = context.watch<DetailItemBloc>().state;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.item.classification?.name ?? l10n.noClassification,
        ),
        actions: [
          TextButton(
            style: removeSplashEffect(context),
            onPressed: status.isLoading
                ? null
                : () => Navigator.of(context).pushReplacement(
                      EditItemPage.route(initialItem: state.item),
                    ),
            child: Text(l10n.edit),
          ),
        ],
      ),
      persistentFooterButtons: [
        TextButton(
          style: removeSplashEffect(context),
          onPressed: () async {
            await showAdaptiveDialog<AlertDialog>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(l10n.deleteItem),
                content: Text(l10n.deleteItemConfirmation),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.read<DetailItemBloc>().add(
                            const DetailItemDeleteSubmitted(),
                          );
                    },
                    child: Text(l10n.delete),
                  ),
                  TextButton(
                    style: removeSplashEffect(context),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(l10n.cancel),
                  ),
                ],
              ),
            );
          },
          child: Text(l10n.delete),
        ),
      ],
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ImageField(),
                    spacerM,
                    _ColorField(),
                    spacerXs,
                    _OccasionField(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageField extends StatelessWidget {
  const _ImageField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailItemBloc>().state;
    return Stack(
      children: [
        Hero(
          tag: state.item.imagePath ?? 'edit_image_unset_image_path',
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(WidAppDimensions.borderRadiusControllers),
            child: AspectRatio(
              aspectRatio: 1,
              child: WidTouchable(
                onPress: state.status.isLoading
                    ? () {}
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<Scaffold>(
                            fullscreenDialog: true,
                            builder: (context) => Scaffold(
                              backgroundColor: WidAppColors.black,
                              appBar: AppBar(
                                backgroundColor: WidAppColors.black,
                                foregroundColor: Colors.white,
                                iconTheme:
                                    const IconThemeData(color: Colors.white),
                              ),
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Hero(
                                      tag: state.item.imagePath ??
                                          'edit_image_unset_image_path',
                                      child: Image.file(
                                        File(
                                          state.item.imagePath!,
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                child: Image.file(
                  File(
                    state.item.imagePath!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            splashRadius: 1,
            onPressed: state.status.isLoading
                ? null
                : () {
                    context.read<DetailItemBloc>().add(
                          DetailItemFavoriteChanged(
                            favorite: !state.item.favorite,
                          ),
                        );
                  },
            icon: Icon(
              state.item.favorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorField extends StatelessWidget {
  const _ColorField();

  @override
  Widget build(BuildContext context) {
    final color = context.watch<DetailItemBloc>().state.item.color;
    final l10n = context.l10n;
    return Row(
      children: [
        WidText.headlineLarge(text: color?.name ?? l10n.noColor),
        spacerS,
        Visibility(
          visible: color != null,
          child: ColorIndicator(hexColor: color?.hexColor ?? 0x00000000),
        ),
      ],
    );
  }
}

class _OccasionField extends StatelessWidget {
  const _OccasionField();

  @override
  Widget build(BuildContext context) {
    final occasions = context.watch<DetailItemBloc>().state.item.occasions;
    final l10n = context.l10n;
    return WidText.headlineSmall(
      text: occasions.isEmpty
          ? l10n.noOcassions
          : occasions.map((e) => e.name).join(', '),
    );
  }
}
