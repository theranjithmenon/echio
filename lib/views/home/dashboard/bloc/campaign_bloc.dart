import 'dart:developer';

import 'package:echio/models/campaign_model.dart';
import 'package:echio/repository/campaign_repository.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_event.dart';
import 'package:echio/views/home/dashboard/bloc/campaign_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final CampaignRepository campaignRepository;

  CampaignBloc(this.campaignRepository) : super(CampaignInitial()) {
    on<FetchCampaigns>(_onFetchCampaigns);
    on<MarkCampaignAsCompleted>(_onMarkCampaignAsCompleted);
  }

  Future<void> _onMarkCampaignAsCompleted(
    MarkCampaignAsCompleted event,
    Emitter<CampaignState> emit,
  ) async {
    try {
      await campaignRepository.markCampaignAsCompleted(event.campaignId);
      add(FetchCampaigns(event.influencerId));
    } catch (e) {
      log(e.toString());
      emit(CampaignError('Failed to mark campaign as completed'));
    }
  }

  Future<void> _onFetchCampaigns(
    FetchCampaigns event,
    Emitter<CampaignState> emit,
  ) async {
    emit(CampaignLoading());

    try {
      final campaigns = await campaignRepository.getAllCampaigns(
        event.influencerId,
      );
      final filtered = campaigns.whereType<Campaign>().where(
        (c) => c.assignedTo?.contains(event.influencerId) ?? false,
      );

      final now = DateTime.now();

      final ongoing =
          filtered
              .where(
                (c) =>
                    c.startDate!.isBefore(now) &&
                    c.endDate!.isAfter(now) &&
                    !c.isManuallyCompleted,
              )
              .toList();

      final completed =
          filtered
              .where((c) => c.isManuallyCompleted || c.endDate!.isBefore(now))
              .toList();

      emit(CampaignLoaded(ongoing: ongoing, completed: completed));
    } catch (e) {
      log(e.toString());
      emit(CampaignError('Failed to load campaigns'));
    }
  }
}
