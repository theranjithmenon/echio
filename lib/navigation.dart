import 'package:echio/views/home/dashboard/dashboard_screen.dart';
import 'package:echio/views/home/details/campaign_details_view.dart';
import 'package:echio/views/login/login_form.dart';
import 'package:flutter/material.dart';

class AppNavigation {
  static const logInFormRoute = '/LogInFormRoute';
  static const dashboardViewRoute = '/DashboardViewRoute';
  static const campaignDetailedView = '/CampaignDetailedView';

  static Map<String, Widget Function(BuildContext)> routes = {
    logInFormRoute: (context) => LoginFormView(),
    dashboardViewRoute: (context) => DashboardScreen(),
    campaignDetailedView: (context) => CampaignDetailsView(),
  };
}
