import 'package:intl/intl.dart';

String formattedDate(DateTime dt) {
  return DateFormat('dd/MM/yyyy').format(dt);
}
