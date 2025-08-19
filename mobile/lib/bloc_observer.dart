import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print('\n\n\n\nBLOC\n$bloc, $change\n\n\n');
    super.onChange(bloc, change);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
  }
}
