part of '../../../presentation.dart';

class IconsRowStack extends StatelessWidget {
  const IconsRowStack({super.key, required this.icons});

  final List<String> icons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: icons.reversed
            .map(
              (icon) => Align(
                widthFactor: 0.35,
                child: SvgPicture.asset(
                  icon,
                  width: 64,
                  height: 64,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
