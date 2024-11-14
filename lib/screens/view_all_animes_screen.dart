import 'package:flutter/material.dart';

import '../api/get_anime_by_ranking_type_api.dart';
import '../views/ranked_animes_list_view.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';

class ViewAllAnimesScreen extends StatefulWidget {
  const ViewAllAnimesScreen({
    super.key,
    required this.rankingType,
    required this.label,
  });

  final String rankingType;
  final String label;

  static const routeName = '/view-all-animes';

  @override
  State<ViewAllAnimesScreen> createState() => _ViewAllAnimesScreenState();
}

class _ViewAllAnimesScreenState extends State<ViewAllAnimesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use widget.label to access the label property
        title: Text(widget.label),
      ),
      body: FutureBuilder(
        future: getAnimeByRankingTypeApi(
          rankingType: widget.rankingType,
          limit: 500,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          if (snapshot.hasData) {
            final animes = snapshot.data!;

            return RankedAnimesListView(
              animes: animes,
            );
          }

          return ErrorScreen(
            error: snapshot.error?.toString() ?? 'Unknown error occurred',
          );
        },
      ),
    );
  }
}
