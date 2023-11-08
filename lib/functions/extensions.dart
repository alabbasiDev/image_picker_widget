import 'dart:convert';
import 'package:flutter/material.dart';
extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this == '';

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  bool get isBase64 {
    if (isNullOrEmpty) {
      return false;
    }
    try {
      base64.decode(this!);
      return true;
    } on FormatException {
      return false;
    }
  }
}