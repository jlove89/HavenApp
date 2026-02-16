import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../services/api_service.dart';

class AlertProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Alert> _alerts = [];
  bool _isLoading = false;
  String? _error;
  Alert? _latestAlert;

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Alert? get latestAlert => _latestAlert;

  Future<void> fetchAlerts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/alerts');
      if (response is List) {
        _alerts = (response)
            .map((alert) => Alert.fromJson(alert as Map<String, dynamic>))
            .toList();
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> reportAlert(Map<String, dynamic> signalData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post('/alerts', signalData);
      final newAlert = Alert.fromJson(response as Map<String, dynamic>);
      _latestAlert = newAlert;
      _alerts.insert(0, newAlert);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPanicAlert() async {
    return reportAlert({
      'type': 'panic',
      'riskLevel': 0.95,
      'signals': ['manual_activation'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
