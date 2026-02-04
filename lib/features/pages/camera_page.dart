import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isScanning = false;
  String _scannedResult = '';
  bool _showResult = false;
  bool _isMatch = false;
  bool _flashOn = false;

  void _simulateScan() {
    setState(() {
      _isScanning = true;
      _showResult = false;
    });

    // Simulate scanning delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isScanning = false;
        _showResult = true;
        _scannedResult = 'SN-ABC123XYZ';
        _isMatch = true;
      });
    });
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light gray background
      body: Stack(
        children: [
          // Main content
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFF5F7FA),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top Info
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      'SCAN LAPTOP SERIAL',
                      style: TextStyle(
                        color: const Color(0xFF003366).withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Scanner Frame Only (no background box)
                  SizedBox(
                    width: 320,
                    height: 120,
                    child: Stack(
                      children: [
                        // Scanner Frame - just the border and guides
                        Container(
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFF5F7FA), // Same as background
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF003366).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Top Guide Line
                              Positioned(
                                top: 40,
                                left: 20,
                                right: 20,
                                child: Container(
                                  height: 1,
                                  color:
                                      const Color(0xFF003366).withOpacity(0.6),
                                ),
                              ),

                              // Bottom Guide Line
                              Positioned(
                                bottom: 40,
                                left: 20,
                                right: 20,
                                child: Container(
                                  height: 1,
                                  color:
                                      const Color(0xFF003366).withOpacity(0.6),
                                ),
                              ),

                              // Scanning Animation Area
                              if (!_isScanning)
                                Positioned(
                                  top: 40,
                                  left: 20,
                                  right: 20,
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    curve: Curves.easeInOut,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF003366),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Animated scanning beam
                                        Positioned.fill(
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 1500),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(0xFF003366)
                                                      .withOpacity(0.3),
                                                  const Color(0xFF003366),
                                                  const Color(0xFF003366)
                                                      .withOpacity(0.3),
                                                ],
                                                stops: const [0.0, 0.5, 1.0],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                width: 4,
                                                height: 36,
                                                color: const Color(0xFF003366),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Corner markers
                        Positioned(
                          top: 40,
                          left: 20,
                          child: Container(
                            width: 12,
                            height: 2,
                            color: const Color(0xFF003366),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 20,
                          child: Container(
                            width: 12,
                            height: 2,
                            color: const Color(0xFF003366),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 20,
                          child: Container(
                            width: 12,
                            height: 2,
                            color: const Color(0xFF003366),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          right: 20,
                          child: Container(
                            width: 12,
                            height: 2,
                            color: const Color(0xFF003366),
                          ),
                        ),

                        // Scanning Indicator (center of frame)
                        if (_isScanning)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: Color(0xFF003366),
                                  strokeWidth: 2,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Scanning...',
                                  style: TextStyle(
                                    color: const Color(0xFF003366)
                                        .withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Scan Instructions
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    child: Column(
                      children: [
                        Text(
                          'Align the serial number',
                          style: TextStyle(
                            color: const Color(0xFF003366).withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'between the blue lines',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'SN-XXXXXXXXX',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scan Button
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isScanning ? null : _simulateScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 3,
                      ),
                      child: _isScanning
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code_scanner_rounded, size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'SCAN SERIAL',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  // Flash Button
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: IconButton(
                      onPressed: _toggleFlash,
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _flashOn
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          color: const Color(0xFF003366),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Result Modal
          if (_showResult)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Result Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isMatch
                              ? Icons.check_circle_rounded
                              : Icons.warning_rounded,
                          color: _isMatch ? Colors.green : Colors.red,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _isMatch ? 'VERIFIED' : 'MISMATCH',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _isMatch ? Colors.green : Colors.red,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Serial Number Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _scannedResult,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF003366),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Laptop Serial Number',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: const Color(0xFF003366),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isMatch ? 'John Doe' : 'Not Found',
                                  style: const TextStyle(
                                    color: Color(0xFF003366),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _isMatch
                                      ? 'Student • BIT2023001 • Computer Science'
                                      : 'No matching registration found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isMatch)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _showResult = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF003366),
                              side: const BorderSide(color: Color(0xFF003366)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'SCAN AGAIN',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Navigate to student details
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003366),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'VIEW DETAILS',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
