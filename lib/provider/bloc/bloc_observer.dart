import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('Bloc : $bloc, Transition : $transition');
    super.onTransition(bloc, transition);
  }
}
