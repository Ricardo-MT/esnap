import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/colors_overview/bloc/colors_overview_bloc.dart';
import 'package:esnap/app_views/edit_item/edit_todo.dart';
import 'package:esnap/app_views/edit_item/widgets/wid_image_picker.dart';
import 'package:esnap/app_views/edit_item/widgets/wid_select.dart';
import 'package:esnap/app_views/occasions_overview/bloc/occasions_overview_bloc.dart';
import 'package:esnap/utils/text_button_helpers.dart';
import 'package:esnap/widgets/color_indicator.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    content: Text('ERROR DESCONOCIDO'),
                  ),
                );
            }
          },
        ),
        BlocListener<EditItemBloc, EditItemState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == EditItemStatus.success,
          listener: (context, state) => Navigator.of(context).pop(),
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
    final status = context.select((EditItemBloc bloc) => bloc.state.status);
    final isNewItem = context.select(
      (EditItemBloc bloc) => bloc.state.isNewItem,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewItem ? 'New item' : 'Editing item',
        ),
        actions: [
          BlocBuilder<EditItemBloc, EditItemState>(
            buildWhen: (previous, current) =>
                previous.isValid != current.isValid,
            builder: (context, state) {
              return TextButton(
                key: const Key('editItemView_save_iconButton'),
                style: removeSplashEffect(context),
                onPressed: (status.isLoadingOrSuccess || !state.isValid)
                    ? null
                    : () => context
                        .read<EditItemBloc>()
                        .add(const EditItemSubmitted()),
                child: const Text('Save'),
              );
            },
          ),
        ],
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _ImageField(),
                spacerM,
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
    );
  }
}

class _ImageField extends StatelessWidget {
  const _ImageField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditItemBloc>().state;
    return Stack(
      children: [
        Hero(
          tag: state.imagePath ?? 'edit_image_unset_image_path',
          child: WidImagePicker(
            imagePath: state.imagePath,
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
            icon: Icon(state.favorite ? Icons.favorite : Icons.favorite_border),
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
  }
}

class _ClassificationField extends StatelessWidget {
  const _ClassificationField();

  @override
  Widget build(BuildContext context) {
    final classifications =
        context.watch<ClassificationsOverviewBloc>().state.classifications;
    final state = context.watch<EditItemBloc>().state;

    return DropdownButtonFormField<EsnapClassification>(
      decoration: const InputDecoration(label: Text('Classification')),
      value: state.classification,
      items: classifications
          .map(
            (e) => DropdownMenuItem<EsnapClassification>(
              value: e,
              child: Text(e.name),
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

    return DropdownButtonFormField<EsnapColor>(
      decoration: const InputDecoration(label: Text('Color')),
      value: state.color,
      items: colors
          .map(
            (e) => DropdownMenuItem<EsnapColor>(
              value: e,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(e.name),
                  spacerXs,
                  ColorIndicator(hexColor: e.hexColor),
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
    final state = context.watch<EditItemBloc>().state;
    const hintText = 'Occasions go here';

    return WidSelectMultiple(
      label: 'Occasions',
      values: state.occasions.map((e) => e.name).toList(),
      hint: hintText,
      onChanged: (value) {
        final found = value == null
            ? <EsnapOccasion>[]
            : occasions
                .where((element) => value.contains(element.name))
                .toList();
        context.read<EditItemBloc>().add(EditItemOccasionsChanged(found));
      },
      options: occasions.map((e) => e.name).toList(),
    );
  }
}
