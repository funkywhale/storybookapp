import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const StoryBookApp());
}

class StoryBookApp extends StatelessWidget {
  const StoryBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Storybook',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const StoryBookHome(),
    );
  }
}

class StoryPage {
  final String title;
  final String text;
  final String assetPath;

  const StoryPage({
    required this.title,
    required this.text,
    required this.assetPath,
  });
}

const List<StoryPage> _pages = [
  StoryPage(
    title: 'The Story of Pumpky',
    text:
        'Pumpky was a weird looking pumpkin who had big dreams of becoming a spooky jack-o-lantern.',
    assetPath: 'assets/1.png',
  ),
  StoryPage(
    title: 'Farmer\'s Market',
    text:
        'Farmer Bob was looking for anyone that would buy his strange pumpkin Pumpky.',
    assetPath: 'assets/2.png',
  ),
  StoryPage(
    title: 'Pumpky\'s Lucky Day',
    text:
        'Little Jimmy saw Pumpky and saw his potential. He pleaded with his parents to buy Pumpky.',
    assetPath: 'assets/3.png',
  ),
  StoryPage(
    title: 'Time to go Home',
    text:
        'Little Jimmy and his family decided to buy Pumpky and take him home. They had big plans for him.',
    assetPath: 'assets/4.png',
  ),
  StoryPage(
    title: 'Big Surprise',
    text:
        'Pumpky wasn\'t gonna become a jack-o-lantern. He was gonna be a pie!',
    assetPath: 'assets/5.png',
  ),
  StoryPage(
    title: 'The End of Pumpky',
    text:
        'Little Jimmy and his family enjoyed the delicious pie made from Pumpky.',
    assetPath: 'assets/6.png',
  ),
];

class StoryBookHome extends StatefulWidget {
  const StoryBookHome({super.key});

  @override
  State<StoryBookHome> createState() => _StoryBookHomeState();
}

class _StoryBookHomeState extends State<StoryBookHome> {
  final PageController _controller = PageController();
  int _current = 0;
  late final AudioPlayer _audioPlayer;
  double _volume = 0.8; // 0.0 (muted) .. 1.0 (max)
  bool _isPlaying = false;

  Future<void> _startMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.play(AssetSource('song.mp3'));
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      // ignore errors
    }
  }

  Future<void> _stopMusic() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (_) {}
  }

  Future<void> _pauseMusic() async {
    try {
      await _audioPlayer.pause();
    } catch (_) {}
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _resumeMusic() async {
    try {
      await _audioPlayer.resume();
    } catch (_) {}
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _setVolume(double v) async {
    final newVol = v.clamp(0.0, 1.0);
    setState(() {
      _volume = newVol;
    });
    try {
      await _audioPlayer.setVolume(_volume);
    } catch (_) {}
  }

  void _goTo(int page) {
    if (page < 0 || page >= _pages.length) return;
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMusic();
    });
  }

  @override
  void dispose() {
    _stopMusic();
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, index) {
                  final p = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Center(
                                child: Image.asset(
                                  p.assetPath,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stack) =>
                                      Container(
                                        color: Colors.grey.shade300,
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 48,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          p.text,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _current > 0 ? () => _goTo(_current - 1) : null,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Prev'),
                  ),
                  Row(
                    children: [
                      ...List.generate(_pages.length, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _current == i ? 12 : 8,
                          height: _current == i ? 12 : 8,
                          decoration: BoxDecoration(
                            color: _current == i
                                ? Colors.indigo
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          _volume > 0 ? Icons.volume_up : Icons.volume_off,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (ctx) {
                              double localVol = _volume;
                              return StatefulBuilder(
                                builder: (ctx2, sbSetState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.volume_down),
                                            Expanded(
                                              child: Slider(
                                                value: localVol,
                                                onChanged: (v) {
                                                  sbSetState(
                                                    () => localVol = v,
                                                  );
                                                  _setVolume(v);
                                                },
                                                min: 0.0,
                                                max: 1.0,
                                              ),
                                            ),
                                            const Icon(Icons.volume_up),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          child: const Text('Done'),
                                          onPressed: () =>
                                              Navigator.of(ctx2).pop(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          if (_isPlaying) {
                            _pauseMusic();
                          } else {
                            _resumeMusic();
                          }
                        },
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: _current < _pages.length - 1
                        ? () => _goTo(_current + 1)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Next'),
                    style: TextButton.styleFrom(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
