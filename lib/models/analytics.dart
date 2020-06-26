class DayOrderAnalytic {
  String id;
  String name;
  List<DayOrderSummary> dayOrderSummary = [];

  DayOrderAnalytic({this.id, this.name, this.dayOrderSummary});

  factory DayOrderAnalytic.fromMap(String documentId, Map data) {
    return DayOrderAnalytic(
      id: documentId,
      name: data['name'],
      dayOrderSummary: (data['dayOrderSummary'] as List<dynamic>)
          .map((item) => DayOrderSummary.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dayOrderSummary": dayOrderSummary.map((dos) => dos.toJson()).toList(),
      };
}

class DayOrderSummary {
  DateTime orderDate;
  int orderCount;
  double total;

  DayOrderSummary({this.orderDate, this.orderCount, this.total});

  factory DayOrderSummary.fromMap(Map data) {
    return DayOrderSummary(
      orderDate: data['orderDate'] != null ? data['orderDate'].toDate() : null,
      orderCount: data["orderCount"],
      total: data["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "orderDate": orderDate,
        "orderCount": orderCount,
        "total": total,
      };
}
