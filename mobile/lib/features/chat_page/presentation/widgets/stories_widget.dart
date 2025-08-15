part of '../presentation.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage(
      {super.key, required this.slideCount, this.startIndex = 0});

  final int slideCount;
  final int startIndex;

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late int slideIndex;

  @override
  void initState() {
    slideIndex = widget.startIndex;
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward().then((_) {
      controller.reset();
      slideIndex++;
      if (slideIndex >= widget.slideCount) {
        Navigator.pop(context);
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
          child: Stack(
            children: [
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final tapPosition = details.globalPosition.dx;
                  if (tapPosition < screenWidth / 2) {
                    if (slideIndex > 0) {
                      slideIndex--;
                      controller.reset();
                    }
                  } else {
                    slideIndex++;
                    if (slideIndex >= widget.slideCount) {
                      Navigator.pop(context);
                    }
                    controller.reset();
                  }
                },
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      spacing: 5.0,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        widget.slideCount,
                        (index) => Flexible(
                          flex: 1,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(20),
                            minHeight: 4,
                            backgroundColor: context.colors.semanticLine,
                            color: context.colors.textMiror,
                            value: (slideIndex == index) ? controller.value : 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                AppIcons.like,
                                height: 50,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                AppIcons.dislike,
                                height: 50,
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: SvgPicture.asset(
                              AppIcons.crossL,
                              height: 30,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(child: Text(slideIndex.toString())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
