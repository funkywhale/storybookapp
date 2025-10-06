import 'package:flutter/material.dart';

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
    title: 'The Little Cloud',
    text:
        'A small cloud drifted across a bright blue sky. It wondered where it would travel next.',
    assetPath: 'assets/1.png',
  ),
  StoryPage(
    title: 'Curious Fox',
    text:
        'A curious fox peeked from behind the tall grass and sniffed the morning air.',
    assetPath: 'assets/2.png',
  ),
  StoryPage(
    title: 'Starry Night',
    text:
        'When the sun went down, stars sprinkled the sky like silver confetti.',
    assetPath: 'assets/3.png',
  ),
  StoryPage(
    title: 'Mysterious Tree',
    text:
        'An old tree stood on the hill, its branches telling tales of long ago.',
    assetPath: 'assets/4.png',
  ),
  StoryPage(
    title: 'Gentle River',
    text: 'A river whispered as it moved, carrying stories downstream.',
    assetPath: 'assets/5.png',
  ),
  StoryPage(
    title: 'Home at Dusk',
    text:
        'Lights twinkled in windows as the day closed and everyone returned home.',
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

  void _goTo(int page) {
    if (page < 0 || page >= _pages.length) return;
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar to maximize vertical space for the images.
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
                    children: List.generate(_pages.length, (i) {
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
