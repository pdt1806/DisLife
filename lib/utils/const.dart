import 'dart:ui';

import 'package:flutter/material.dart';

const Color discordColor = Color(0xFF5865F2);

const List<Color> homeButtonColors = [
  Color(0xFF3A1078),
  Color(0xFF4E31AA),
  Color(0xFF2F58CD),
  Color(0xFF3795BD),
];

const Color darkColor = Color(0xFF151515);

const Color lightColor = Color(0xFFF6F6F6);

const List expirationTimeItems = [
  '15 minutes',
  '30 minutes',
  '1 hour',
  '3 hours',
  '6 hours',
  '12 hours',
  '24 hours',
];

const Map<String, int> dropdownToSeconds = {
  "15 minutes": 15 * 60,
  "30 minutes": 30 * 60,
  "1 hour": 60 * 60,
  "3 hours": 3 * 60 * 60,
  "6 hours": 6 * 60 * 60,
  "12 hours": 12 * 60 * 60,
  "24 hours": 24 * 60 * 60,
};

const List<String> themes = [
  'Light',
  'Dark',
  'System default',
];
