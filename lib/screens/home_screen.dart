import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const HomeScreen({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SkyQuest!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'Location':
                  // TODO: Implement location picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location clicked')),
                  );
                  break;
                case 'Forecast':
                  // TODO: Implement forecast screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Forecast clicked')),
                  );
                  break;
                case 'Share':
                  // TODO: Implement share feature
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share clicked')),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Location',
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 20),
                    SizedBox(width: 8),
                    Text('Location'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'Forecast',
                child: Row(
                  children: [
                    Icon(Icons.view_list, size: 20),
                    SizedBox(width: 8),
                    Text('Forecast'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'Share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black87, Colors.deepPurpleAccent.shade700]
                : [Colors.blue.shade200, Colors.indigo.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud,
                    size: 100,
                    color: isDark ? Colors.tealAccent : Colors.blueAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '28°C',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pune, Maharashtra',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
