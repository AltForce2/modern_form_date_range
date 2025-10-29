part of '../../modern_form_date_range.dart';

enum DateRangeType {
  dateTimeRange,
  days,
  weeks,
  months,
}

extension DateRangeTypeExtension on DateRangeType? {
  bool get isDurationType {
    switch (this) {
      case DateRangeType.days:
        return true;
      case DateRangeType.weeks:
        return true;
      case DateRangeType.months:
        return true;
      default:
        return false;
    }
  }

  bool get isDateTimeRangeType {
    switch (this) {
      case DateRangeType.dateTimeRange:
        return true;
      default:
        return false;
    }
  }

  String get toElegantString {
    switch (this) {
      case DateRangeType.dateTimeRange:
        return "Intervalo de datas";
      case DateRangeType.days:
        return "Dias";
      case DateRangeType.weeks:
        return "Semanas";
      case DateRangeType.months:
        return "Meses";
      default:
        return "";
    }
  }

  String get toValueString {
    switch (this) {
      case DateRangeType.dateTimeRange:
        return "dateTimeRange";
      case DateRangeType.days:
        return "days";
      case DateRangeType.weeks:
        return "weeks";
      case DateRangeType.months:
        return "months";
      default:
        return "";
    }
  }

  String get toElegantSingular {
    switch (this) {
      case DateRangeType.days:
        return "dia";
      case DateRangeType.weeks:
        return "semana";
      case DateRangeType.months:
        return "mês";
      default:
        return "";
    }
  }

  String get toElegantPlural {
    switch (this) {
      case DateRangeType.days:
        return "dias";
      case DateRangeType.weeks:
        return "semanas";
      case DateRangeType.months:
        return "meses";
      default:
        return "";
    }
  }
}

extension StringToDateRangeType on String {
  DateRangeType get toDateRangeType {
    switch (this) {
      case "dateTimeRange":
        return DateRangeType.dateTimeRange;
      case "days":
        return DateRangeType.days;
      case "weeks":
        return DateRangeType.weeks;
      case "months":
        return DateRangeType.months;
      default:
        return DateRangeType.dateTimeRange;
    }
  }
}
