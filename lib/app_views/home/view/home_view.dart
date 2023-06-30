import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/home/cubit/home_cubit.dart';
import 'package:esnap/app_views/items_overview/view/items_overview.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => ClassificationsOverviewBloc(
            classificationRepository: context.read<ClassificationRepository>(),
          )..add(
              const ClassificationsOverviewSubscriptionRequested(),
            ),
        ),
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final GlobalKey<ItemsOverviewViewState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state);
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedTab.index,
          children: [
            _HomeViewWidget(
              callback: (EsnapClassification classification) {
                globalKey.currentState!
                    .quickFilterClassification(classification);
                context.read<HomeCubit>().selectItems();
              },
            ),
            ItemsOverviewPage(
              childKey: globalKey,
            ),
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
          ],
        ),
      ),
    );
  }
}

class _HomeViewWidget extends StatelessWidget {
  const _HomeViewWidget({required this.callback});
  final void Function(EsnapClassification classification) callback;

  @override
  Widget build(BuildContext context) {
    final classifications = context
        .watch<ClassificationsOverviewBloc>()
        .state
        .classifications
        .take(5)
        .toList();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: WidAppDimensions.pageInsetGap / 2,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: WidAppDimensions.pageInsetGap),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: WidText.headlineLarge(text: 'Outfits'),
            ),
          ),
          const Text('(no outfits)'),
          const Align(
            alignment: Alignment.centerRight,
            child: WidText.headlineLarge(text: 'Clothing items'),
          ),
          spacerM,
          ...List.generate(
            classifications.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _HomeQuickFilter(
                callback: () => callback(classifications[index]),
                label: classifications[index].name,
                imagePath: _imagePaths[index],
              ),
            ),
          )
        ],
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
    return WidTouchable(
      onPress: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6),
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
    required this.imagePath,
  });
  final void Function() callback;
  final String label;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath)),
      ),
      child: WidTouchable(
        onPress: callback,
        child: AspectRatio(
          aspectRatio: 250 / 39,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: WidText.headlineMedium(
                    text: label,
                    style: const TextStyle(color: WidAppColors.black),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: WidAppColors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _imagePaths = [
  'assets/img/1_blouse.png',
  'assets/img/2_shirt.png',
  'assets/img/3_tshirt.png',
  'assets/img/4_bag.png',
  'assets/img/5_skirt.png'
];
