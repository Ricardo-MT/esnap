import 'dart:io';

import 'package:esnap/app_views/detail_outfit/bloc/detail_outfit_bloc.dart';
import 'package:esnap/app_views/edit_outfit/view/edit_outfit.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.item.toString(),
        ),
        actions: [
          TextButton(
            style: removeSplashEffect(context),
            onPressed: status.isLoading
                ? null
                : () => Navigator.of(context).pushReplacement(
                      EditOutfitPage.route(initialOutfit: state.item),
                    ),
            child: const Text('Edit'),
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
                title: const Text('Delete outfit'),
                content:
                    const Text('Are you sure you want to delete this outfit?'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.read<DetailOutfitBloc>().add(
                            const DetailOutfitDeleteSubmitted(),
                          );
                    },
                    child: const Text('Delete'),
                  ),
                  TextButton(
                    style: removeSplashEffect(context),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Delete'),
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
    return Center(
      child: Column(
        children: [
          spacerXs,
          Expanded(
            flex: 4,
            child: _ItemDisplay(
              label: 'Top',
              type: 'Top',
              item: outfit.top,
            ),
          ),
          spacerXs,
          Expanded(
            flex: 4,
            child: _ItemDisplay(
              label: 'Bottom',
              type: 'Bottom',
              item: outfit.bottom,
            ),
          ),
          spacerXs,
          Expanded(
            flex: 3,
            child: _ItemDisplay(
              label: 'Shoes',
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
