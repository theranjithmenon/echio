import 'package:echio/constants/keys.dart';
import 'package:echio/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

final userBox = Hive.box<User>(KKeys.user);
