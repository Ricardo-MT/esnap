import 'dart:io';

import 'package:esnap/app_views/detail_outfit/bloc/detail_outfit_bloc.dart';
import 'package:esnap/app_views/edit_outfit/view/edit_outfit.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/utils/get_translated_name.dart';
import 'package:esnap/utils/text_button_helpers.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class DetailOutfitPage extends StatelessWidget {
  const DetailOutfitPage({super.key});

  static Route<void> route({required Outfit item}) {
    return MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DetailOutfitBloc(
              outfitRepository: context.read<OutfitRepository>(),
              item: item,
            ),
          ),
        ],
        child: const DetailOutfitPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DetailOutfitBloc, DetailOutfitState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == DetailOutfitStatus.success,
          listener: (context, state) => Navigator.of(context).pop(),
        ),
      ],
      child: const WidTapToHideKeyboard(child: DetailOutfitView()),
    );
  }
}

class DetailOutfitView extends StatelessWidget {
  const DetailOutfitView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((DetailOutfitBloc bloc) => bloc.state.status);
    final state = context.watch<DetailOutfitBloc>().state;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedNameFromOutfit(context, state.item),
          maxLines: 2,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            style: removeSplashEffect(context),
            onPressed: status.isLoading
                ? null
                : () => Navigator.of(context).pushReplacement(
                      EditOutfitPage.route(initialOutfit: state.item),
                    ),
            child: Text(l10n.edit),
          ),
        ],
      ),
      persistentFooterButtons: [
        TextButton(
          style: removeSplashEffect(context),
          onPressed: () => showAdaptiveDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog.adaptive(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(l10n.deleteOutfit),
              content: Text(l10n.deleteOutfitConfirmation),
              actions: [
                TextButton(
                  style: removeSplashEffect(context),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  style: confirmButtonStyle(context),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.read<DetailOutfitBloc>().add(
                          const DetailOutfitDeleteSubmitted(),
                        );
                  },
                  child: Text(l10n.delete),
                ),
              ],
            ),
          ),
          child: Text(l10n.delete),
        ),
      ],
      body: BlocBuilder<DetailOutfitBloc, DetailOutfitState>(
        builder: (context, state) {
          return _OutfitOverview(state.item);
        },
      ),
    );
  }
}

class _OutfitOverview extends StatelessWidget {
  const _OutfitOverview(this.outfit);
  final Outfit outfit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        children: [
          spacerXs,
          Expanded(
            flex: 4,
            child: _ItemDisplay(
              label: l10n.top,
              type: 'Top',
              item: outfit.top,
            ),
          ),
          spacerXs,
          Expanded(
            flex: 4,
            child: _ItemDisplay(
              label: l10n.bottom,
              type: 'Bottom',
              item: outfit.bottom,
            ),
          ),
          spacerXs,
          Expanded(
            flex: 3,
            child: _ItemDisplay(
              label: l10n.shoes,
              type: 'Shoes',
              item: outfit.shoes,
            ),
          ),
          spacerM,
        ],
      ),
    );
  }
}

class _ItemDisplay extends StatelessWidget {
  const _ItemDisplay({
    required this.label,
    required this.type,
    this.item,
  });
  final String label;
  final String type;
  final Item? item;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: item != null
              ? null
              : Theme.of(context).brightness == Brightness.dark
                  ? WidAppColors.n600
                  : WidAppColors.n300,
          image: item?.imagePath == null
              ? null
              : DecorationImage(
                  image: FileImage(File(item!.imagePath!)),
                  fit: BoxFit.cover,
                ),
          borderRadius: BorderRadius.circular(
            WidAppDimensions.borderRadiusControllers,
          ),
        ),
        child: Visibility(
          visible: item == null,
          child: Center(
            child: WidText.headlineMedium(
              text: label,
              style: const TextStyle(color: WidAppColors.black),
            ),
          ),
        ),
      ),
    );
  }
}
