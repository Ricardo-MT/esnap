import 'package:flutter/material.dart';

class SetsOverviewPage extends StatelessWidget {
  const SetsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SetsOverviewView();
  }
}

class _SetsOverviewView extends StatelessWidget {
  const _SetsOverviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All sets'),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addOutfit_floatingActionButton'),
        onPressed: () {},
        // onPressed: () => Navigator.of(context).push(EditItemPage.route()),
        child: const Icon(Icons.add),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Sets Overview'),
        ),
      ),
    );
  }
}
