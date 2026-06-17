class DayOrderAnalytic {
  List<DayOrderSummary> dayOrderSummary = [];

  DayOrderAnalytic({List<DayOrderSummary>? dayOrderSummary})
      : dayOrderSummary = dayOrderSummary ?? [];

  factory DayOrderAnalytic.fromMap(Map data) {
    return DayOrderAnalytic(
      dayOrderSummary: ((data['dayOrderSummary'] as List<dynamic>?) ?? [])
          .map((item) => DayOrderSummary.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "dayOrderSummary": dayOrderSummary.map((dos) => dos.toJson()).toList(),
      };
}

class DayOrderSummary {
  DateTime orderDate;
  int orderCount;
  double total;

  DayOrderSummary({
    DateTime? orderDate,
    this.orderCount = 0,
    this.total = 0,
  }) : orderDate = orderDate ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory DayOrderSummary.fromMap(Map data) {
    return DayOrderSummary(
      orderDate: _asDateTime(data['orderDate'] ?? data['date']),
      orderCount: (data["orderCount"] as num?)?.toInt() ?? 0,
      total: (data["total"] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "orderDate": orderDate,
        "orderCount": orderCount,
        "total": total,
      };
}

DateTime? _asDateTime(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }
  if (value is String) {
    return DateTime.tryParse(value);
  }
  try {
    return value.toDate();
  } catch (_) {
    return null;
  }
}
