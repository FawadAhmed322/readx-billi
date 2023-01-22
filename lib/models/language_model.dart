import 'package:flutter/material.dart';

class Language {
  String name;
  String code;
  bool isRecent;
  bool isDownloaded;
  bool isDownloadable;

  Language(this.code, this.name, this.isRecent, this.isDownloaded,
      this.isDownloadable);
}