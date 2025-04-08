import 'package:echio/constants/text.dart';
import 'package:echio/models/campaign_details_args.dart';
import 'package:echio/models/campaign_model.dart';
import 'package:echio/navigation.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_bloc.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_event.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatefulWidget {
  final String influencerId;
  const DashboardView({super.key, required this.influencerId});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final List<Tab> tabs = [
    Tab(text: KTexts.onGoing),
    Tab(text: KTexts.completed),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CampaignBloc>().add(FetchCampaigns(widget.influencerId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _tabController(context);
  }

  Widget _tabController(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(appBar: _appBar(), body: _body(context)),
  );

  _appBar() => AppBar(bottom: TabBar(tabs: tabs));

  Widget _body(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: TabBarView(children: [_onGoingCampaigns(), _completedCampaigns()]),
  );

  Widget _onGoingCampaigns() => BlocBuilder<CampaignBloc, CampaignState>(
    builder: (context, state) {
      if (state is CampaignLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is CampaignLoaded) {
        if (state.ongoing.isEmpty) {
          return Center(child: Text("No ongoing campaigns"));
        }
        return ListView.builder(
          itemCount: state.ongoing.length,
          itemBuilder: (context, index) {
            final campaign = state.ongoing[index];
            return _campaignTile(campaign);
          },
        );
      } else if (state is CampaignError) {
        return Center(child: Text(state.message));
      }
      return SizedBox.shrink();
    },
  );

  Widget _completedCampaigns() => BlocBuilder<CampaignBloc, CampaignState>(
    builder: (context, state) {
      if (state is CampaignLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is CampaignLoaded) {
        if (state.completed.isEmpty) {
          return Center(child: Text("No completed campaigns"));
        }
        return ListView.builder(
          itemCount: state.completed.length,
          itemBuilder: (context, index) {
            final campaign = state.completed[index];
            return _campaignTile(campaign);
          },
        );
      } else if (state is CampaignError) {
        return Center(child: Text(state.message));
      }
      return SizedBox.shrink();
    },
  );

  Widget _campaignTile(Campaign campaign) => ListTile(
    onTap: () {
      Navigator.pushNamed(
        context,
        AppNavigation.campaignDetailedView,
        arguments: CampaignDetailsArgs(
          campaign: campaign,
          influencerId: widget.influencerId,
        ),
      );
    },
    title: Text(campaign.title ?? ''),
    subtitle: Text(campaign.description ?? ''),
    trailing: Container(
      decoration: BoxDecoration(
        color: Colors.yellowAccent.shade400,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(5),
      child: Text(
        campaign.isManuallyCompleted
            ? "Completed"
            : _calculateTimeToEnd(campaign.endDate),
      ),
    ),
  );

  String _calculateTimeToEnd(DateTime? endDate) {
    if (endDate == null) return '';

    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      return 'Ended';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day(s) left';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour(s) left';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute(s) left';
    } else {
      return 'Less than a minute left';
    }
  }
}
