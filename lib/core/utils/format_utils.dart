import 'package:intl/intl.dart';

extension PriceFormatter on int {
  static final _numberFormat = NumberFormat('#,###');

  String toPrice() {
    return '${_numberFormat.format(this)}원';
  }
}
