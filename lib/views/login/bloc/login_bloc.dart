import 'package:echio/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc(this.userRepository) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final user = await userRepository.login(event.id, event.password);
    if (user != null) {
      emit(LoginSuccess(user));
    } else {
      emit(LoginFailure("Invalid ID or Password"));
    }
  }
}
