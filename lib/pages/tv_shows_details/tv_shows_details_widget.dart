import '/backend/api_requests/api_calls.dart';
import '/components/movie_card/movie_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/pages/player/player_widget.dart';
import '/pages/category_films/category_films_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'tv_shows_details_model.dart';
export 'tv_shows_details_model.dart';

class TvShowsDetailsWidget extends StatefulWidget {
  const TvShowsDetailsWidget({
    super.key,
    required this.tvId,
    this.serie,
    this.contentType = 'film',
  });

  final String? tvId;
  final dynamic serie;
  final String contentType;

  static String routeName = 'TvShowsDetails';
  static String routePath = '/tvShowsDetails';

  @override
  State<TvShowsDetailsWidget> createState() => _TvShowsDetailsWidgetState();
}

class _TvShowsDetailsWidgetState extends State<TvShowsDetailsWidget> {
  late TvShowsDetailsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isFavorited = false;
  bool _isTogglingFavorite = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TvShowsDetailsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    if (_isTogglingFavorite || widget.contentType == 'serie') return;
    
    setState(() => _isTogglingFavorite = true);
    
    try {
      final filmId = int.tryParse(widget.tvId ?? '0') ?? 0;
      final response = await ToggleFavoriteCall.call(filmId: filmId);
      
      if (response.succeeded) {
        final data = getJsonField(response.jsonBody, r'''$.data''');
        final isFavorited = getJsonField(data, r'''$.is_favorited''') == true;
        setState(() => _isFavorited = isFavorited);
      }
    } catch (e) {
      // Silent error
    } finally {
      setState(() => _isTogglingFavorite = false);
    }
  }

  Future<ApiCallResponse> _getContentDetails() {
    final id = int.tryParse(widget.tvId ?? '0') ?? 0;
    final contentTypeFromSerie = widget.serie != null 
        ? getJsonField(widget.serie, r'''$.content_type''')?.toString() 
        : null;
    final isSerie = contentTypeFromSerie == 'serie' || widget.contentType == 'serie';
    
    if (isSerie) {
      return GetSerieDetailsCall.call(serieId: id);
    } else {
      return GetFilmDetailsCall.call(filmId: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: FutureBuilder<ApiCallResponse>(
          future: _getContentDetails(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              );
            }
            
            final filmData = getJsonField(snapshot.data!.jsonBody, r'''$.data''');

            if (filmData == null) {
              return Center(
                child: Text(
                  'Contenu non trouvé',
                  style: FlutterFlowTheme.of(context).headlineMedium,
                ),
              );
            }
            
            final isSerie = getJsonField(filmData, r'''$.content_type''')?.toString() == 'serie' ||
                widget.contentType == 'serie';
            
            // Initialize favorite state
            final apiIsFavorited = getJsonField(filmData, r'''$.is_favorited''');
            if (apiIsFavorited != null && apiIsFavorited == 1 && !_isFavorited && !_isTogglingFavorite) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_isFavorited) {
                  setState(() => _isFavorited = true);
                }
              });
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroImage(context, filmData, isSerie),
                  _buildSynopsis(context, filmData),
                  if (isSerie) _buildEpisodes(context, filmData),
                  _buildCategories(context, filmData),
                  _buildGenres(context, filmData),
                  _buildCast(context, filmData),
                  _buildCrew(context, filmData),
                  _buildPros(context, filmData),
                  _buildCons(context, filmData),
                  _buildCritics(context, filmData),
                  _buildMoreVideos(context, filmData),
                  const SizedBox(height: 24.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, dynamic filmData, bool isSerie) {
    return Container(
      width: double.infinity,
      height: 400.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Stack(
        children: [
          Image.network(
            functions.cleanStorageUrl(
              getJsonField(filmData, r'''$.film_cover_url''').toString(),
            ),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                child: Icon(
                  Icons.movie,
                  size: 100.0,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            height: 400.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, FlutterFlowTheme.of(context).primaryBackground],
                stops: const [0.0, 1.0],
                begin: const AlignmentDirectional(0.0, -1.0),
                end: const AlignmentDirectional(0, 1.0),
              ),
            ),
          ),
          // Back & Favorite Buttons
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(
                  context,
                  icon: Icons.arrow_back_ios_outlined,
                  onTap: () => Navigator.pop(context),
                ),
                if (!isSerie)
                  _buildCircleButton(
                    context,
                    icon: _isFavorited ? Icons.favorite : Icons.favorite_border,
                    iconColor: _isFavorited ? FlutterFlowTheme.of(context).primary : Colors.white,
                    onTap: _toggleFavorite,
                    isLoading: _isTogglingFavorite,
                  ),
              ],
            ),
          ),
          // Title and Info
          Align(
            alignment: const AlignmentDirectional(0.0, 1.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getJsonField(filmData, r'''$.film_original_title''').toString(),
                    maxLines: 2,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      fontSize: 24.0,
                    ),
                  ),
                  _buildTagline(context, filmData),
                  _buildMetaInfo(context, filmData),
                  _buildActionButtons(context, filmData),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: const BoxDecoration(
          color: Color(0xB3272B30),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
                )
              : Icon(icon, color: iconColor ?? Colors.white, size: 20.0),
        ),
      ),
    );
  }

  Widget _buildTagline(BuildContext context, dynamic filmData) {
    final tagline = getJsonField(filmData, r'''$.film_tagline''').toString();
    if (tagline.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
      child: Text(
        tagline,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
          font: GoogleFonts.poppins(fontStyle: FontStyle.italic),
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget _buildMetaInfo(BuildContext context, dynamic filmData) {
    final runningTime = getJsonField(filmData, r'''$.film_running_time''').toString();
    final version = getJsonField(filmData, r'''$.film_version''').toString();
    final country = getJsonField(filmData, r'''$.country_name''').toString();
    
    final items = <String>[];
    if (runningTime.isNotEmpty) items.add('$runningTime min');
    if (version.isNotEmpty) items.add(version);
    if (country.isNotEmpty) items.add(country);
    
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
      child: Text(
        items.join(' • '),
        style: FlutterFlowTheme.of(context).bodySmall.override(fontSize: 12.0),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic filmData) {
    final trailerUrl = getJsonField(filmData, r'''$.trailer_video_id''')?.toString() ?? '';
    final hasTrailer = trailerUrl.isNotEmpty && trailerUrl != 'javascript:;';
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
      child: Row(
        children: [
          Expanded(
            child: _buildPlayButton(context),
          ),
          if (hasTrailer) ...[
            const SizedBox(width: 12.0),
            _buildTrailerButton(context, trailerUrl),
          ],
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return InkWell(
      onTap: () => _playVideo(context),
      child: Container(
        height: 48.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.play, color: FlutterFlowTheme.of(context).primaryBtnText, size: 20.0),
            const SizedBox(width: 8.0),
            Text(
              'Regarder',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                color: FlutterFlowTheme.of(context).primaryBtnText,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailerButton(BuildContext context, String trailerUrl) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayerWidget(videoUrl: trailerUrl)),
        );
      },
      child: Container(
        height: 48.0,
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: FlutterFlowTheme.of(context).primary, width: 2.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_outlined, color: FlutterFlowTheme.of(context).primary, size: 20.0),
            const SizedBox(width: 8.0),
            Text(
              'Trailer',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                color: FlutterFlowTheme.of(context).primary,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playVideo(BuildContext context) async {
    final filmId = int.tryParse(widget.tvId ?? '0') ?? 0;
    if (filmId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Film introuvable.')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final videoResponse = await GetVideoLinkCall.call(videoId: filmId);
    Navigator.pop(context);

    final responseBody = videoResponse.jsonBody ?? {};
    final hasError = getJsonField(responseBody, r'''$.error''') == true;
    final message = getJsonField(responseBody, r'''$.message''').toString();

    if (!videoResponse.succeeded || hasError) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lecture indisponible'),
          content: Text(message.isNotEmpty ? message : 'La lecture est réservée aux abonnés.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final videoUrl = getJsonField(responseBody, r'''$.data''').toString();
    if (videoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lien vidéo indisponible.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerWidget(videoUrl: videoUrl)),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: FlutterFlowTheme.of(context).titleSmall.override(
        font: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        color: FlutterFlowTheme.of(context).primary,
        fontSize: 18.0,
      ),
    );
  }

  Widget _buildSynopsis(BuildContext context, dynamic filmData) {
    final synopsis = getJsonField(filmData, r'''$.film_synopsis''').toString();
    if (synopsis.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Synopsis'),
          const SizedBox(height: 8.0),
          Text(
            synopsis,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.poppins(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodes(BuildContext context, dynamic filmData) {
    final episodes = getJsonField(filmData, r'''$.episodes''');
    if (episodes == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Épisodes'),
          const SizedBox(height: 8.0),
          ...(episodes as List).map<Widget>((episode) {
            final episodeId = getJsonField(episode, r'''$.id''');
            final season = getJsonField(episode, r'''$.season''')?.toString() ?? '1';
            final episodeNum = getJsonField(episode, r'''$.episode''')?.toString() ?? '1';
            final title = getJsonField(episode, r'''$.title''')?.toString() ?? '';
            final runningTime = getJsonField(episode, r'''$.running_time''')?.toString() ?? '';
            
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
              child: InkWell(
                onTap: () => _playEpisode(context, episodeId),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.play,
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            size: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'S$season E$episodeNum${title.isNotEmpty ? ' - $title' : ''}',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(fontWeight: FontWeight.w600),
                            ),
                            if (runningTime.isNotEmpty)
                              Text(
                                '$runningTime min',
                                style: FlutterFlowTheme.of(context).bodySmall.override(fontSize: 12.0),
                              ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: FlutterFlowTheme.of(context).secondaryText, size: 24.0),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _playEpisode(BuildContext context, dynamic episodeId) async {
    if (episodeId == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final videoResponse = await GetSerieVideoLinkCall.call(
      episodeId: episodeId is int ? episodeId : int.tryParse(episodeId.toString()) ?? 0,
    );
    Navigator.pop(context);

    final responseBody = videoResponse.jsonBody ?? {};
    final hasError = getJsonField(responseBody, r'''$.error''') == true;
    final message = getJsonField(responseBody, r'''$.message''').toString();

    if (!videoResponse.succeeded || hasError) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lecture indisponible'),
          content: Text(message.isNotEmpty ? message : 'La lecture est réservée aux abonnés.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final videoUrl = getJsonField(responseBody, r'''$.data''').toString();
    if (videoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lien vidéo indisponible.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerWidget(videoUrl: videoUrl)),
    );
  }

  Widget _buildCategories(BuildContext context, dynamic filmData) {
    final categories = getJsonField(filmData, r'''$.categories''');
    if (categories == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Catégories'),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: (categories as List).map<Widget>((category) {
              final categoryId = getJsonField(category, r'''$.id''');
              final categoryName = getJsonField(category, r'''$.name''')?.toString() ?? '';
              
              return InkWell(
                onTap: () {
                  if (categoryId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryFilmsWidget(
                          categoryId: categoryId is int ? categoryId : int.tryParse(categoryId.toString()) ?? 0,
                          categoryName: categoryName,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    categoryName,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontSize: 13.0,
                      color: FlutterFlowTheme.of(context).primaryBtnText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenres(BuildContext context, dynamic filmData) {
    final genres = getJsonField(filmData, r'''$.genre_list''').toString();
    if (genres.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Genres'),
          const SizedBox(height: 8.0),
          Text(genres, style: FlutterFlowTheme.of(context).bodyMedium),
        ],
      ),
    );
  }

  Widget _buildCast(BuildContext context, dynamic filmData) {
    final cast = getJsonField(filmData, r'''$.film_cast_name_list''').toString();
    if (cast.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Casting'),
          const SizedBox(height: 8.0),
          Text(cast, style: FlutterFlowTheme.of(context).bodyMedium),
        ],
      ),
    );
  }

  Widget _buildCrew(BuildContext context, dynamic filmData) {
    final crew = getJsonField(filmData, r'''$.film_crew_name_list''').toString();
    if (crew.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Équipe'),
          const SizedBox(height: 8.0),
          Text(crew, style: FlutterFlowTheme.of(context).bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPros(BuildContext context, dynamic filmData) {
    final pros = getJsonField(filmData, r'''$.film_pros''').toString();
    if (pros.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Pourquoi vous aimerez'),
          const SizedBox(height: 8.0),
          Text(pros, style: FlutterFlowTheme.of(context).bodyMedium),
        ],
      ),
    );
  }

  Widget _buildCons(BuildContext context, dynamic filmData) {
    final cons = getJsonField(filmData, r'''$.film_cons''').toString();
    if (cons.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Pourquoi vous n\'aimerez peut-être pas'),
          const SizedBox(height: 8.0),
          Text(cons, style: FlutterFlowTheme.of(context).bodyMedium),
        ],
      ),
    );
  }

  Widget _buildCritics(BuildContext context, dynamic filmData) {
    final critics = getJsonField(filmData, r'''$.critic_list''');
    if (critics == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Critiques'),
          const SizedBox(height: 8.0),
          ...(critics as List).map<Widget>((critic) {
            final criticTitle = getJsonField(critic, r'''$.film_critic_title''')?.toString() ?? '';
            final criticSource = getJsonField(critic, r'''$.artwork_critic_website''')?.toString() ?? '';
            final criticLogo = getJsonField(critic, r'''$.artwork_critic_logotype''')?.toString() ?? '';
            final criticism = getJsonField(critic, r'''$.film_criticism''')?.toString() ?? '';
            final fullReviewLink = getJsonField(critic, r'''$.film_complete_criticism_link''')?.toString() ?? '';
            
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (criticSource.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (criticLogo.isNotEmpty)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Image.network(
                                    criticLogo,
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                criticSource,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontSize: 12.0,
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (criticTitle.isNotEmpty)
                      Text(
                        criticTitle,
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (criticism.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: Text(criticism, style: FlutterFlowTheme.of(context).bodyMedium),
                      ),
                    if (fullReviewLink.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: InkWell(
                          onTap: () async {
                            final uri = Uri.tryParse(fullReviewLink);
                            if (uri != null && await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.open_in_new, size: 16.0, color: FlutterFlowTheme.of(context).primary),
                              const SizedBox(width: 4.0),
                              Text(
                                'Lire la critique complète',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontSize: 13.0,
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMoreVideos(BuildContext context, dynamic filmData) {
    final moreVideos = getJsonField(filmData, r'''$.more_videos_list''');
    if (moreVideos == null) return const SizedBox.shrink();
    
    final videoList = (moreVideos as List).take(10).toList();
    if (videoList.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 0.0, 16.0),
          child: _buildSectionTitle(context, 'Plus de vidéos'),
        ),
        SizedBox(
          height: 224.0,
          child: ListView.builder(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              final videoItem = videoList[index];
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                child: SizedBox(
                  width: 140.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TvShowsDetailsWidget(
                            tvId: getJsonField(videoItem, r'''$.id''').toString(),
                          ),
                        ),
                      );
                    },
                    child: MovieCardWidget(
                      key: Key('KeyMore_${index}_of_${videoList.length}'),
                      imagePath: functions.cleanStorageUrl(
                        getJsonField(videoItem, r'''$.film_cover_url''').toString(),
                      ),
                      title: getJsonField(videoItem, r'''$.film_original_title''').toString(),
                      rating: '',
                      image: functions.cleanStorageUrl(
                        getJsonField(videoItem, r'''$.film_cover_url''').toString(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
