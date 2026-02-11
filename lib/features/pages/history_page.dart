import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _expandedIndex = -1; // -1 means no item is expanded

  // Sample data with Amharic status labels
  final List<Map<String, dynamic>> _historyItems = [
    {
      'id': 1,
      'time': '14:30',
      'date': '2024-01-15',
      'studentId': 'BIT2023001',
      'studentName': 'John Doe',
      'department': 'Computer Science',
      'laptopSerial': 'SN-ABC123XYZ',
      'laptopBrand': 'Dell',
      'laptopModel': 'XPS 13',
      'laptopType': 'አልትራቡክ', // Ultrabook
      'status': 'የተረጋገጠ', // Verified
      'statusColor': Colors.green,
      'scannedBy': 'Gatekeeper 1',
      'registrationDate': '2024-01-10',
    },
    {
      'id': 2,
      'time': '14:25',
      'date': '2024-01-15',
      'studentId': 'BIT2023045',
      'studentName': 'Jane Smith',
      'department': 'Information Technology',
      'laptopSerial': 'SN-DEF456UVW',
      'laptopBrand': 'HP',
      'laptopModel': 'Spectre x360',
      'laptopType': 'ተለዋጭ (ኮንቨርትብል)', // Convertible
      'status': 'አይዛመድም', // Mismatch
      'statusColor': Colors.red,
      'scannedBy': 'Gatekeeper 2',
      'registrationDate': '2024-01-12',
    },
    {
      'id': 3,
      'time': '14:20',
      'date': '2024-01-15',
      'studentId': 'BIT2023012',
      'studentName': 'Robert Johnson',
      'department': 'Software Engineering',
      'laptopSerial': 'SN-GHI789RST',
      'laptopBrand': 'Apple',
      'laptopModel': 'MacBook Pro 14"',
      'laptopType': 'ማክቡክ', // MacBook
      'status': 'የተረጋገጠ', // Verified
      'statusColor': Colors.green,
      'scannedBy': 'Gatekeeper 1',
      'registrationDate': '2024-01-08',
    },
    {
      'id': 4,
      'time': '14:15',
      'date': '2024-01-15',
      'studentId': 'BIT2023087',
      'studentName': 'Sarah Williams',
      'department': 'Cybersecurity',
      'laptopSerial': 'SN-JKL012MNO',
      'laptopBrand': 'Lenovo',
      'laptopModel': 'ThinkPad X1 Carbon',
      'laptopType': 'ላፕቶፕ', // Laptop
      'status': 'የተረጋገጠ', // Verified
      'statusColor': Colors.green,
      'scannedBy': 'Gatekeeper 3',
      'registrationDate': '2024-01-14',
    },
    {
      'id': 5,
      'time': '14:10',
      'date': '2024-01-15',
      'studentId': 'BIT2023056',
      'studentName': 'Michael Brown',
      'department': 'Data Science',
      'laptopSerial': 'SN-PQR345TUV',
      'laptopBrand': 'Asus',
      'laptopModel': 'ROG Zephyrus',
      'laptopType': 'የጨዋታ ላፕቶፕ', // Gaming Laptop
      'status': 'አይዛመድም', // Mismatch
      'statusColor': Colors.red,
      'scannedBy': 'Gatekeeper 1',
      'registrationDate': '2024-01-11',
    },
    {
      'id': 6,
      'time': '14:05',
      'date': '2024-01-15',
      'studentId': 'BIT2023023',
      'studentName': 'Emily Davis',
      'department': 'Computer Science',
      'laptopSerial': 'SN-WXY678ZAB',
      'laptopBrand': 'Microsoft',
      'laptopModel': 'Surface Laptop 5',
      'laptopType': 'ላፕቶፕ', // Laptop
      'status': 'የተረጋገጠ', // Verified
      'statusColor': Colors.green,
      'scannedBy': 'Gatekeeper 2',
      'registrationDate': '2024-01-09',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Statistics (አኃዛዊ መረጃ)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  _buildStatItem('ጠቅላላ ቅኝቶች', '147',
                      Icons.qr_code_scanner_rounded), // Total Scans
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  _buildStatItem(
                      'የተዛመዱ', '139', Icons.check_circle_rounded), // Matches
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  _buildStatItem(
                      'ያልተዛመዱ', '8', Icons.warning_amber_rounded), // Mismatches
                ],
              ),
            ),

            const SizedBox(height: 16),

            // History List (የቅኝት ታሪክ)
            Expanded(
              child: ListView.builder(
                itemCount: _historyItems.length,
                itemBuilder: (context, index) {
                  final item = _historyItems[index];
                  final isExpanded = _expandedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_expandedIndex == index) {
                          _expandedIndex = -1; // Collapse
                        } else {
                          _expandedIndex = index; // Expand
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isExpanded
                              ? const Color(0xFF003366).withOpacity(0.3)
                              : Colors.grey[200]!,
                          width: isExpanded ? 1.5 : 1,
                        ),
                        boxShadow: isExpanded
                            ? [
                                BoxShadow(
                                  color:
                                      const Color(0xFF003366).withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Column(
                        children: [
                          // Main item content
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.laptop_rounded,
                                      color: Colors.grey, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['studentId'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF003366),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['laptopSerial'] ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item['studentName'] ?? ''} • ${item['department'] ?? ''}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item['time'] ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (item['statusColor'] as Color)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            // Decide icon based on color (green = check, red = warning)
                                            (item['statusColor'] as Color)
                                                        .value ==
                                                    Colors.green.value
                                                ? Icons.check
                                                : Icons.warning_amber,
                                            size: 12,
                                            color: item['statusColor'] as Color,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['status'] ?? '',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  item['statusColor'] as Color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Expanded details
                          if (isExpanded) ...[
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey[200],
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // የተማሪ መረጃ (Student Information)
                                  _buildDetailSection(
                                    title: 'የተማሪ መረጃ',
                                    children: [
                                      _buildDetailRow(
                                          'ሙሉ ስም',
                                          item['studentName'] ??
                                              ''), // Full Name
                                      _buildDetailRow(
                                          'የተማሪ መታወቂያ',
                                          item['studentId'] ??
                                              ''), // Student ID
                                      _buildDetailRow(
                                          'ክፍል',
                                          item['department'] ??
                                              ''), // Department
                                      _buildDetailRow(
                                          'የምዝገባ ቀን',
                                          item['registrationDate'] ??
                                              ''), // Registration Date
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // የላፕቶፕ መረጃ (Laptop Information)
                                  _buildDetailSection(
                                    title: 'የላፕቶፕ መረጃ',
                                    children: [
                                      _buildDetailRow(
                                          'ተከታታይ ቁጥር',
                                          item['laptopSerial'] ??
                                              ''), // Serial Number
                                      _buildDetailRow('ብራንድ',
                                          item['laptopBrand'] ?? ''), // Brand
                                      _buildDetailRow('ሞዴል',
                                          item['laptopModel'] ?? ''), // Model
                                      _buildDetailRow('አይነት',
                                          item['laptopType'] ?? ''), // Type
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // የቅኝት መረጃ (Scan Information)
                                  _buildDetailSection(
                                    title: 'የቅኝት መረጃ',
                                    children: [
                                      _buildDetailRow(
                                          'ቀን', item['date'] ?? ''), // Date
                                      _buildDetailRow(
                                          'ሰዓት', item['time'] ?? ''), // Time
                                      _buildDetailRow(
                                          'በቃኘው',
                                          item['scannedBy'] ??
                                              ''), // Scanned By
                                      _buildDetailRow(
                                        'ሁኔታ', // Status
                                        item['status'] ?? '',
                                        valueColor:
                                            item['statusColor'] as Color,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: const Color(0xFF003366)),
              const SizedBox(width: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF003366),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF003366),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: valueColor ?? Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
