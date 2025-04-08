abstract class CampaignEvent {}

class FetchCampaigns extends CampaignEvent {
  final String influencerId;
  FetchCampaigns(this.influencerId);
}

class MarkCampaignAsCompleted extends CampaignEvent {
  final int campaignId;
  final String influencerId;

  MarkCampaignAsCompleted({
    required this.campaignId,
    required this.influencerId,
  });
}
