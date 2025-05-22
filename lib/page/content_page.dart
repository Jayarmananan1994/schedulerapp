import 'package:flutter/cupertino.dart';

class ContentPage extends StatelessWidget {
  final int tabIndex;
  const ContentPage({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List<String>.generate(
      20,
      (i) => "Item ${i + 1} on Tab ${tabIndex + 1}",
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          _getTitleForTab(tabIndex),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false, // To avoid overlap with the tab bar
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6.resolveFrom(context),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Text(items[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitleForTab(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Search';
      case 2:
        return 'Camera';
      case 3:
        return 'Likes';
      case 4:
        return 'Profile';
      default:
        return 'Tab ${index + 1}';
    }
  }
}
