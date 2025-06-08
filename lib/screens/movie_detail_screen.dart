import 'package:flutter/material.dart';
import '../models/movie_detail.dart';
import '../services/movie_service.dart';
import 'video_player_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final String slug;

  const MovieDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieService _movieService = MovieService();
  MovieDetailResponse? _movieDetailResponse;
  bool _isLoading = true;
  String? _error;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadMovieDetail();
  }

  Future<void> _loadMovieDetail() async {
    try {
      final movieDetailResponse = await _movieService.getMovieDetail(widget.slug);
      setState(() {
        _movieDetailResponse = movieDetailResponse;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _movieDetailResponse == null
                  ? const Center(child: Text('No movie details found'))
                  : CustomScrollView(
                      slivers: [
                        _buildAppBar(),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMovieInfo(),
                                const SizedBox(height: 16),
                                _buildDescription(),
                                const SizedBox(height: 16),
                                _buildCategories(),
                                const SizedBox(height: 16),
                                _buildCast(),
                                const SizedBox(height: 16),
                                _buildEpisodes(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildAppBar() {
    final movie = _movieDetailResponse!.movie;
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo() {
    final movie = _movieDetailResponse!.movie;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.originName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              '${movie.voteAverage.toStringAsFixed(1)} (${movie.voteCount} votes)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 16),
            Icon(Icons.calendar_today, color: Colors.grey, size: 20),
            const SizedBox(width: 4),
            Text(
              movie.year.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 16),
            Icon(Icons.access_time, color: Colors.grey, size: 20),
            const SizedBox(width: 4),
            Text(
              movie.time,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.high_quality, color: Colors.grey, size: 20),
            const SizedBox(width: 4),
            Text(
              movie.quality,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 16),
            Icon(Icons.language, color: Colors.grey, size: 20),
            const SizedBox(width: 4),
            Text(
              movie.lang,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          movie.episodeCurrent,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.green,
              ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    final movie = _movieDetailResponse!.movie;
    final content = movie.content.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nội dung',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          firstChild: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          crossFadeState: _isExpanded 
              ? CrossFadeState.showSecond 
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        if (content.length > 150) // Chỉ hiện nút khi nội dung dài
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            icon: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              _isExpanded ? 'Thu gọn' : 'Xem thêm',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategories() {
    final movie = _movieDetailResponse!.movie;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thể loại',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: movie.categories.map((category) {
            return Chip(
              label: Text(category.name),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          'Quốc gia',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: movie.countries.map((country) {
            return Chip(
              label: Text(country.name),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCast() {
    final movie = _movieDetailResponse!.movie;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Diễn viên',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: movie.actors.map((actor) {
            return Chip(
              label: Text(actor),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Đạo diễn',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: movie.directors.map((director) {
            return Chip(
              label: Text(director),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEpisodes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh sách tập',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        DefaultTabController(
          length: _movieDetailResponse!.episodes.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: _movieDetailResponse!.episodes.map((episode) {
                  return Tab(text: episode.serverName);
                }).toList(),
              ),
              SizedBox(
                height: 400,
                child: TabBarView(
                  children: _movieDetailResponse!.episodes.map((episode) {
                    return ListView.builder(
                      itemCount: episode.items.length,
                      itemBuilder: (context, index) {
                        final item = episode.items[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.filename),
                          trailing: const Icon(Icons.play_circle_outline),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  episode: item,
                                  movieName: _movieDetailResponse!.movie.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 