import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/colors_overview/bloc/colors_overview_bloc.dart';
import 'package:esnap/app_views/detail_item/detail_item.dart';
import 'package:esnap/app_views/edit_item/view/edit_item_page.dart';
import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap/app_views/items_overview/models/classification_filter.dart';
import 'package:esnap/app_views/items_overview/widgets/item_list_tile.dart';
import 'package:esnap/app_views/items_overview/widgets/items_overview_filter_button.dart';
import 'package:esnap/app_views/items_overview/widgets/items_overview_filter_chips.dart';
import 'package:esnap/app_views/occasions_overview/bloc/occasions_overview_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class ItemsOverviewPage extends StatelessWidget {
  const ItemsOverviewPage({required this.childKey, super.key});
  final GlobalKey childKey;

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
      child: ItemsOverviewView(
        key: childKey,
      ),
    );
  }
}

class ItemsOverviewView extends StatefulWidget {
  const ItemsOverviewView({super.key});

  @override
  State<ItemsOverviewView> createState() => ItemsOverviewViewState();
}

class ItemsOverviewViewState extends State<ItemsOverviewView> {
  void quickFilterClassification(EsnapClassification classification) {
    context.read<ItemsOverviewBloc>().add(
          ItemsOverviewQuickFilterChanged(
            ClassificationFilterItem(classification),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.itemsPageTitle),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30 + spacerS.height!),
          child: const ItemsOverviewFilterChips(),
        ),
        actions: const [
          ItemsOverviewFilterButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addItem',
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
                      content: Text('error'),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<ItemsOverviewBloc, ItemsOverviewState>(
          builder: (context, state) {
            if (state.status == ItemsOverviewStatus.failure) {
              return const Center(child: Text('error'));
            }
            if (state.status == ItemsOverviewStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: state.filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noItemsFound,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 3,
                          padding:
                              const EdgeInsets.all(15).copyWith(bottom: 80),
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
