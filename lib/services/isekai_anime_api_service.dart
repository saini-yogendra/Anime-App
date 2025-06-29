import 'api_base_service.dart';
import '../model/animeModel.dart';

class IsekaiAnimeService extends BaseAnimeService {
  Future<Map<String, dynamic>> fetchIsekaiAnimes({String? url}) async {
    try {
      final String fetchUrl = url ??
          'https://api.myanimelist.net/v2/anime?genres=62&q=isekai';


      final result = await fetchAnimesWithPaging(fetchUrl);

      final List<Anime> filtered = List<Anime>.from(result['animes']).where((anime) {
        return anime.genres.any((genre) => genre.toLowerCase().contains('isekai'));
      }).toList();

      return {
        'animes': filtered,
        'nextUrl': result['nextUrl'],
      };
    } catch (e) {
      rethrow;
    }
  }
}
