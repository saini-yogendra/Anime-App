import 'dart:async';
import 'package:flutter/material.dart';
import '../../../model/animeModel.dart';
import '../../../services/search_anime_api_service.dart';
import '../../Screens/home/anime_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Anime> _searchResults = [];
  List<Anime> _allAnimes = [];
  bool _isLoading = false;
  late AnimationController _animationController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Focus keyboard when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      _debounceSearch(query);
    });
  }

  void _debounceSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.length >= 3) {
        _performSearch(query);
      } else {
        setState(() => _searchResults = []);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchResults.clear();
      _allAnimes.clear();
    });

    try {
      final result = await SearchAnimeService().fetchInitialAnimes(query);
      final List<Anime> animes = result['animes'];
      _allAnimes = animes;
      _filterResults(query);
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterResults(String query) {
    final lowerQuery = query.toLowerCase();

    final filtered = _allAnimes.where((anime) {
      final title = anime.title.toLowerCase();
      final altTitle = anime.alternativeTitle?.toLowerCase() ?? '';
      return title.contains(lowerQuery) || altTitle.contains(lowerQuery);
    }).toList();

    setState(() => _searchResults = filtered);
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search anime...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _performSearch,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                _performSearch(_searchController.text.trim());
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
          ? const Center(
        child: Text(
          'No results found',
          style: TextStyle(color: Colors.white),
        ),
      )
          : FadeTransition(
        opacity: _animationController,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _searchResults.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 25.0,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (context, index) {
            final anime = _searchResults[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) =>
                        AnimeDetailScreen(anime: anime),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'animeImage_${anime.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          anime.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    anime.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (anime.genres.isNotEmpty)
                    Text(
                      anime.genres.take(2).join(', '),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

