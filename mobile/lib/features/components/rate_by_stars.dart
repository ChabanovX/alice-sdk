part of 'components.dart';

class RateByStars extends StatefulWidget {
  const RateByStars({super.key, this.onChanged, this.height = 50.0});

  final ValueChanged<int>? onChanged;
  final double height;

  @override
  State<RateByStars> createState() => _RateByStarsState();
}

class _RateByStarsState extends State<RateByStars> {
  int rate = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        5,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              rate = index;
              widget.onChanged?.call(index + 1);
            });
          },
          child: SvgPicture.asset(
            AppIcons.starFilled,
            colorFilter: ColorFilter.mode(
                (rate >= index)
                    ? context.colors.starYellow
                    : const Color(0x1A5C5A57),
                BlendMode.srcIn),
            height: widget.height,
          ),
        ),
      ),
    );
  }
}
