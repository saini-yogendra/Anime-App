import 'api_base_service.dart';

class SeasonalAnimeService extends BaseAnimeService {
  Future<Map<String, dynamic>> fetchSeasonalAnimes() async {
    final now = DateTime.now();
    final year = now.year;
    final season = _getSeason(now.month);
    final url = 'https://api.myanimelist.net/v2/anime/season/$year/$season?fields=alternative_titles,main_picture,genres';
    return await fetchAnimesWithPaging(url);
  }

  String _getSeason(int month) {
    if (month >= 1 && month <= 3) return 'winter';
    if (month >= 4 && month <= 6) return 'spring';
    if (month >= 7 && month <= 9) return 'summer';
    return 'fall';
  }
}
