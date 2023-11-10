import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/edit_item/edit_todo.dart';
import 'package:esnap/app_views/edit_outfit/view/edit_outfit.dart';
import 'package:esnap/app_views/home/cubit/home_cubit.dart';
import 'package:esnap/app_views/items_overview/view/items_overview.dart';
import 'package:esnap/app_views/preferences/view/view.dart';
import 'package:esnap/app_views/set_overview/view/sets_overview.dart';
import 'package:esnap/utils/classification_asset_pairer.dart';
import 'package:esnap/utils/text_button_helpers.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.index = 0});
  final int index;

  @override
  Widget build(BuildContext context) {
    final classificationRepository = context.read<ClassificationRepository>();
    final shuffledClassifications =
        classificationRepository.getStaticClassifications()..shuffle();
    final topFive = shuffledClassifications.take(5).toList();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(index),
        ),
        BlocProvider(
          create: (context) => ClassificationsOverviewBloc(
            classificationRepository: classificationRepository,
          )..add(
              const ClassificationsOverviewSubscriptionRequested(),
            ),
        ),
      ],
      child: _HomeView(
        topFiveClassifications: topFive.take(5).toList(),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  _HomeView({required this.topFiveClassifications});
  final GlobalKey<ItemsOverviewViewState> globalKey = GlobalKey();
  final List<EsnapClassification> topFiveClassifications;

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state);
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedTab.index,
          children: [
            _HomeViewWidget(
              topFiveClassifications: topFiveClassifications,
              callback: (EsnapClassification classification) {
                globalKey.currentState!
                    .quickFilterClassification(classification);
                context.read<HomeCubit>().selectItems();
              },
            ),
            ItemsOverviewPage(
              childKey: globalKey,
            ),
            const SetsOverviewPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.home,
                icon: Icons.home_outlined,
                label: 'Home',
                onPressed: context.read<HomeCubit>().selectHome,
              ),
            ),
            Expanded(
              child: _HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.items,
                icon: Icons.dry_cleaning_outlined,
                label: 'All items',
                onPressed: context.read<HomeCubit>().selectItems,
              ),
            ),
            Expanded(
              child: _HomeTabButton(
                groupValue: selectedTab,
                value: HomeTab.outifts,
                icon: Icons.dashboard,
                label: 'Outfits',
                onPressed: context.read<HomeCubit>().selectSets,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeViewWidget extends StatelessWidget {
  const _HomeViewWidget({
    required this.callback,
    required this.topFiveClassifications,
  });
  final void Function(EsnapClassification classification) callback;
  final List<EsnapClassification> topFiveClassifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esnap'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).push(PreferencesPage.route()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: WidAppDimensions.pageInsetGap / 2,
        ),
        child: Column(
          children: [
            _HomeQuickFilter(
              callback: () => Navigator.of(context).push(EditItemPage.route()),
              label: 'Add clothing item',
              iconPlus: true,
            ),
            _HomeQuickFilter(
              callback: () =>
                  Navigator.of(context).push(EditOutfitPage.route()),
              label: 'Add outfit',
              iconPlus: true,
            ),
            spacerM,
            ...List.generate(
              topFiveClassifications.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: _HomeQuickFilter(
                  callback: () => callback(topFiveClassifications[index]),
                  label: topFiveClassifications[index].name,
                  imagePath: getAssetByClassification(
                    topFiveClassifications[index].name,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final IconData icon;
  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final color = groupValue != value
        ? Theme.of(context).textTheme.bodyLarge?.color!.withOpacity(0.4)
        : Theme.of(context).textTheme.bodyLarge?.color;
    return TextButton(
      onPressed: onPressed,
      style: removeSplashEffect(context),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            WidText.bodyMedium(
              text: label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeQuickFilter extends StatelessWidget {
  const _HomeQuickFilter({
    required this.callback,
    required this.label,
    this.imagePath,
    this.iconPlus = false,
  });
  final void Function() callback;
  final String label;
  final String? imagePath;
  final bool iconPlus;

  @override
  Widget build(BuildContext context) {
    final mainColor = imagePath == null
        ? Theme.of(context).textTheme.bodyLarge?.color
        : WidAppColors.white;
    return DecoratedBox(
      decoration: BoxDecoration(
        image: imagePath == null
            ? null
            : DecorationImage(
                image: AssetImage(imagePath!),
                colorFilter: ColorFilter.mode(
                  WidAppColors.primary.withOpacity(0.9),
                  BlendMode.colorBurn,
                ),
              ),
      ),
      child: TextButton(
        onPressed: callback,
        style: (imagePath == null
                ? const ButtonStyle()
                : removeSplashEffect(context))
            .copyWith(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(1),
          ),
        ),
        child: AspectRatio(
          aspectRatio: 250 / 39,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                WidText.headlineLarge(
                  text: label,
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                spacerExpanded,
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    iconPlus ? Icons.add_circle : Icons.arrow_forward_ios,
                    size: 18,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
