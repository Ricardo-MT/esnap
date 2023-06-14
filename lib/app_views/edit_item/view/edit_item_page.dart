import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/colors_overview/bloc/colors_overview_bloc.dart';
import 'package:esnap/app_views/edit_item/edit_todo.dart';
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
      // builder: (context) => BlocProvider(
      //   create: (context) => EditItemBloc(
      //     esnapRepository: context.read<EsnapRepository>(),
      //     initialItem: initialItem,
      //   ),
      //   child: const EditItemPage(),
      // ),
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
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewItem ? 'New item' : 'Editing item',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'save',
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditItemBloc>().add(const EditItemSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _ClassificationField(),
                _ColorField(),
              ],
            ),
          ),
        ),
      ),
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
