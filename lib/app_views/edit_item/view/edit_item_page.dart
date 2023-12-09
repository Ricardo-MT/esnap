import 'dart:io';

import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/colors_overview/bloc/colors_overview_bloc.dart';
import 'package:esnap/app_views/edit_item/edit_todo.dart';
import 'package:esnap/app_views/edit_item/widgets/image_picker/wid_image_picker.dart';
import 'package:esnap/app_views/edit_item/widgets/wid_select.dart';
import 'package:esnap/app_views/home/view/home_view.dart';
import 'package:esnap/app_views/occasions_overview/bloc/occasions_overview_bloc.dart';
import 'package:esnap/app_views/translations/translations_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/utils/dimensions.dart';
import 'package:esnap/utils/text_button_helpers.dart';
import 'package:esnap/widgets/color_indicator.dart';
import 'package:esnap/widgets/page_constrainer.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_tools_repository/image_tools_repository.dart';
import 'package:wid_design_system/wid_design_system.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  static Route<void> route({Item? initialItem}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => EditItemBloc(
              esnapRepository: context.read<EsnapRepository>(),
              imageToolsRepository: context.read<ImageToolsRepository>(),
              initialItem: initialItem,
            ),
          ),
          BlocProvider(
            create: (context) => ColorsOverviewBloc(
              colorRepository: context.read<ColorRepository>(),
            )..add(const ColorsOverviewSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => ClassificationsOverviewBloc(
              classificationRepository:
                  context.read<ClassificationRepository>(),
            )..add(const ClassificationsOverviewSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => OccasionsOverviewBloc(
              occasionRepository: context.read<OccasionRepository>(),
            )..add(const OccasionsOverviewSubscriptionRequested()),
          ),
        ],
        child: const EditItemPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ColorsOverviewBloc, ColorsOverviewState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == ColorsOverviewStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('error'),
                  ),
                );
            }
          },
        ),
        BlocListener<EditItemBloc, EditItemState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == EditItemStatus.success,
          listener: (context, state) {
            if (state.status == EditItemStatus.success) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<dynamic>(
                  builder: (_) => const HomePage(
                    index: 1,
                  ),
                ),
                (route) => false,
              );
            }
          },
        ),
      ],
      child: const WidTapToHideKeyboard(child: EditItemView()),
    );
  }
}

class EditItemView extends StatelessWidget {
  const EditItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final isNewItem = context.select(
      (EditItemBloc bloc) => bloc.state.isNewItem,
    );
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewItem ? l10n.newItemTitle : l10n.editingItemTitle,
        ),
        actions: const [
          _SaveActionButton(),
        ],
      ),
      body: const PageConstrainer(
        child: CupertinoScrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _ImageField(),
                  spacerXs,
                  Align(
                    alignment: Alignment.centerRight,
                    child: _ImageVersionToggler(),
                  ),
                  spacerXs,
                  _ClassificationField(),
                  spacerM,
                  _ColorField(),
                  spacerM,
                  _OccasionField(),
                ],
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
    return BlocBuilder<EditItemBloc, EditItemState>(
      buildWhen: (previous, current) =>
          previous.isUsingOriginalImage != current.isUsingOriginalImage ||
          previous.imagePath != current.imagePath ||
          previous.backgroundRemovedImage != current.backgroundRemovedImage ||
          previous.favorite != current.favorite,
      builder: (context, state) {
        File? imageFile;
        if (state.isUsingOriginalImage) {
          if (state.imagePath != null && state.imagePath!.isNotEmpty) {
            imageFile = File(state.imagePath!);
          }
        }
        return Stack(
          children: [
            Hero(
              tag: state.imagePath ?? 'edit_image_unset_image_path',
              child: WidImagePicker(
                imageFile: imageFile,
                imageBytes: state.backgroundRemovedImage,
                isFromFile: state.isUsingOriginalImage,
                onPicked: (p0) {
                  context
                      .read<EditItemBloc>()
                      .add(EditItemImagePathChanged(p0.path));
                },
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(
                  state.favorite ? Icons.favorite : Icons.favorite_border,
                ),
                iconSize: 30,
                padding: EdgeInsets.zero,
                color: WidAppColors.light,
                visualDensity: VisualDensity.compact,
                splashRadius: 5,
                onPressed: () => context
                    .read<EditItemBloc>()
                    .add(EditItemFavoriteChanged(favorite: !state.favorite)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ClassificationField extends StatelessWidget {
  const _ClassificationField();

  @override
  Widget build(BuildContext context) {
    final classifications =
        context.watch<ClassificationsOverviewBloc>().state.classifications;
    final translationBloc = context.watch<TranslationsBloc>();
    final state = context.watch<EditItemBloc>().state;
    final l10n = context.l10n;

    return DropdownButtonFormField<EsnapClassification>(
      decoration: InputDecoration(label: Text(l10n.classificationLabel)),
      menuMaxHeight: AppDimenssions.menuMaxHeight,
      value: state.classification,
      items: classifications
          .map(
            (classification) => DropdownMenuItem<EsnapClassification>(
              value: classification,
              child: Text(
                translationBloc
                    .getTranslationForClassification(classification)!,
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        context.read<EditItemBloc>().add(EditItemClassificationChanged(value));
      },
    );
  }
}

class _ColorField extends StatelessWidget {
  const _ColorField();

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ColorsOverviewBloc>().state.colors;
    final state = context.watch<EditItemBloc>().state;
    final translationBloc = context.watch<TranslationsBloc>();
    final l10n = context.l10n;

    return DropdownButtonFormField<EsnapColor>(
      decoration: InputDecoration(label: Text(l10n.colorLabel)),
      menuMaxHeight: AppDimenssions.menuMaxHeight,
      value: state.color,
      items: colors
          .map(
            (color) => DropdownMenuItem<EsnapColor>(
              value: color,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    translationBloc.getTranslationForColor(color)!,
                  ),
                  spacerXs,
                  ColorIndicator(hexColor: color.hexColor),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        context.read<EditItemBloc>().add(EditItemColorChanged(value));
      },
    );
  }
}

class _OccasionField extends StatelessWidget {
  const _OccasionField();

  @override
  Widget build(BuildContext context) {
    final occasions = context.watch<OccasionsOverviewBloc>().state.occasions;
    final translationBloc = context.watch<TranslationsBloc>();
    final state = context.watch<EditItemBloc>().state;
    final l10n = context.l10n;

    return WidSelectMultiple(
      label: l10n.ocassionsLabel,
      values: state.occasions
          .map(
            (occasion) => translationBloc.getTranslationForOccasion(occasion)!,
          )
          .toList(),
      hint: l10n.ocassionsHintText,
      onChanged: (value) {
        final found = value == null
            ? <EsnapOccasion>[]
            : occasions
                .where(
                  (occasion) => value.contains(
                    translationBloc.getTranslationForOccasion(occasion),
                  ),
                )
                .toList();
        context.read<EditItemBloc>().add(EditItemOccasionsChanged(found));
      },
      options: occasions
          .map(
            (occasion) => translationBloc.getTranslationForOccasion(occasion)!,
          )
          .toList(),
    );
  }
}

class _SaveActionButton extends StatelessWidget {
  const _SaveActionButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditItemBloc bloc) => bloc.state.status);
    return BlocBuilder<EditItemBloc, EditItemState>(
      buildWhen: (previous, current) => previous.isValid != current.isValid,
      builder: (context, state) {
        return TextButton(
          key: const Key('editItemView_save_iconButton'),
          style: removeSplashEffect(context),
          onPressed: (status.isLoadingOrSuccess || !state.isValid)
              ? null
              : () =>
                  context.read<EditItemBloc>().add(const EditItemSubmitted()),
          child: Text(l10n.save),
        );
      },
    );
  }
}

class _ImageVersionToggler extends StatelessWidget {
  const _ImageVersionToggler();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final mainColor = theme.buttonTheme.colorScheme!.primary;
    final textButtonPadding =
        theme.textButtonTheme.style!.padding?.resolve({}) ?? EdgeInsets.zero;
    return BlocBuilder<EditItemBloc, EditItemState>(
      builder: (context, state) {
        final isLoading =
            state.removingBackgroundStatus == EditItemStatus.loading;
        final text = state.removingBackgroundStatus == EditItemStatus.failure
            ? l10n.tryAgain
            : state.isUsingOriginalImage
                ? l10n.removeBackground
                : l10n.useOriginalImage;
        return Visibility.maintain(
          visible: state.canRemoveBackground,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 175),
            child: isLoading
                ? Padding(
                    padding: textButtonPadding,
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : TextButton(
                    style: removeSplashEffect(context),
                    onPressed: () => context
                        .read<EditItemBloc>()
                        .add(const EditItemRequestToggleImage()),
                    child: Text(
                      text,
                      style:
                          TextStyle(fontSize: 14, height: 1, color: mainColor),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
