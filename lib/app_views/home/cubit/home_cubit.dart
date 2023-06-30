import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeTab { home, items }

class HomeCubit extends Cubit<HomeTab> {
  HomeCubit() : super(HomeTab.home);

  void selectHome() => emit(HomeTab.home);
  void selectItems() => emit(HomeTab.items);
}
