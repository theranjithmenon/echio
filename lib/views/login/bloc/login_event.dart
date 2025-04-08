abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String id;
  final String password;

  LoginSubmitted({required this.id, required this.password});
}
