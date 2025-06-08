import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../models/movie_detail.dart';

class VideoPlayerScreen extends StatefulWidget {
  final EpisodeItem episode;
  final String movieName;

  const VideoPlayerScreen({
    super.key,
    required this.episode,
    required this.movieName,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _error;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      if (!mounted) return;

      // Kiểm tra kết nối internet
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          throw Exception('Không có kết nối internet');
        }
      } on SocketException catch (_) {
        throw Exception('Không có kết nối internet');
      }

      // Thử phát video từ link m3u8
      final videoUrl = widget.episode.linkM3u8;
      if (videoUrl.isEmpty) {
        throw Exception('Không tìm thấy link video');
      }

      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Referer': 'https://example.com/',
        },
      );

      // Đặt timeout cho việc khởi tạo video
      await Future.any([
        _videoPlayerController!.initialize(),
        Future.delayed(const Duration(seconds: 10), () {
          throw Exception('Không thể tải video (timeout)');
        }),
      ]);

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return _buildErrorWidget(errorMessage);
        },
        // Thêm các tùy chọn phát video
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        // Thêm các nút điều khiển
        additionalOptions: (BuildContext context) {
          return <OptionItem>[
            OptionItem(
              onTap: (BuildContext context) => _openInBrowser(),
              iconData: Icons.open_in_browser,
              title: 'Mở trong trình duyệt',
            ),
          ];
        },
      );

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 42,
          ),
          const SizedBox(height: 16),
          Text(
            'Không thể phát video\n$errorMessage',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
                _isInitialized = false;
              });
              _initializePlayer();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _openInBrowser,
            icon: const Icon(Icons.open_in_browser),
            label: const Text('Mở trong trình duyệt'),
          ),
        ],
      ),
    );
  }

  Future<void> _openInBrowser() async {
    final Uri url = Uri.parse(widget.episode.linkEmbed);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể mở trình duyệt'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.movieName,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              widget.episode.name,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
                _isInitialized = false;
              });
              _initializePlayer();
            },
            tooltip: 'Tải lại video',
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openInBrowser,
            tooltip: 'Mở trong trình duyệt',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget(_error!)
              : _isInitialized && _chewieController != null
                  ? Center(child: Chewie(controller: _chewieController!))
                  : const Center(child: CircularProgressIndicator()),
    );
  }
} 