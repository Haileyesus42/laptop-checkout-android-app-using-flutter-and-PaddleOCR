import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:laptop_checkout/services/auth_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthServices();
  DateTime? _shiftStartTime;
  int _totalScans = 147;
  int _validMatches = 139;
  int _possibleThefts = 8;
  bool _isOnShift = true;
  Timer? _shiftTimer;

  @override
  void initState() {
    super.initState();
    _loadGatekeeperData();
    _startShiftTimer();
  }

  @override
  void dispose() {
    _shiftTimer?.cancel();
    super.dispose();
  }

  void _loadGatekeeperData() {
    setState(() {
      _isOnShift = true;
      _shiftStartTime =
          DateTime.now().subtract(const Duration(hours: 3, minutes: 42));
    });
  }

  void _startShiftTimer() {
    _shiftTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void _endShift() async {
    bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("End Shift"),
            content:
                const Text("Are you sure you want to end your current shift?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("End Shift"),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      _shiftTimer?.cancel();
      setState(() {
        _isOnShift = false;
      });
    }
  }

  void _startNewShift() {
    setState(() {
      _isOnShift = true;
      _shiftStartTime = DateTime.now();
      _totalScans = 0;
      _validMatches = 0;
      _possibleThefts = 0;
    });
    _startShiftTimer();
  }

  void _logout() async {
    bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      // Cancel shift timer if running
      _shiftTimer?.cancel();

      // Call logout from auth service
      await authService.signOut();

      // The AuthGate stream will automatically handle redirection to login
    }
  }

  String _getShiftDuration() {
    if (_shiftStartTime == null) return "00:00:00";

    final duration = DateTime.now().difference(_shiftStartTime!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = authService.getuserEmail() ?? "gatekeeper@campus.edu";
    final userName = userEmail.split('@').first;
    final displayName = userName
        .split('.')
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Shift Status Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF003366), Color(0xFF002952)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _isOnShift
                          ? Icons.security_rounded
                          : Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gatekeeper ID: GK-2024-008',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _isOnShift ? Colors.green : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _isOnShift
                                        ? Icons.check_circle
                                        : Icons.pause_circle,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isOnShift ? 'ON DUTY' : 'OFF DUTY',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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
                  if (_isOnShift)
                    IconButton(
                      onPressed: _endShift,
                      icon: const Icon(Icons.stop_circle_outlined,
                          color: Colors.white),
                      tooltip: 'End Shift',
                    ),
                ],
              ),
            ),

            // Shift Timer Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shift Started',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _shiftStartTime != null
                            ? DateFormat('h:mm a').format(_shiftStartTime!)
                            : '--:--',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF003366),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey[200],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getShiftDuration(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF003366),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey[200],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d').format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF003366),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Compact Metrics
            Container(
              height: 70,
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  // Total Scans
                  Expanded(
                    child: _buildMiniMetricCard(
                      title: 'SCANS',
                      value: _totalScans.toString(),
                      icon: Icons.qr_code_scanner_rounded,
                      color: const Color(0xFF003366),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Valid Matches
                  Expanded(
                    child: _buildMiniMetricCard(
                      title: 'MATCHES',
                      value: _validMatches.toString(),
                      icon: Icons.check_circle_rounded,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Possible Thefts
                  Expanded(
                    child: _buildMiniMetricCard(
                      title: 'THEFTS',
                      value: _possibleThefts.toString(),
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Success Rate
                  Expanded(
                    child: _buildMiniMetricCard(
                      title: 'RATE',
                      value: _totalScans > 0
                          ? '${((_validMatches / _totalScans) * 100).toStringAsFixed(1)}%'
                          : '0%',
                      icon: Icons.trending_up_rounded,
                      color: const Color(0xFF9C27B0),
                    ),
                  ),
                ],
              ),
            ),

            // Shift Summary
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SHIFT SUMMARY',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF003366),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem(
                        label: 'Shift Status',
                        value: _isOnShift ? 'ACTIVE' : 'INACTIVE',
                        valueColor: _isOnShift ? Colors.green : Colors.grey,
                      ),
                      _buildSummaryItem(
                        label: 'Gate Station',
                        value: 'GATE 1',
                        valueColor: Colors.grey[800],
                      ),
                      _buildSummaryItem(
                        label: 'Last Scan',
                        value: '14:30',
                        valueColor: Colors.grey[800],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (!_isOnShift)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _startNewShift,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'START NEW SHIFT',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Logout Button
            Container(
              width: double.infinity,
              height: 48,
              margin: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.red.shade300,
                      width: 1.5,
                    ),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'LOGOUT',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.0,
                      ),
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

  Widget _buildMiniMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003366),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                letterSpacing: 0.8,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
