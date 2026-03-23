import 'package:flutter/material.dart';

class DocumentSettings {
  final String maxSize;
  final String maxWidth;
  final String imageFormat;
  final String promptUser;
  final String systemMessage;
  final String n8nUrlService;
  final String urlWebhookReturn;

  DocumentSettings({
    required this.maxSize,
    required this.maxWidth,
    required this.imageFormat,
    required this.promptUser,
    required this.systemMessage,
    required this.n8nUrlService,
    required this.urlWebhookReturn,
  });

  factory DocumentSettings.fromJson(Map<String, dynamic> json) {
    return DocumentSettings(
      maxSize: json['maxSize']?.toString() ?? '',
      maxWidth: json['maxWidth']?.toString() ?? '',
      imageFormat: json['imageFormat'] ?? '',
      promptUser: json['promptUser'] ?? '',
      systemMessage: json['systemMessage'] ?? '',
      n8nUrlService: json['n8nUrlService'] ?? '',
      urlWebhookReturn: json['urlWebhookReturn'] ?? '',
    );
  }
}

class DocumentType {
  final String id;
  final String title;
  final String description;
  final IconData icon; // In a real scenario, this might be a string for an asset path or a web URL
  final DocumentSettings settings;

  DocumentType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.settings,
  });
}
