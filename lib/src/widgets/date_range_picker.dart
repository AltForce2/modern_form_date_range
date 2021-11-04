part of modern_form_date_range;

class DateRangePicker extends StatelessWidget {
  final String label;
  final String labelType;
  final DateRange? value;
  final void Function(DateRange) onSelected;
  final bool enabled;

  final Future<DateTimeRange?> Function(
          BuildContext context, DateTimeRange? initialDateRange)?
      customShowDateRangePicker;
  final List<DateRangeType>? customTypeValues;
  final String Function(DateRangeType)? customDateRangeTypeToElegant;
  final String Function(DateRangeType)? customDurationToElegantSingular;
  final String Function(DateRangeType)? customDurationToElegantPlural;

  const DateRangePicker({
    Key? key,
    this.label = "Intervalo de datas",
    this.labelType = "Tipo de intervalo",
    this.value,
    required this.onSelected,
    this.enabled = true,
    this.customShowDateRangePicker,
    this.customTypeValues,
    this.customDateRangeTypeToElegant,
    this.customDurationToElegantSingular,
    this.customDurationToElegantPlural,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool exists = value != null;
    DateRangeType? type = value?.type;

    return Column(
      children: [
        ModernFormTextPicker<DateRangeType>(
          label: labelType,
          forceMenu: true,
          value:
              value?.type != null ? dateRangeTypeToElegant(value!.type!) : null,
          enabled: enabled,
          list: (customTypeValues ?? DateRangeType.values)
              .map((e) => ModernFormBottomSheetModel<DateRangeType>(
                  text: dateRangeTypeToElegant(e), value: e))
              .toList(),
          onChanged: (v) {
            if (exists) {
              DateRangeType? lastType = value!.type;
              if (v != lastType) {
                onSelected(value!.copyWithRemoveValue().copyWith(type: v));
              }
            } else {
              onSelected(DateRange(type: v));
            }
          },
        ),
        if (exists)
          type.isDurationType
              ? buildDuration(context)
              : buildDateTimeRange(context),
      ],
    );
  }

  Future<DateTimeRange?> _showDateRangePicker(
      BuildContext context, DateTimeRange? initialDateRange) {
    return customShowDateRangePicker != null
        ? customShowDateRangePicker!(context, initialDateRange)
        : showDateRangePicker(
            context: context,
            initialDateRange: initialDateRange,
            firstDate: DateTime(2000, 01, 01, 00, 00),
            lastDate: DateTime.now().add(const Duration(days: 1825)),
            saveText: "Selecionar",
            helpText: "Selecionar intervalo",
            locale: const Locale('pt', "BR"),
          );
  }

  Widget buildDateTimeRange(BuildContext context) {
    DateTimeRange? dateTimeRange = value?.value;

    return ModernFormFakeTextField(
      label: label,
      initialValue: dateTimeRange?.toElegantString,
      enabled: enabled,
      sufixIconEnabled: false,
      onTap: () async {
        DateTimeRange? range =
            await _showDateRangePicker(context, dateTimeRange);
        if (range != null) {
          onSelected((value ?? DateRange()).copyWith(value: range));
        }
      },
    );
  }

  String dateRangeTypeToElegant(DateRangeType value) {
    if (customDateRangeTypeToElegant != null) {
      return customDateRangeTypeToElegant!(value);
    } else {
      return value.toElegantString;
    }
  }

  String durationToElegantSingular(DateRangeType value) {
    if (customDurationToElegantSingular != null) {
      return customDurationToElegantSingular!(value);
    } else {
      return value.toElegantSingular;
    }
  }

  String durationToElegantPlural(DateRangeType value) {
    if (customDurationToElegantPlural != null) {
      return customDurationToElegantPlural!(value);
    } else {
      return value.toElegantPlural;
    }
  }

  Widget buildDuration(BuildContext context) {
    int duration = value?.value ?? 0;
    String initialValue = "$duration ";

    if (value?.type != null) {
      if (duration == 1) {
        initialValue += durationToElegantSingular(value!.type!);
      } else {
        initialValue += durationToElegantPlural(value!.type!);
      }
    }

    return ModernFormFakeTextField(
      label: value?.type?.toElegantString,
      initialValue: initialValue,
      sufixIconEnabled: false,
      onTap: () async {
        MoneyMaskedTextController controller = MoneyMaskedTextController(
          initialValue: duration.toDouble(),
          precision: 0,
          decimalSeparator: "",
          rightSymbol: "",
        );
        MoneyMaskedTextController? response = (await showModernFormInputText(
          context,
          controller: controller,
          keyboardType: TextInputType.number,
        )) as MoneyMaskedTextController?;
        if (response != null) {
          onSelected((value ?? DateRange())
              .copyWith(value: response.numberValue.toInt()));
        }
      },
    );
  }
}
