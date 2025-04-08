import 'package:echio/models/campaign_model.dart';

abstract class CampaignState {}

class CampaignInitial extends CampaignState {}

class CampaignLoading extends CampaignState {}

class CampaignLoaded extends CampaignState {
  final List<Campaign> ongoing;
  final List<Campaign> completed;

  CampaignLoaded({required this.ongoing, required this.completed});
}

class CampaignError extends CampaignState {
  final String message;
  CampaignError(this.message);
}
