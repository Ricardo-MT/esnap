import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/colors_overview/bloc/colors_overview_bloc.dart';
import 'package:esnap/app_views/detail_item/detail_todo.dart';
import 'package:esnap/app_views/edit_item/view/edit_item_page.dart';
import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap/app_views/items_overview/widgets/item_list_tile.dart';
import 'package:esnap/app_views/items_overview/widgets/items_overview_filter_button.dart';
import 'package:esnap/app_views/occasions_overview/bloc/occasions_overview_bloc.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class ItemsOverviewPage extends StatelessWidget {
  const ItemsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ItemsOverviewBloc(
            esnapRepository: context.read<EsnapRepository>(),
          )..add(const ItemsOverviewSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => ColorsOverviewBloc(
            colorRepository: context.read<ColorRepository>(),
          )..add(const ColorsOverviewSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => ClassificationsOverviewBloc(
            classificationRepository: context.read<ClassificationRepository>(),
          )..add(const ClassificationsOverviewSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => OccasionsOverviewBloc(
            occasionRepository: context.read<OccasionRepository>(),
          )..add(const OccasionsOverviewSubscriptionRequested()),
        ),
      ],
      child: const ItemsOverviewView(),
    );
  }
}

class ItemsOverviewView extends StatelessWidget {
  const ItemsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All items'),
        actions: const [
          ItemsOverviewFilterButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditItemPage.route()),
        child: const Icon(Icons.add),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ItemsOverviewBloc, ItemsOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ItemsOverviewStatus.failure) {
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
        ],
        child: BlocBuilder<ItemsOverviewBloc, ItemsOverviewState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              if (state.status == ItemsOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != ItemsOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    'No items',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
            }
            return Column(
              children: [
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: spacerS.width!),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) => InputChip(
                      label: Text(state.filters[index].getText()),
                      onDeleted: () => context.read<ItemsOverviewBloc>().add(
                            ItemsOverviewFilterChanged(state.filters[index]),
                          ),
                    ),
                    separatorBuilder: (_, __) => spacerS,
                    itemCount: state.filters.length,
                  ),
                ),
                Expanded(
                  child: state.filteredItems.isEmpty
                      ? const Center(child: Text('no matches'))
                      : GridView.count(
                          crossAxisCount: 3,
                          padding: const EdgeInsets.all(15),
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          children: [
                            for (final item in state.filteredItems)
                              ItemListTile(
                                item: item,
                                onTap: () {
                                  Navigator.of(context).push(
                                    DetailItemPage.route(item: item),
                                  );
                                },
                              ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
