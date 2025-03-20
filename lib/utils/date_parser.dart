
class DateParser {

  /// Parse an UTC date [isoDate] (Without ending 'Z') to a locale DateTime
  static DateTime parseUTCDate(String isoDate)
    => DateTime.parse(isoDate).copyWith(isUtc: true).toLocal();
}