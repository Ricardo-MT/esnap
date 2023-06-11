import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap/app_views/items_overview/widgets/item_list_tile.dart';
import 'package:esnap/app_views/items_overview/widgets/items_overview_filter_button.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsOverviewPage extends StatelessWidget {
  const ItemsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemsOverviewBloc(
        esnapRepository: context.read<EsnapRepository>(),
      )..add(const ItemsOverviewSubscriptionRequested()),
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
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final todo in state.filteredItems)
                    ItemListTile(
                      item: todo,
                      onTap: () {
                        // Navigator.of(context).push(
                        //   EditTodoPage.route(initialTodo: todo),
                        // );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
