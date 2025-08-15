part of '../presentation.dart';

class StoriesSlider extends StatelessWidget {
  StoriesSlider({super.key});
  
  final List<String> stories = [
    'assets/random/storyPreview_1.svg',
    'assets/random/storyPreview_2.svg',
    'assets/random/storyPreview_3.svg',
    'assets/random/storyPreview_4.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 12, bottom: 15),
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              NavigationManager.pushNamed(
                Routes.stories,
                navigator: NavigationManager.chatNavigator,
                arguments: StoriesArgs(startIndex: index),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(stories[index], height: 200,),
            ),
          );
        },
      ),
    );
  }
}
