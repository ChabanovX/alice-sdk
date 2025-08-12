part of 'buttons.dart';

class EndTaxiRideButton extends StatelessWidget {
  const EndTaxiRideButton({
    super.key,
    required this.onSlideComplete}
  );

  final VoidCallback? onSlideComplete;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsetsGeometry.all(0),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
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
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(6),
            child: SlideActionButton(onSlideComplete: () {onSlideComplete?.call();},),
          ),
        ],
      ),
    );
  }
}

class EndTaxiRideButtonWithoutAnim extends StatefulWidget {
  final VoidCallback? onSlideComplete;

  const EndTaxiRideButtonWithoutAnim({
    super.key,
    required this.onSlideComplete
  });

  @override
  State<EndTaxiRideButtonWithoutAnim> createState() => _EndTaxiRideButtonWithoutAnimState();
}

class _EndTaxiRideButtonWithoutAnimState extends State<EndTaxiRideButtonWithoutAnim> {
  bool isComplite = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsetsGeometry.all(0),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
        ),
      ),
      onPressed: () {
        setState(() {
          isComplite = !isComplite;
          if (isComplite){
            widget.onSlideComplete?.call();
          }
        });
        },
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                  'На месте',
                  style: context.textStyles.title.copyWith(
                    color: context.colors.controlMain,
                    fontWeight: FontWeight.w500,
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(6),
            child: (isComplite)
                ? SlideButtonStretchedState()
                : SlideButtonPressedState(),
          ),
        ],
      ),
    );
  }
}