import 'package:echio/constants/keys.dart';
import 'package:echio/db/box.dart';
import 'package:echio/models/user_model.dart';

import 'package:echio/navigation.dart';
import 'package:echio/repository/campaign_repository.dart';
import 'package:echio/repository/user_repository.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_bloc.dart';
import 'package:echio/views/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>(KKeys.user);
  final savedUser = userBox.get(KKeys.loggedInUser);
  runApp(MyApp(isLoggedIn: savedUser != null));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc(UserRepository())),
        BlocProvider<CampaignBloc>(
          create: (_) => CampaignBloc(CampaignRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Echio Test',
        theme: ThemeData(),
        routes: AppNavigation.routes,
        initialRoute:
            isLoggedIn
                ? AppNavigation.dashboardViewRoute
                : AppNavigation.logInFormRoute,
      ),
    );
  }
}
