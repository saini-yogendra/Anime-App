import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/animeModel.dart';
import '../../widgets/snakbar/custom_snakbar.dart';
import '../home/anime_details_screen.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen>
    with SingleTickerProviderStateMixin {
  List<Anime> watchedList = [];
  List<Anime> unwatchedList = [];
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLists();
  }

  Future<void> _loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('myList') ?? [];

    List<Anime> watched = [];
    List<Anime> unwatched = [];

    for (String item in stored) {
      try {
        final decoded = jsonDecode(item);

        if (decoded is Map<String, dynamic> && decoded.containsKey('anime')) {
          final animeMap = decoded['anime'];
          final isWatched = decoded['watched'] ?? false;
          final anime = Anime.fromJson(animeMap);
          if (isWatched) {
            watched.add(anime);
          } else {
            unwatched.add(anime);
          }
        } else if (decoded is Map<String, dynamic>) {
          final anime = Anime.fromJson(decoded);
          unwatched.add(anime);
        }
      } catch (e) {
        debugPrint('Error parsing stored anime: $e');
      }
    }

    setState(() {
      watchedList = watched;
      unwatchedList = unwatched;
    });
  }

  Future<void> _saveLists() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> combined = [
      ...watchedList.map((anime) => jsonEncode({
        'anime': anime.toJson(),
        'watched': true,
      })),
      ...unwatchedList.map((anime) => jsonEncode({
        'anime': anime.toJson(),
        'watched': false,
      })),
    ];

    await prefs.setStringList('myList', combined);
  }

  void _addToWatched(Anime anime) {
    setState(() {
      unwatchedList.removeWhere((a) => a.id == anime.id);
      watchedList.add(anime);
    });
    _saveLists();
    CustomSnackbar.show(context, "${anime.title} added to Watched");
  }

  Future<void> _removeFromList(Anime anime) async {
    setState(() {
      watchedList.removeWhere((a) => a.id == anime.id);
      unwatchedList.removeWhere((a) => a.id == anime.id);
    });
    _saveLists();
    CustomSnackbar.show(context, "${anime.title} removed from My List");
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: _appBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(top: -50, left: -30, child: _buildBlurCircle(250)),
                Positioned(top: 100, right: -60, child: _buildBlurCircle(250)),
                Positioned(bottom: -40, left: -30, child: _buildBlurCircle(250)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.02),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA372C3), Color(0xFFB59EF0)],
                      ),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Unwatched'),
                      Tab(text: 'Watched'),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAnimeList(unwatchedList, isUnwatched: true),
                      _buildAnimeList(watchedList, isUnwatched: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeList(List<Anime> list, {required bool isUnwatched}) {
    if (list.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/empty_state.jpg',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Many shows to watch..",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Let's watch some new anime..",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final anime = list[index];

        return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500 + index * 100),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnimeDetailScreen(anime: anime),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: anime.imageUrl,
                      height: 80,
                      width: 110,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anime.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          anime.genres.join(', '),
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (isUnwatched) ...[
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFromList(anime),
                    ),
                    IconButton(
                      icon: const Icon(Icons.playlist_add_check_rounded,
                          color: Colors.greenAccent, size: 28),
                      onPressed: () => _addToWatched(anime),
                    ),
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFromList(anime),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlurCircle(double size) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha(15),
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.1),
            elevation: 0,
            title: const Text(
              "M Y  L I S T",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
    );
  }
}
