import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('Bloc : $bloc, Transition : $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('Bloc : $bloc, StackTrace : $stackTrace');

    super.onError(bloc, error, stackTrace);
  }
}
