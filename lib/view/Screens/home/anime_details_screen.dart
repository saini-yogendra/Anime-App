import 'dart:convert';
import 'dart:ui';
import 'package:anime_app/view/widgets/custom%20button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/animeModel.dart';
import '../../../services/anime_detail_api_service.dart';
import '../../../services/anime_ranking_api_service.dart';
import '../../widgets/snakbar/custom_snakbar.dart';

class AnimeDetailScreen extends StatefulWidget {
  final Anime anime;

  const AnimeDetailScreen({Key? key, required this.anime}) : super(key: key);

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final AnimeDetailService _detailService = AnimeDetailService();

  late Future<Anime> _animeDetailFuture;
  List<Anime> rankingAnimeList = [];
  bool isLoading = false;
  bool showInfo = false;
  bool isInMyList = false;
  String? nextPageUrl;

  final _rankingService = TopRankingAnimeService(rankingType: 'airing');

  late final AnimationController _infoAnimationController;
  late final Animation<double> _infoAnimation;

  @override
  void initState() {
    super.initState();
    _animeDetailFuture = _detailService.fetchAnimeDetailById(widget.anime.id);
    _fetchRankingAnimes(isInitial: true);

    _infoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _infoAnimation = CurvedAnimation(
      parent: _infoAnimationController,
      curve: Curves.easeInOut,
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          nextPageUrl != null &&
          !isLoading) {
        _fetchRankingAnimes();
      }
    });

    _checkIfInMyList();
  }

  Future<void> _checkIfInMyList() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList('myList') ?? [];
    setState(() {
      isInMyList = storedList.contains(jsonEncode(widget.anime.toJson()));
    });
  }

  Future<void> _toggleMyList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedList = prefs.getStringList('myList') ?? [];

    final animeJson = jsonEncode(widget.anime.toJson());


    if (isInMyList) {
      storedList.remove(animeJson);
      CustomSnackbar.show(context, "Removed from My List");
    } else {
      storedList.add(animeJson);
      CustomSnackbar.show(context, "Added to My List");
    }


    await prefs.setStringList('myList', storedList);

    setState(() {
      isInMyList = !isInMyList;
    });
  }

  Future<void> _fetchRankingAnimes({bool isInitial = false}) async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final response = isInitial
          ? await _rankingService.fetchTopRankingAnimes()
          : await _rankingService.fetchAnimesWithPaging(nextPageUrl!);

      setState(() {
        if (isInitial) {
          rankingAnimeList = response['animes'];
        } else {
          rankingAnimeList.addAll(response['animes']);
        }
        nextPageUrl = response['nextUrl'];
      });
    } catch (e) {
      debugPrint("Failed to fetch ranked animes: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _infoAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topImageHeight = size.height * 0.45;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      // appBar: _appBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: topImageHeight,
                  width: double.infinity,
                  child: Hero(
                    tag: 'animeImage_${widget.anime.id}',
                    child: CachedNetworkImage(
                      imageUrl: widget.anime.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = constraints.maxWidth / 4;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            child: _myListAnimatedIcon(),
                          ),
                          Expanded(
                            child: Center(child: _playButton()),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showInfo = !showInfo;
                                  showInfo
                                      ? _infoAnimationController.forward()
                                      : _infoAnimationController.reverse();
                                });
                              },
                              child: Column(
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      showInfo
                                          ? Icons.info
                                          : Icons.info_outline,
                                      key: ValueKey(showInfo),
                                      color: const Color(0xFFFF6E40),
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Info",
                                    style: TextStyle(
                                        color: Color(0xFFFF6E40), fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            SizeTransition(
              sizeFactor: _infoAnimation,
              axisAlignment: -1.0,
              child: FutureBuilder<Anime>(
                future: _animeDetailFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child:
                      Center(child: CircularProgressIndicator(color: Colors.white)),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Failed to load description.',
                        style: TextStyle(color: Colors.red[200]),
                      ),
                    );
                  }

                  final detail = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (detail.genres.isNotEmpty)
                          Text(
                            "Genres: ${detail.genres.join(', ')}",
                            style: TextStyle(
                                color: Colors.grey[300], fontSize: 14),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          detail.synopsis?.isNotEmpty == true
                              ? detail.synopsis!
                              : 'No description available.',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text(
                "Top Ranked Anime",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount:
              rankingAnimeList.length + (nextPageUrl != null ? 1 : 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width < 400 ? 2 : 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                if (index == rankingAnimeList.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                final anime = rankingAnimeList[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 500 + (index % 3) * 200),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              AnimeDetailScreen(anime: anime),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: anime.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          anime.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _myListAnimatedIcon() {
    return GestureDetector(
      onTap: _toggleMyList,
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isInMyList ? Icons.check_circle : Icons.add_circle_outline,
              key: ValueKey(isInMyList),
              color: isInMyList ? Colors.greenAccent : Color(0xFFFF6E40),
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isInMyList ? "Added" : "My List",
            style: const TextStyle(color: Color(0xFFFF6E40), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _playButton() {
    return CustomButton(
      text: "P l a y",
      onPressed: () {},
      useGradient: true,
    );
  }

  // PreferredSize _appBar() {
  //   return PreferredSize(
  //     preferredSize: const Size.fromHeight(kToolbarHeight),
  //     child: ClipRRect(
  //       child: BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //         child: AppBar(
  //           backgroundColor: Colors.black.withValues(alpha: 0.1),
  //           elevation: 0,
  //           title: const Text(
  //             "H O M E",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           centerTitle: true,
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
