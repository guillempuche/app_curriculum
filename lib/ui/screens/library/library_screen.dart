import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../common_libs.dart';

final List<String> categories = [
  'Instagram',
  'LinkedIn',
  'Creator Economy',
  'Games',
  'eCommerce',
  'Reddit',
  'Snapchat',
  'Generative AI'
];

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<String> selectedCategories = [];

  late List<Recommendation> cards;

  @override
  void initState() {
    super.initState();
    cards = List.generate(
      32,
      (index) => Recommendation(
        categoryId: categories[index % categories.length],
        avatarUrl: 'https://example.com/avatar_$index.jpg',
        title: 'Title $index',
        description: 'Description for card $index',
        importance: Importance.values[index % Importance.values.length],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return VerticalSwipeNavigator(
      backDirection: TransitionDirection.bottomToTop,
      goBackPath: ScreenPaths.projects,
      child: Container(
        color: $styles.colors.black,
        child: Column(
          children: [
            Gap($styles.insets.xxl),
            Gap($styles.insets.xxl),

            // Filters
            Material(
              child: Container(
                height: 100, // Adjust based on your needs
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: IntrinsicWidth(
                        child: FilterChip(
                          label: Text(categories[index]),
                          selected: selectedCategories.contains(categories[index]),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedCategories.add(categories[index]);
                              } else {
                                selectedCategories.remove(categories[index]);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Cards
            Expanded(
              child: MasonryGridView.count(
                itemCount: cards.length,
                crossAxisCount: isDesktop ? 2 : 1,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                itemBuilder: (BuildContext context, int index) {
                  final recommendation = cards[index];
                  if (selectedCategories.isEmpty || selectedCategories.contains(recommendation.categoryId)) {
                    return Card(
                      child: Column(
                        children: [
                          // CircleAvatar(
                          //     backgroundImage:
                          //         NetworkImage(recommendation.avatarUrl)),
                          Text(recommendation.title),
                          Text(recommendation.description),
                        ],
                      ),
                    );
                  } else {
                    return Container(); // Empty container for non-matching items
                  }
                },

                // staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Importance { low, medium, high }

class Recommendation {
  Recommendation({
    required this.categoryId,
    required this.title,
    required this.description,
    required this.importance,
    this.avatarUrl,
  });

  final String categoryId;
  final String title;
  final String description;
  final Importance importance;
  final String? avatarUrl;
}
