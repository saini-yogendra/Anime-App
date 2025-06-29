class Anime {
  final int id;
  final String title;
  final String imageUrl;
  final List<String> genres;
  final String? synopsis;
  final double? mean;
  final int? rank;
  final int? popularity;
  final int? numEpisodes;
  final String? alternativeTitle; // ✅ NEW FIELD

  Anime({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.genres,
    this.synopsis,
    this.mean,
    this.rank,
    this.popularity,
    this.numEpisodes,
    this.alternativeTitle, // ✅ ADD TO CONSTRUCTOR
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    final String fallbackTitle = json['title'] ?? '';
    final String englishTitle = json['alternative_titles']?['en'] ?? '';
    final String altTitle = json['alternative_titles']?['ja'] ?? '';

    // Handle image from either API or saved JSON
    final String imageUrl = json['main_picture']?['large'] ??
        json['main_picture']?['medium'] ??
        json['imageUrl'] ?? '';

    // Parse genres
    final genresData = json['genres'];
    List<String> parsedGenres = [];

    if (genresData is List) {
      if (genresData.isNotEmpty) {
        if (genresData.first is Map) {
          parsedGenres = genresData.map((g) => g['name'].toString()).toList();
        } else if (genresData.first is String) {
          parsedGenres = List<String>.from(genresData);
        }
      }
    }

    return Anime(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: englishTitle.isNotEmpty ? englishTitle : fallbackTitle,
      imageUrl: imageUrl,
      genres: parsedGenres,
      synopsis: json['synopsis'],
      mean: (json['mean'] is num) ? (json['mean'] as num).toDouble() : null,
      rank: json['rank'] is int ? json['rank'] : null,
      popularity: json['popularity'] is int ? json['popularity'] : null,
      numEpisodes: json['num_episodes'] is int
          ? json['num_episodes']
          : json['numEpisodes'],
      alternativeTitle: altTitle.isNotEmpty ? altTitle : null, // ✅ SET ALT TITLE
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'genres': genres,
      'synopsis': synopsis,
      'mean': mean,
      'rank': rank,
      'popularity': popularity,
      'numEpisodes': numEpisodes,
      'alternativeTitle': alternativeTitle, // ✅ ADD TO JSON
    };
  }
}
