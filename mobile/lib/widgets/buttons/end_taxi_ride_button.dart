part of 'buttons.dart';

/// TODO: must refactor it to use parent's width
/// 
/// It might be hard, use LayoutBuilder to calculate width.
/// But without it code smells.
class EndTaxiRideButton extends StatelessWidget {
  const EndTaxiRideButton({super.key, required this.onSlideComplete});

  final VoidCallback? onSlideComplete;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsetsGeometry.all(0),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(37),
        ),
      ),
      onPressed: () {},
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                'На месте',
                style: context.textStyles.title.copyWith(
                  color: context.colors.controlMain,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsetsGeometry.all(6),
          
            child: SlideActionButton(
              onSlideComplete: () {
                onSlideComplete?.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EndTaxiRideButtonWithoutAnim extends StatefulWidget {
  final VoidCallback? onSlideComplete;

  const EndTaxiRideButtonWithoutAnim(
      {super.key, required this.onSlideComplete});

  @override
  State<EndTaxiRideButtonWithoutAnim> createState() =>
      _EndTaxiRideButtonWithoutAnimState();
}

class _EndTaxiRideButtonWithoutAnimState
    extends State<EndTaxiRideButtonWithoutAnim> {
  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsetsGeometry.all(0),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(37),
        ),
      ),
      onPressed: () {
        setState(() {
          isComplete = !isComplete;
          if (isComplete) {
            widget.onSlideComplete?.call();
          }
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text('На месте',
                  style: context.textStyles.title.copyWith(
                    color: context.colors.controlMain,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsetsGeometry.all(6),
            child: (isComplete)
                ? const SlideButtonStretchedState()
                : const SlideButtonPressedState(),
          ),
        ],
      ),
    );
  }
}
