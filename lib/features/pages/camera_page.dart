import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isScanning = false;
  bool _showResult = false;
  String _scannedResult = '';
  bool _isMatch = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    _controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('Camera access denied');
            break;
          default:
            print('Camera error: ${e.description}');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndScan() async {
    if (!_isCameraInitialized || _controller == null || _isScanning) return;

    setState(() {
      _isScanning = true;
      _showResult = false;
    });

    try {
      final XFile image = await _controller!.takePicture();
      await Future.delayed(const Duration(milliseconds: 800));

      const testSerials = [
        'SN-LTP2024001',
        'SN-LTP2024002',
        'SN-LTP2024003',
        'SN-LTP2024004',
        'SN-LTP2024005',
      ];
      final randomSerial =
          testSerials[DateTime.now().millisecond % testSerials.length];
      final isMatch = DateTime.now().second % 3 != 0;

      setState(() {
        _isScanning = false;
        _showResult = true;
        _scannedResult = randomSerial;
        _isMatch = isMatch;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      print('Capture error: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_isCameraInitialized) return;

    try {
      if (_flashOn) {
        await _controller!.setFlashMode(FlashMode.off);
      } else {
        await _controller!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        _flashOn = !_flashOn;
      });
    } catch (e) {
      print('Flash error: $e');
    }
  }

  void _closeResult() {
    setState(() {
      _showResult = false;
    });
  }

  Widget _buildCameraScanner() {
    if (!_isCameraInitialized || _controller == null) {
      return Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF003366).withOpacity(0.5),
            width: 2,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF003366),
                strokeWidth: 2,
              ),
              SizedBox(height: 10),
              Text(
                'ካሜራ በመጀመር ላይ...', // Initializing camera...
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF003366),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            children: [
              CameraPreview(_controller!),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(13),
                            topRight: Radius.circular(13),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF003366).withOpacity(0),
                                    const Color(0xFF003366),
                                    const Color(0xFF003366).withOpacity(0),
                                  ],
                                  stops: const [0.1, 0.5, 0.9],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF003366).withOpacity(0),
                                    const Color(0xFF003366),
                                    const Color(0xFF003366).withOpacity(0),
                                  ],
                                  stops: const [0.1, 0.5, 0.9],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 6,
                              color: const Color(0xFF003366).withOpacity(0.5),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 6,
                              color: const Color(0xFF003366).withOpacity(0.5),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: const Color(0xFF003366),
                                    width: 4,
                                  ),
                                  top: BorderSide(
                                    color: const Color(0xFF003366),
                                    width: 4,
                                  ),
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: const Color(0xFF003366),
                                    width: 4,
                                  ),
                                  top: BorderSide(
                                    color: const Color(0xFF003366),
                                    width: 4,
                                  ),
                                ),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: const Color(0xFF003366),
                                    width: 4,
                                  ),
                                  bottom: BorderSide(
                                    color: const Color(0xFF003366),
                                    width: 4,
                                  ),
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: const Color(0xFF003366),
                                    width: 4,
                                  ),
                                  bottom: BorderSide(
                                    color: const Color(0xFF003366),
                                    width: 4,
                                  ),
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          if (_isScanning)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Color(0xFF003366),
                                      strokeWidth: 2,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'በመቃኘት ላይ...', // Scanning...
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(13),
                            bottomRight: Radius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFF5F7FA),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Text(
                          'ላፕቶፕ ስካን',
                          style: TextStyle(
                            color: const Color(0xFF003366).withOpacity(0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ሴሪያል ቁጥሩን በሰማያዊ መስመሮጭ መካከል ኣስተካክለው ስካን ያድርጉ ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 320,
                      maxHeight: 400,
                    ),
                    child: _buildCameraScanner(),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isScanning ? null : _captureAndScan,
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
                                SizedBox(width: 10),
                                Text(
                                  'Scan', // CAPTURE
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'ግልጽ ቀረጻ ለማግኘት አይንቀሳቀሱ', // Hold steady for clear scan
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
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
                            _isMatch
                                ? 'የተረጋገጠ'
                                : 'አይዛመድም', // VERIFIED / MISMATCH
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
                              'የላፕቶፕ ተከታታይ ቁጥር', // Laptop Serial Number
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _closeResult,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF003366),
                                side:
                                    const BorderSide(color: Color(0xFF003366)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'እንደገና ቃኝ', // SCAN AGAIN
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (_isMatch)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Navigate to student details
                                  print('View details for $_scannedResult');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003366),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  'ቀጥል', // PROCEED
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
      ),
    );
  }
}
