import 'package:echio/constants/keys.dart';
import 'package:echio/constants/text.dart';
import 'package:echio/db/box.dart';

import 'package:echio/enums/textfield_enum.dart';
import 'package:echio/models/user_model.dart';
import 'package:echio/navigation.dart';
import 'package:echio/views/login/bloc/login_bloc.dart';
import 'package:echio/views/login/bloc/login_event.dart';
import 'package:echio/views/login/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFormView extends StatefulWidget {
  const LoginFormView({super.key});

  @override
  State<LoginFormView> createState() => _LoginFormViewState();
}

class _LoginFormViewState extends State<LoginFormView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body(context));
  }

  _appBar() => AppBar(title: Text(KTexts.signIn));

  Widget _body(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _textField(_idController, TextFieldType.influencerId),
        _textField(_passwordController, TextFieldType.password),
        _signInButton(context),
      ],
    ),
  );

  Widget _textField(TextEditingController controller, TextFieldType type) =>
      TextFormField(
        controller: controller,
        obscureText: type == TextFieldType.password,
        decoration: InputDecoration(
          hintText:
              type == TextFieldType.influencerId
                  ? KTexts.influencerID
                  : KTexts.passsword,
        ),
      );

  _signInButton(BuildContext context) => BlocConsumer<LoginBloc, LoginState>(
    listener: (context, state) {
      if (state is LoginSuccess) {
        saveUserData(state.user);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppNavigation.dashboardViewRoute,
          (route) => false,
        );
      }
    },
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: MaterialButton(
          onPressed: () {
            context.read<LoginBloc>().add(
              LoginSubmitted(
                id: _idController.text,
                password: _passwordController.text,
              ),
            );
          },
          color: Colors.black,
          textColor: Colors.white,
          elevation: 0,
          minWidth: double.infinity,
          height: 55,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child:
              state is LoginLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text(KTexts.signIn),
        ),
      );
    },
  );

  void saveUserData(User user) async {
    userBox.put(KKeys.loggedInUser, user);
  }
}
