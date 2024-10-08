import 'package:esnap/app_views/detail_outfit/detail_outfit.dart';
import 'package:esnap/app_views/edit_outfit/view/edit_outfit.dart';
import 'package:esnap/app_views/set_overview/bloc/sets_overview_bloc.dart';
import 'package:esnap/app_views/set_overview/widgets/set_list_tile.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class SetsOverviewPage extends StatelessWidget {
  const SetsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SetsOverviewBloc(outfitRepository: context.read<OutfitRepository>())
            ..add(const SetsOverviewSubscriptionRequested()),
      child: const _SetsOverviewView(),
    );
  }
}

class _SetsOverviewView extends StatelessWidget {
  const _SetsOverviewView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenDimensions = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.outfitsPageTitle),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addSet',
        onPressed: () => Navigator.of(context).push(EditOutfitPage.route()),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<SetsOverviewBloc, SetsOverviewState>(
          builder: (context, state) {
            if (state.status == SetsOverviewStatus.failure) {
              return const Center(child: Text('error'));
            }
            if (state.status == SetsOverviewStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30 + spacerS.height!),
                  child: Text(
                    l10n.noOutfitsFound,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 10.0;
                final childAspectRatio =
                    screenDimensions.width / screenDimensions.height;
                final width = (screenDimensions.width - spacing * 4) / 3;
                final height = width / childAspectRatio;
                return GridView.count(
                  childAspectRatio: childAspectRatio,
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(spacing).copyWith(bottom: 80),
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  children: [
                    for (final item in state.items)
                      SetListTile(
                        tileHeight: height,
                        item: item,
                        onTap: () {
                          Navigator.of(context).push(
                            DetailOutfitPage.route(item: item),
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
