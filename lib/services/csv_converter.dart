import 'package:csv/csv.dart';

class CsvConverter {
  static String listToCsv(List<Map<String, String>> list) {
    var rows = <List<dynamic>>[];
    rows.add(list[0].keys.toList());
    list.forEach((element) {
      rows.add(element.values.toList());
    });

    return ListToCsvConverter(fieldDelimiter: ';', eol: '\n').convert(rows);
  }
}
