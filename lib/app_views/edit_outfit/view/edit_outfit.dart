import 'package:esnap/app_views/classification_types_overview/bloc/classification_types_overview_bloc.dart';
import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/edit_outfit/bloc/edit_outfit_bloc.dart';
import 'package:esnap/app_views/edit_outfit/widgets/edit_outfit_controller.dart';
import 'package:esnap/app_views/edit_outfit/widgets/edit_outfit_overview.dart';
import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap/utils/text_button_helpers.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class EditOutfitPage extends StatelessWidget {
  const EditOutfitPage._();

  static Route<void> route({Outfit? initialOutfit}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ClassificationTypesOverviewBloc(
              classificationTypeRepository:
                  context.read<ClassificationTypeRepository>(),
            )..add(const ClassificationTypesOverviewSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => ItemsOverviewBloc(
              esnapRepository: context.read<EsnapRepository>(),
            )..add(const ItemsOverviewSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => ClassificationsOverviewBloc(
              classificationRepository:
                  context.read<ClassificationRepository>(),
            )..add(const ClassificationsOverviewSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => EditOutfitBloc(
              outfitRepository: context.read<OutfitRepository>(),
              classificationType: 'Top',
              outfit: initialOutfit,
            ),
            child: const _EditOutfitView(),
          ),
        ],
        child: const EditOutfitPage._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _EditOutfitView();
  }
}

class _EditOutfitView extends StatelessWidget {
  const _EditOutfitView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditOutfitBloc, EditOutfitState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EditOutfitStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Failed to edit outfit')),
            );
          return;
        }
        if (state.status == EditOutfitStatus.success) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<EditOutfitBloc, EditOutfitState>(
            buildWhen: (previous, current) =>
                previous.isNewOutfit != current.isNewOutfit,
            builder: (context, state) {
              return Text(
                state.isNewOutfit ? 'New outfit' : 'Editing outfit',
              );
            },
          ),
          actions: [
            BlocBuilder<EditOutfitBloc, EditOutfitState>(
              buildWhen: (previous, current) =>
                  previous.isValid != current.isValid,
              builder: (context, state) {
                return TextButton(
                  key: const Key('editOutfitView_save_iconButton'),
                  style: removeSplashEffect(context),
                  onPressed: !state.isValid
                      ? null
                      : () => context
                          .read<EditOutfitBloc>()
                          .add(const EditOutfitSubmitted()),
                  child: const Text('Save'),
                );
              },
            ),
          ],
        ),
        body: const SafeArea(
          child: Column(
            children: [
              Expanded(child: OutfitOverview()),
              spacerS,
              OutfitControllers(),
            ],
          ),
        ),
      ),
    );
  }
}
