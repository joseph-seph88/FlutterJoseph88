import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = LoggerUtil();

class LoggerUtil {
  static final LoggerUtil _instance = LoggerUtil._();
  late final Logger _logger;
  factory LoggerUtil() => _instance;

  LoggerUtil._() {
    _logger = Logger(
      level: Level.all,
      filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
      output: ConsoleOutput(),
      printer: PrettyPrinter(
        stackTraceBeginIndex: 1,
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    );
  }

  void t(dynamic message) => _logger.t(message); // 0
  void d(dynamic message) => _logger.d(message); // 1
  void i(dynamic message) => _logger.i(message); // 2
  void w(dynamic message) => _logger.w(message); // 3
  void e(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace); // 4
  void f(dynamic message) => _logger.f(message); // 5
}
