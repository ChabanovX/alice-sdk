part of '../../ui.dart';

class SheetOnlineIdle extends StatelessWidget {
  const SheetOnlineIdle({super.key});

  @override
  Widget build(BuildContext context) {
    return PanelContainer(
      overlay: _JustRight(
        right: SvgPicture.asset('assets/random/r_alice.svg'),
      ),
      builder: (context, sc) => _buildSheetOnline(),
    );
  }
}

Widget _buildSheetOnline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 64,
          child: SvgPicture.asset(
            'assets/random/r_prioritet_orders.svg',
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 64,
          child: SvgPicture.asset(
            'assets/random/r_good_to_know.svg',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

class _JustRight extends StatelessWidget {
  const _JustRight({
    required this.right,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

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
            Align(alignment: Alignment.centerRight, child: right),
          ],
        ),
      ),
    );
  }
}
