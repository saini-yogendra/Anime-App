import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/animeModel.dart';

class MylistSearch extends SearchDelegate<Anime?> {
  final int currentTab;
  final List<Anime> unwatchedList;
  final List<Anime> watchedList;

  MylistSearch({
    required this.currentTab,
    required this.unwatchedList,
    required this.watchedList,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0D0D),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Search anime...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filtered = _filterList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text('No anime found', style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final anime = filtered[index];
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl: anime.imageUrl,
            height: 50,
            width: 40,
            fit: BoxFit.cover,
          ),
          title: Text(anime.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text(anime.genres.join(', '), style: const TextStyle(color: Colors.white54)),
          onTap: () => close(context, anime),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  List<Anime> _filterList() {
    final list = currentTab == 0 ? unwatchedList : watchedList;
    return list
        .where((anime) => anime.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}