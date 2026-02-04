import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addStudent(Map<String, dynamic> studentData) async {
    try {
      await _supabase.from('students').insert(studentData);
    } catch (e) {
      throw Exception('Failed to register student: $e');
    }
  }

  Future<Map<String, dynamic>?> getStudentBySerial(String serial) async {
    try {
      final response = await _supabase
          .from('students')
          .select()
          .eq('laptop_serial', serial)
          .single();
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkSerialExists(String serial) async {
    try {
      final response = await _supabase
          .from('students')
          .select('id')
          .eq('laptop_serial', serial);
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
