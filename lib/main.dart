import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/zekr_model.dart';
import 'models/worship_model.dart';
import 'widgets/athkar_dialog.dart';
import 'widgets/worship_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const AthkarApp());
}

class AthkarApp extends StatelessWidget {
  const AthkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أذكاري وعباداتي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C),
          primary: const Color(0xFF00695C),
          secondary: const Color(0xFFE6A100),
          surface: const Color(0xFFF7F9F8),
        ),
      ),
      home: const AthkarHomePage(),
    );
  }
}

class AthkarHomePage extends StatefulWidget {
  const AthkarHomePage({super.key});

  @override
  State<AthkarHomePage> createState() => _AthkarHomePageState();
}

class _AthkarHomePageState extends State<AthkarHomePage> {
  late Future<List<ZekrCategory>> _athkarFuture;
  late Future<List<Worship>> _worshipsFuture;

  @override
  void initState() {
    super.initState();
    _athkarFuture = _loadAthkar();
    _worshipsFuture = _loadWorships();
  }

  Future<List<ZekrCategory>> _loadAthkar() async {
    try {
      final String response = await rootBundle.loadString('assets/athkar.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => ZekrCategory.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error loading Athkar: $e");
      rethrow;
    }
  }

  Future<List<Worship>> _loadWorships() async {
    try {
      final String response = await rootBundle.loadString('assets/worships.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Worship.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error loading Worships: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F7F6),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 220.0,
                  floating: false,
                  pinned: true,
                  stretch: true,
                  backgroundColor: const Color(0xFF004D40),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(bottom: 60),
                    title: Text(
                      'أذكاري وعباداتي',
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Gradient
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF004D40),
                                Color(0xFF00695C),
                                Color(0xFF00897B),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Top decorative circles
                        Positioned(
                          left: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -30,
                          bottom: -10,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    indicatorColor: const Color(0xFFFFC107),
                    indicatorWeight: 4,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                    labelStyle: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    unselectedLabelStyle: GoogleFonts.tajawal(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.menu_book_rounded),
                        text: 'الأذكار اليومية',
                      ),
                      Tab(
                        icon: Icon(Icons.stars_rounded),
                        text: 'العبادات والسنن',
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                // Tab 1: Athkar List
                _buildAthkarTab(),

                // Tab 2: Worships List
                _buildWorshipsTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAthkarTab() {
    return FutureBuilder<List<ZekrCategory>>(
      future: _athkarFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'حدث خطأ أثناء تحميل الأذكار.\n${snapshot.error}',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('لا توجد أذكار متوفرة حالياً.'),
          );
        }

        final categories = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length + 1, // +1 for the top card
          itemBuilder: (context, index) {
            if (index == 0) {
              // Quranic Verse Card
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade800, Colors.amber.shade600],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.shade800.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.format_quote_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '[سورة الرعد - الآية 28]',
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final category = categories[index - 1];
            final categoryColor = Color(int.parse(category.color));

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AthkarDialog(category: category),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Left Icon
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getZekrIconData(category.icon),
                            color: categoryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Texts
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.title,
                                style: GoogleFonts.tajawal(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'يحتوي على ${category.items.length} أذكار مرتبة',
                                style: GoogleFonts.tajawal(
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Arrow
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWorshipsTab() {
    return FutureBuilder<List<Worship>>(
      future: _worshipsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'حدث خطأ أثناء تحميل العبادات.\n${snapshot.error}',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('لا توجد عبادات متوفرة حالياً.'),
          );
        }

        final worships = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: worships.length + 1, // +1 for the top Card
          itemBuilder: (context, index) {
            if (index == 0) {
              // Islamic Hadith Card
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00695C), Color(0xFF004D40)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF004D40).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.brightness_high_rounded,
                        color: Colors.amber,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '«بُنِيَ الإِسْلامُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لا إِلَهَ إِلا اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاةِ، وَإِيتَاءِ الزَّكَاةِ، وَالحَجِّ، وَصَوْمِ رَمَضَانَ»',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '[متفق عليه]',
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final worship = worships[index - 1];
            final worshipColor = Color(int.parse(worship.color));

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => WorshipDialog(worship: worship),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Left Icon
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: worshipColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getWorshipIconData(worship.icon),
                            color: worshipColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Texts
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                worship.title,
                                style: GoogleFonts.tajawal(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                worship.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.tajawal(
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Arrow
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getZekrIconData(String iconName) {
    switch (iconName) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'moon':
        return Icons.nights_stay_rounded;
      case 'mosque':
        return Icons.mosque_rounded;
      case 'bedtime':
        return Icons.bedtime_rounded;
      default:
        return Icons.bookmark_rounded;
    }
  }

  IconData _getWorshipIconData(String iconName) {
    switch (iconName) {
      case 'mosque':
        return Icons.mosque_rounded;
      case 'fasting':
        return Icons.wb_twilight_rounded;
      case 'zakat':
        return Icons.volunteer_activism_rounded;
      case 'hajj':
        return Icons.explore_rounded;
      default:
        return Icons.bookmark_rounded;
    }
  }
}
