import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

/// Builds [SharedUiTypography] with distinctive, brand-aligned font pairings.
///
/// Display: [Unbounded] — angular, kinetic, matches the logo's speed energy.
/// Body: [Spline Sans] — refined geometric sans, readable at scale.
abstract final class SharedUiTypographyFactory {
  static SharedUiTypography brand({
    Color titleColor = const Color(0xFF050505),
    Color bodyColor = const Color(0xFF0A0A0A),
    Color mutedColor = const Color(0xFF455A64),
  }) {
    final display = GoogleFonts.unbounded;
    final bodyFont = GoogleFonts.splineSans;

    return SharedUiTypography(
      display: display(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.8,
        color: titleColor,
      ),
      title: display(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.5,
        color: titleColor,
      ),
      body: bodyFont(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: bodyColor,
      ),
      label: bodyFont(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: bodyColor,
      ),
      caption: bodyFont(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: mutedColor,
      ),
      button: display(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.4,
        color: bodyColor,
      ),
    );
  }

  static SharedUiTypography brandDark() => brand(
        titleColor: const Color(0xFFF5F5F5),
        bodyColor: const Color(0xFFECECEC),
        mutedColor: const Color(0xFF9E9E9E),
      );
}
