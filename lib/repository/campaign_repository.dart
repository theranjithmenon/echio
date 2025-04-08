import 'dart:convert';

import 'package:echio/models/campaign_model.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CampaignRepository {
  List<Campaign> _campaigns = [];

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/campaigns.json');
  }

  Future<void> _initLocalJsonIfNeeded() async {
    final file = await _getLocalFile();
    if (!(await file.exists())) {
      final String response = await rootBundle.loadString(
        'lib/data/campaigns.json',
      );
      await file.writeAsString(response);
    }
  }

  Future<List<Campaign>> getAllCampaigns(String id) async {
    await _initLocalJsonIfNeeded();

    final file = await _getLocalFile();
    final String contents = await file.readAsString();
    final List<dynamic> data = json.decode(contents);
    _campaigns = data.map((u) => Campaign.fromJson(u)).toList();
    return _campaigns;
  }

  Future<void> markCampaignAsCompleted(int campaignId) async {
    final index = _campaigns.indexWhere((c) => c.id == campaignId);
    if (index != -1) {
      _campaigns[index].isManuallyCompleted = true;
      await _saveCampaignsToLocalFile();
    }
  }

  Future<void> _saveCampaignsToLocalFile() async {
    final file = await _getLocalFile();
    final String jsonData = jsonEncode(
      _campaigns.map((c) => c.toJson()).toList(),
    );
    await file.writeAsString(jsonData);
  }
}
