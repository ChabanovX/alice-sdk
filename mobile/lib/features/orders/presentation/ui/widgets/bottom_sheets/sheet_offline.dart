part of '../../ui.dart';

class SheetOffline extends StatelessWidget {
  final OrdersBloc bloc;

  const SheetOffline({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return PanelContainer(
      collapsedFraction: 0.22,
      expandedFraction: 0.86,
      overlay: _CenterRightOverlay(
        center: _FloatingPillButton(
          label: 'На линию',
          onPressed: () {
            print('object');
            bloc.add(GoOnlinePressed());
          },
        ),
        right: SvgPicture.asset('assets/random/r_alice.svg'),
      ),
      builder: (context, sc) => _buildSheetOffline(),
    );
  }

  Widget _buildSheetOffline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 64,
          child: SvgPicture.asset(
            'assets/random/r_prioritet_orders.svg',
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 64,
          child: SvgPicture.asset(
            'assets/random/r_good_to_know.svg',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

class _FloatingPillButton extends StatelessWidget {
  const _FloatingPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.horizontalPadding = 24,
    this.textColor = Colors.black,
    this.borderWidth = 2.0,
    this.borderColor = Colors.white,
  });

  final String label;
  final VoidCallback onPressed;
  final double height;
  final double horizontalPadding;
  final Color textColor;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height / 2);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(borderRadius: radius),
        child: Ink(
          height: height,
          width: 140,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: ShapeDecoration(
            color: context.colors.controlMain,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: borderColor, width: borderWidth),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CenterRightOverlay extends StatelessWidget {
  const _CenterRightOverlay({
    super.key,
    required this.center,
    required this.right,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final Widget center; // большая кнопка
  final Widget right; // круглая кнопка справа
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: padding,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(alignment: Alignment.center, child: center),
            Align(alignment: Alignment.centerRight, child: right),
          ],
        ),
      ),
    );
  }
}
