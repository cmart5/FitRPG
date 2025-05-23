import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

// Toggle for simulating health data for testing purposes when the app is not running on a real device 
const bool simulateHealthData = true;

class HealthService {
  static final _health = Health();

  static Future<Map<String, dynamic>> getTodayActivity() async {

    //Simluation of health data
    if (simulateHealthData) {
      print('[HEALTH] 🤡 Simulating fake health data...');
      return {
        'steps': 9000,
        'calories': 900,
        'duration': 90,
      };
    }

    // Define the types of data to get
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.EXERCISE_TIME,
    ];

    // Request permissions
    final accessGranted = await _health.requestAuthorization(types);
    if (!accessGranted) {
      print('[HEALTH] ❌ Permission not granted');
      return {
        'steps': 0,
        'calories': 0,
        'duration': 0,
      };
    }

    // Get todays date
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now. day);
    final end = now;

    List<HealthDataPoint> records = [];
    try{
      records = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: types,
      );
    } catch (e) {
      print('[HEALTH] ❌ Error fetching health data: $e');
      return {
        'steps': 0,
        'calories': 0,
        'duration': 0,
      };
    }

    int totalSteps = 0;
    double totalCalories = 0;
    int totalDuration = 0;
    for (final record in records) {
      switch (record.type) {
        case HealthDataType.STEPS:
          totalSteps += record.value as int;
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          totalCalories += record.value as double;
          break;
        case HealthDataType.EXERCISE_TIME:
          totalDuration += record.value as int;
          break;
        default:
          break;
      }
    }

    print('[HEALTH] ✅ Steps: $totalSteps, Calories: $totalCalories, Minutes: $totalDuration');

    return {
      'steps': totalSteps,
      'calories': totalCalories.round(),
      'duration': totalDuration,
    };
  }
}

