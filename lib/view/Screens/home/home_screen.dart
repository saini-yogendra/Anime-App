import 'dart:ui';
import '../../../services/barrel_file/anime_services_barrel.dart';
import 'package:flutter/material.dart';
import 'package:anime_app/model/animeModel.dart';
import '../../widgets/category/category_selector.dart';
import '../../widgets/search/search_screen.dart';
import 'anime_details_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final List<Anime> _animeList = [];
  final List<String> _categories = [
    'New Release',
    'Popular',
    'Top Ranking',
    'Upcoming',
    'Movie',
  ];

  String? _nextUrl;
  bool _isLoading = false;
  bool _isFirstLoad = true;
  bool _hasError = false;
  String _selectedCategory = 'New Release';

  final Map<String, List<Anime>> _categoryCache = {};
  final Map<String, String?> _nextUrlCache = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchInitialAnimes();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        !_isLoading &&
        _nextUrl != null) {
      _fetchMoreAnimes();
    }
  }

  Future<void> _fetchInitialAnimes() async {
    if (_categoryCache.containsKey(_selectedCategory)) {
      setState(() {
        _animeList.clear();
        _animeList.addAll(_categoryCache[_selectedCategory]!);
        _nextUrl = _nextUrlCache[_selectedCategory];
        _isFirstLoad = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isFirstLoad = true;
      _hasError = false;
    });

    try {
      Map<String, dynamic> result = await _getAnimeService();
      setState(() {
        _animeList.clear();
        _animeList.addAll(result['animes']);
        _nextUrl = result['nextUrl'];
        _categoryCache[_selectedCategory] = List.from(_animeList);
        _nextUrlCache[_selectedCategory] = _nextUrl;
      });
    } catch (e) {
      debugPrint("Initial fetch error: $e");
      setState(() => _hasError = true);
    } finally {
      setState(() {
        _isLoading = false;
        _isFirstLoad = false;
      });
    }
  }

  Future<void> _fetchMoreAnimes() async {
    if (_nextUrl == null || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final result = await BaseAnimeService().fetchAnimesWithPaging(_nextUrl!);
      setState(() {
        _animeList.addAll(result['animes']);
        _nextUrl = result['nextUrl'];
        _categoryCache[_selectedCategory] = List.from(_animeList);
        _nextUrlCache[_selectedCategory] = _nextUrl;
      });
    } catch (e) {
      debugPrint("Load more error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>> _getAnimeService() async {
    switch (_selectedCategory) {
      case 'Popular':
        return await PopularAnimeService().fetchPopularAnimes();
      case 'Isekai':
        return await IsekaiAnimeService().fetchIsekaiAnimes();
      case 'New Release':
        return await SeasonalAnimeService().fetchSeasonalAnimes();
      case 'Shonen':
        return await ShonenAnimeService().fetchShonenAnimes();
      case 'Top Ranking':
        return await TopRankingAnimeService().fetchTopRankingAnimes();
      case 'Movie':
        return await AnimeMovieService().fetchAnimeMovies();
      default:
        return await UpcomingAnimeService().fetchUpcomingAnimes();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 10),
            CategorySelector(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
                _fetchInitialAnimes();
              },
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          );
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2F2F4B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey, size: 28),
              SizedBox(width: 10),
              Text('Search...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_hasError) {
      return _buildErrorWidget();
    }
    if (_isFirstLoad) {
      return _buildShimmerGrid();
    }
    if (_animeList.isEmpty) {
      return const Center(
        child: Text("No anime found", style: TextStyle(color: Colors.white)),
      );
    }
    return _buildAnimeGrid();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.grey, size: 64),
          const SizedBox(height: 16),
          const Text(
            "Failed to load anime",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _categoryCache.remove(_selectedCategory);
              _nextUrlCache.remove(_selectedCategory);
              _fetchInitialAnimes();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text("Retry", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AppBar(
            backgroundColor: Colors.black.withOpacity(0.03),
            elevation: 0,
            title: const Text("H O M E", style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.5,
      ),
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2F2F4B),
      highlightColor: const Color(0xFF404060),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F4B),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF2F2F4B),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            height: 12,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2F2F4B),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeGrid() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _animeList.length + (_isLoading ? 3 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.5,
      ),
      itemBuilder: (context, index) {
        if (index >= _animeList.length) {
          return _buildShimmerItem();
        }

        final anime = _animeList[index];
        return _buildAnimeCard(anime, index);
      },
    );
  }

  Widget _buildAnimeCard(Anime anime, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AnimeDetailScreen(anime: anime)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: 'animeImage_${anime.id}_$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: anime.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder:
                      (context, url) => Shimmer.fromColors(
                        baseColor: const Color(0xFF2F2F4B),
                        highlightColor: const Color(0xFF404060),
                        child: Container(color: const Color(0xFF2F2F4B)),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: const Color(0xFF2F2F4B),
                        child: const Icon(Icons.error, color: Colors.grey),
                      ),
                  memCacheWidth: 200,
                  memCacheHeight: 300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            anime.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (anime.genres.isNotEmpty)
            Text(
              anime.genres.take(2).join(', '),
              style: TextStyle(color: Colors.grey[300], fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
