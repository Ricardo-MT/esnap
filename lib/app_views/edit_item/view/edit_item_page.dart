import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/colors_overview/bloc/colors_overview_bloc.dart';
import 'package:esnap/app_views/edit_item/edit_todo.dart';
import 'package:esnap/app_views/edit_item/widgets/wid_image_picker.dart';
import 'package:esnap/app_views/edit_item/widgets/wid_select.dart';
import 'package:esnap/app_views/occasions_overview/bloc/occasions_overview_bloc.dart';
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
        )
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
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditItemBloc>().add(const EditItemSubmitted()),
        icon: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator(
                color: WidAppColors.light,
              )
            : const Icon(Icons.save),
        label: const Text('Save'),
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
    return WidImagePicker(
      imagePath: state.imagePath,
      onPicked: (p0) {
        context.read<EditItemBloc>().add(EditItemImagePathChanged(p0.path));
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
    final state = context.watch<EditItemBloc>().state;
    const hintText = 'Classification goes here';

    return DropdownButtonFormField<EsnapClassification>(
      decoration: const InputDecoration(label: Text('Classification')),
      hint: const Text(hintText),
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
    // return TextFormField(
    //   key: const Key('editItemView_description_textFormField'),
    //   initialValue: state.classification,
    //   decoration: InputDecoration(
    //     enabled: !state.status.isLoadingOrSuccess,
    //     labelText: 'Classification',
    //     hintText: hintText,
    //   ),
    //   maxLength: 300,
    //   maxLines: 7,
    //   inputFormatters: [
    //     LengthLimitingTextInputFormatter(300),
    //   ],
    //   onChanged: (value) {
    //     context.read<EditItemBloc>().add(EditItemClassificationChanged(value));
    //   },
    // );
  }
}

class _ColorField extends StatelessWidget {
  const _ColorField();

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ColorsOverviewBloc>().state.colors;
    final state = context.watch<EditItemBloc>().state;
    const hintText = 'Color goes here';

    return DropdownButtonFormField<EsnapColor>(
      decoration: const InputDecoration(label: Text('Color')),
      hint: const Text(hintText),
      value: state.color,
      items: colors
          .map(
            (e) => DropdownMenuItem<EsnapColor>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList(),
      onChanged: (value) {
        context.read<EditItemBloc>().add(EditItemColorChanged(value));
      },
    );
    // return TextFormField(
    //   key: const Key('editItemView_title_textFormField'),
    //   initialValue: state.color,
    //   decoration: InputDecoration(
    //     enabled: !state.status.isLoadingOrSuccess,
    //     labelText: 'Title',
    //     hintText: hintText,
    //   ),
    //   maxLength: 50,
    //   inputFormatters: [
    //     LengthLimitingTextInputFormatter(50),
    //     FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
    //   ],
    //   onChanged: (value) {
    //     context.read<EditItemBloc>().add(EditItemColorChanged(value));
    //   },
    // );
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
