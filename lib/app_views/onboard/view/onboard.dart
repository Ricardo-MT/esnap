import 'dart:math';

import 'package:esnap/app_views/onboard/model/onboarding_section.dart';
import 'package:esnap/app_views/preferences/bloc/preferences_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wid_design_system/wid_design_system.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  static PageRoute<OnboardPage> route() {
    return PageTransition(
      child: const OnboardPage(),
      childCurrent: const SpinnerPage(),
      type: PageTransitionType.rightToLeftJoined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const OnboardView();
  }
}

class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardView();
}

class _OnboardView extends State<OnboardView> with TickerProviderStateMixin {
  late PageController _pageController;
  late bool _isLastPage;
  late bool _isFirstPage;
  late List<OnboardSection> sections;

  @override
  void initState() {
    _pageController = PageController();
    _isLastPage = false;
    _isFirstPage = true;
    sections = [];
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      final newIsFirstPage = page == 0;
      final newIsLastPage = page == sections.length - 1;
      if (newIsFirstPage != _isFirstPage || newIsLastPage != _isLastPage) {
        setState(() {
          _isFirstPage = newIsFirstPage;
          _isLastPage = newIsLastPage;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      sections = getSections(context);
    });
    super.didChangeDependencies();
  }

  void handleFinishOnboard(BuildContext context) {
    context.read<PreferencesBloc>().add(const PreferencesFinishOnboarding());
  }

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const skipColor = Colors.black;
    const foregroundColor = Colors.white;
    final colors = sections.map((e) => e.color).toList();
    return Scaffold(
      body: Stack(
        children: [
          /// Dummy page view to allow for page transitions
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: sections.map((e) => const SizedBox.expand()).toList(),
            ),
          ),

          /// Background images
          ...List.generate(sections.length, (index) {
            final i = sections.length - index - 1;
            final image = sections[i].image;
            return Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    final page = _pageController.page ?? 0;
                    final deltaPage = (page - i).abs();
                    final value = 1 - deltaPage;
                    return Opacity(
                      opacity: value.clamp(0, 1),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            );
          }),

          /// Foreground color gradient
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  final page = _pageController.page ?? 0;
                  final min = page.floor();
                  final max = page.ceil();
                  final minColor = colors[min];
                  final maxColor = colors[max];
                  final color = Color.lerp(minColor, maxColor, page - min) ??
                      Theme.of(context).scaffoldBackgroundColor;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0),
                          color.withOpacity(1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        stops: const [
                          0.5,
                          1,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// Skip button
          Positioned(
            right: 0,
            top: 0,
            child: SafeArea(
              child: TextButton(
                onPressed: () => handleFinishOnboard(context),
                child: Text(
                  l10n.skip,
                  style: const TextStyle(color: skipColor),
                ),
              ),
            ),
          ),

          /// Text description, page indicator and navigation buttons
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      final page = _pageController.page ?? 0;
                      final index = page.round();
                      final section = sections[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14)
                            .copyWith(right: 60),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 170),
                          child: Column(
                            key: ValueKey(index),
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                section.title1,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: foregroundColor,
                                      fontSize: 26,
                                    ),
                              ),
                              Text(
                                section.title2,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: foregroundColor,
                                      fontSize: 26,
                                    ),
                              ),
                              spacerM,
                              Text(
                                section.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: foregroundColor,
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                spacerXs,
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: TextButton(
                          key: ValueKey(_isFirstPage),
                          style: TextButton.styleFrom(
                            fixedSize: const Size.fromWidth(80),
                          ),
                          onPressed: _isFirstPage ? null : previousPage,
                          child: Text(
                            _isFirstPage ? '' : l10n.back,
                            style: const TextStyle(
                              color: foregroundColor,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          sections.length,
                          (index) => AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              final page = _pageController.page ?? 0;
                              final deltaPage = (page - index).abs();
                              final value = 1 - deltaPage;
                              return Opacity(
                                opacity: value.clamp(0.5, 1),
                                child: Transform.scale(
                                  scale: value.clamp(0.6, 1),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: foregroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: TextButton(
                          key: ValueKey(_isLastPage),
                          style: TextButton.styleFrom(
                            fixedSize: const Size.fromWidth(80),
                          ),
                          onPressed: _isLastPage
                              ? () => handleFinishOnboard(context)
                              : nextPage,
                          child: Text(
                            _isLastPage ? l10n.done : l10n.next,
                            style: const TextStyle(color: foregroundColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

double getY(double x) {
  return 8.5 * pow(x, 2) - 14.5 * x + 14.8;
}

List<OnboardSection> getSections(BuildContext context) {
  final l10n = context.l10n;
  return [
    OnboardSection(
      title1: l10n.onboardOneTitle1,
      title2: l10n.onboardOneTitle2,
      description: l10n.onboardOneDescription,
      image: 'assets/img/section_1.webp',
      color: const Color(0xFFBC44E7),
    ),
    OnboardSection(
      title1: l10n.onboardTwoTitle1,
      title2: l10n.onboardTwoTitle2,
      description: l10n.onboardTwoDescription,
      image: 'assets/img/section_2.webp',
      color: const Color(0xFF01f472),
    ),
    OnboardSection(
      title1: l10n.onboardThreeTitle1,
      title2: l10n.onboardThreeTitle2,
      description: l10n.onboardThreeDescription,
      image: 'assets/img/section_3.webp',
      color: const Color(0xFFFF82B8),
    ),
  ];
}
