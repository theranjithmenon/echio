import 'package:echio/constants/text.dart';
import 'package:echio/models/campaign_details_args.dart';
import 'package:echio/models/campaign_model.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_bloc.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CampaignDetailsView extends StatelessWidget {
  const CampaignDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CampaignDetailsArgs;
    final campaign = args.campaign;
    final influencerId = args.influencerId;

    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(child: _body(campaign, influencerId, context)),
    );
  }

  _appBar() => AppBar();

  Widget _body(Campaign campaign, String influencerId, BuildContext context) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(campaign.title ?? '-', style: TextStyle(fontSize: 25)),
              Text(campaign.description ?? '-'),
              Text(
                campaign.isManuallyCompleted
                    ? "Completed"
                    : _calculateTimeToEnd(campaign.endDate),
              ),
              Spacer(),
              Visibility(
                visible:
                    !(campaign.isManuallyCompleted ||
                        (campaign.endDate != null &&
                            DateTime.now().isAfter(campaign.endDate!))),

                child: MaterialButton(
                  onPressed: () {
                    context.read<CampaignBloc>().add(
                      MarkCampaignAsCompleted(
                        campaignId: campaign.id ?? -1,
                        influencerId: influencerId,
                      ),
                    );

                    Navigator.pop(context);
                  },

                  color: Colors.black,
                  textColor: Colors.white,
                  elevation: 0,
                  minWidth: double.infinity,
                  height: 55,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(KTexts.markAdCompleted),
                ),
              ),
            ],
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
