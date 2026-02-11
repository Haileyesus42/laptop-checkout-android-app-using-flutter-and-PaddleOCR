import 'package:flutter/material.dart';
import 'package:laptop_checkout/services/database_service.dart';

class RegisterStudentPage extends StatefulWidget {
  const RegisterStudentPage({super.key});

  @override
  State<RegisterStudentPage> createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _dbService = DatabaseService();

  // Student Information
  final _studentNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _departmentController = TextEditingController();

  // Laptop Information
  final _laptopSerialController = TextEditingController();
  final _laptopBrandController = TextEditingController();
  final _laptopModelController = TextEditingController();

  bool _isLoading = false;
  String? _selectedLaptopType;

  final List<String> _laptopTypes = [
    'ላፕቶፕ', // Laptop
    'አልትራቡክ', // Ultrabook
    'የጨዋታ ላፕቶፕ', // Gaming Laptop
    'ተለዋጭ (ኮንቨርትብል)', // Convertible
    'ክሮምቡክ', // Chromebook
    'ማክቡክ', // MacBook
  ];

  @override
  void dispose() {
    _studentNameController.dispose();
    _studentIdController.dispose();
    _departmentController.dispose();
    _laptopSerialController.dispose();
    _laptopBrandController.dispose();
    _laptopModelController.dispose();
    super.dispose();
  }

  void _registerStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final studentData = {
          'student_name': _studentNameController.text.trim(),
          'student_id': _studentIdController.text.trim(),
          'department': _departmentController.text.trim(),
          'laptop_serial': _laptopSerialController.text.trim(),
          'laptop_brand': _laptopBrandController.text.trim(),
          'laptop_model': _laptopModelController.text.trim(),
          'laptop_type': _selectedLaptopType,
          'registration_date': DateTime.now().toIso8601String(),
          'registered_by': 'gatekeeper',
        };

        await _dbService.addStudent(studentData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'ተማሪ በተሳካ ሁኔታ ተመዝግቧል'), // Student registered successfully
              backgroundColor: Colors.green[800],
              duration: const Duration(seconds: 2),
            ),
          );

          // Clear form
          _formKey.currentState!.reset();
          setState(() {
            _selectedLaptopType = null;
          });

          // Navigate back after success
          await Future.delayed(const Duration(milliseconds: 1000));
          if (mounted) Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'መመዝገብ አልተሳካም: ${e.toString()}'), // Registration failed: ...
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // የተማሪ መረጃ ክፍል (Student Information Section)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.person_outline,
                                color: Color(0xFF003366), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'የተማሪ መረጃ', // STUDENT INFORMATION
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF003366),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ሙሉ ስም (Full Name)
                        _buildCompactTextField(
                          label: 'ሙሉ ስም', // Full Name
                          hint: 'የተማሪ ስም ያስገቡ', // Enter student name
                          controller: _studentNameController,
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'አስፈላጊ ነው'; // Required
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // የተማሪ መታወቂያ (Student ID)
                        _buildCompactTextField(
                          label: 'የተማሪ መታወቂያ', // Student ID
                          hint: 'BIT2024001',
                          controller: _studentIdController,
                          icon: Icons.badge_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'አስፈላጊ ነው'; // Required
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // ክፍል (Department)
                        _buildCompactTextField(
                          label: 'ክፍል', // Department
                          hint: 'ኮምፒውተር ሳይንስ', // Computer Science
                          controller: _departmentController,
                          icon: Icons.school_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'አስፈላጊ ነው'; // Required
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  // የላፕቶፕ መረጃ ክፍል (Laptop Information Section)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.laptop_chromebook_rounded,
                                color: Color(0xFF003366), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'የላፕቶፕ መረጃ', // LAPTOP INFORMATION
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF003366),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ተከታታይ ቁጥር (Serial Number)
                        _buildCompactTextField(
                          label: 'ተከታታይ ቁጥር', // Serial Number
                          hint: 'SN-ABC123XYZ',
                          controller: _laptopSerialController,
                          icon: Icons.qr_code_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'አስፈላጊ ነው'; // Required
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // ብራንድ እና ሞዴል (Brand & Model)
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactTextField(
                                label: 'ብራንድ', // Brand
                                hint: 'ዴል፣ ኤችፒ፣ ወዘተ.', // Dell, HP, etc.
                                controller: _laptopBrandController,
                                icon: Icons.branding_watermark,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'አስፈላጊ ነው'; // Required
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactTextField(
                                label: 'ሞዴል', // Model
                                hint: 'XPS 13, ወዘተ.', // XPS 13, etc.
                                controller: _laptopModelController,
                                icon: Icons.model_training,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'አስፈላጊ ነው'; // Required
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // አይነት (Laptop Type Dropdown)
                        Text(
                          'አይነት', // Type
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedLaptopType,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.laptop,
                                  color: Colors.grey, size: 20),
                            ),
                            hint: const Text(
                              'አይነት ይምረጡ', // Select type
                              style: TextStyle(fontSize: 14),
                            ),
                            isExpanded: true,
                            items: _laptopTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLaptopType = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'አስፈላጊ ነው'; // Required
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ጠቃሚ ማስታወሻ (Important Note)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xFF003366), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'ተከታታይ ቁጥሩ ለካምፓስ ደህንነት ማረጋገጫ ይጠቅማል። በላፕቶፑ ላይ ካለው ተለጣፊ ቁጥር ጋር የሚመሳሰል መሆኑን ያረጋግጡ።',
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registerStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_alt_1, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'ተማሪ መዝግብ', // REGISTER STUDENT
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(
                      height: 40), // Extra space for bottom navigation
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14),
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: Colors.grey, size: 20),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
