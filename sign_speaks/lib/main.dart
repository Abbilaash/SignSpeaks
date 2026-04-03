import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SignSpeaksApp());
}

class AppColors {
  static const Color background = Color(0xFF0A0A0A);
  static const Color cardBackground = Color(0xFF1A1A1A);
  static const Color primary = Color(0xFF1E90FF);
  // Add a slight glow effect to cards
  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: primary.withOpacity(0.15),
      blurRadius: 20,
      spreadRadius: 1,
      offset: const Offset(0, 4),
    ),
  ];
}

class AppStyles {
  static const double cardRadius = 24.0;
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
}

class SignSpeaksApp extends StatefulWidget {
  const SignSpeaksApp({super.key});

  @override
  State<SignSpeaksApp> createState() => _SignSpeaksAppState();
}

class _SignSpeaksAppState extends State<SignSpeaksApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignSpeaks Premium',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.cardBackground,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: MainScreen(onThemeChanged: toggleTheme),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const MainScreen({super.key, required this.onThemeChanged});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const LiveDetectionScreen(),
      const TextToSignScreen(),
      const HistoryScreen(),
      SettingsScreen(onThemeChanged: widget.onThemeChanged),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.cardBackground.withOpacity(0.9)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.black12,
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.videocam_rounded, 'Live', 0, isDark),
              _buildNavItem(Icons.text_fields_rounded, 'Text', 1, isDark),
              _buildNavItem(Icons.history_rounded, 'History', 2, isDark),
              _buildNavItem(Icons.settings_rounded, 'Settings', 3, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isDark) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? AppColors.primary
        : (isDark ? Colors.grey : Colors.black54);
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1. LIVE DETECTION SCREEN
// ==========================================
class LiveDetectionScreen extends StatelessWidget {
  const LiveDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardBackground : Colors.white;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Live Detection',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Camera Feed
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                    boxShadow: isDark
                        ? AppColors.glowShadow
                        : [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Simulated Camera Feed
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white24,
                        size: 80,
                      ),
                      // Overlay Bounding Box
                      Positioned(
                        top: 40,
                        bottom: 40,
                        left: 40,
                        right: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      // Top indicator
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.redAccent,
                                size: 10,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "LIVE",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Detected Gesture
              Container(
                padding: AppStyles.cardPadding,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                  boxShadow: isDark
                      ? []
                      : [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          ),
                        ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'HELLO',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Confidence',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const LinearProgressIndicator(
                              value: 0.95,
                              backgroundColor: Colors.white12,
                              color: AppColors.primary,
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '95%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // AI Response Bubble
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Hello! How can I help you today?",
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. HISTORY SCREEN
// ==========================================
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardBackground : Colors.white;

    final dummyHistory = [
      {'gesture': 'HELLO', 'time': '10:42 AM', 'conf': '95%'},
      {'gesture': 'THANK YOU', 'time': '10:38 AM', 'conf': '92%'},
      {'gesture': 'PLEASE', 'time': '10:15 AM', 'conf': '88%'},
      {'gesture': 'YES', 'time': '09:50 AM', 'conf': '98%'},
      {'gesture': 'NO', 'time': '09:48 AM', 'conf': '97%'},
      {'gesture': 'HELP', 'time': '09:20 AM', 'conf': '85%'},
      {'gesture': 'FRIEND', 'time': '08:15 AM', 'conf': '91%'},
      {'gesture': 'GOOD', 'time': 'Yesterday', 'conf': '94%'},
      {'gesture': 'MORNING', 'time': 'Yesterday', 'conf': '89%'},
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Recent Detections',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: dummyHistory.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = dummyHistory[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isDark
                            ? []
                            : [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.history_edu,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['gesture']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['time']!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['conf']!,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. TEXT TO SIGN SCREEN
// ==========================================
class TextToSignScreen extends StatelessWidget {
  const TextToSignScreen({super.key});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://prvpwhcm-5000.inc1.devtunnels.ms/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardBackground : Colors.white;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Text to Sign Language',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: AppStyles.cardPadding,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                    boxShadow: isDark
                        ? []
                        : [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome to the Text to Indian Sign Language module of our Signspeaks app. This module converts your given english text into corresponding indian sign language. To experience and use the feature, click the button below. Thanks for choosing our app !",
                        style: TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          onPressed: _launchURL,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Try Text to Sign'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. SETTINGS SCREEN
// ==========================================
class SettingsScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _cameraEnabled = true;
  bool _realtimeTranslation = true;
  bool _textToSpeech = false;
  String _selectedModel = 'Standard AI (Fast)';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardBackground : Colors.white;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // AI Features Group
                _buildSectionHeader('AI Features'),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                  ),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        'Real-time Translation',
                        _realtimeTranslation,
                        (val) => setState(() => _realtimeTranslation = val),
                      ),
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      _buildSwitchTile(
                        'Text-to-Speech (Beta)',
                        _textToSpeech,
                        (val) => setState(() => _textToSpeech = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Device Group
                _buildSectionHeader('Device'),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                  ),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        'Camera Enabled',
                        _cameraEnabled,
                        (val) => setState(() => _cameraEnabled = val),
                      ),
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'AI Model',
                              style: TextStyle(fontSize: 16),
                            ),
                            DropdownButton<String>(
                              value: _selectedModel,
                              underline: const SizedBox(),
                              dropdownColor: isDark
                                  ? AppColors.cardBackground
                                  : Colors.white,
                              items:
                                  [
                                    'Standard AI (Fast)',
                                    'Premium AI (Accurate)',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() => _selectedModel = newValue);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Appearance Group
                _buildSectionHeader('Appearance'),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    title: const Text(
                      'Dark Theme',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (val) => widget.onThemeChanged(),
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
    );
  }
}
