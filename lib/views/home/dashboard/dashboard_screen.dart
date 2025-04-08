import 'package:echio/constants/keys.dart';
import 'package:echio/db/box.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_bloc.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_event.dart';
import 'package:echio/views/home/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final savedUser = userBox.get(KKeys.loggedInUser);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CampaignBloc>().add(FetchCampaigns(savedUser?.id ?? ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardView(influencerId: savedUser?.id ?? '');
  }
}
