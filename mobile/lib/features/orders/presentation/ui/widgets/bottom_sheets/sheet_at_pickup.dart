part of '../../ui.dart';

class SheetAtPickup extends StatelessWidget {
  const SheetAtPickup({super.key});

  @override
  Widget build(BuildContext context) {
    // Since we exactly know the height min/max visible.
    const minVisibleHeight = 222.0;
    const maxVisibleHeight = minVisibleHeight + 98 + 64;

    return DraggableWindow(
      overlayWidget: _buildOverlay(context),
      childPinned: _buildPinned(context),
      innerWidgetBuilder: _buildInnerWidget,
      minVisibleHeight: minVisibleHeight,
      maxVisibleHeight: maxVisibleHeight,
      overlayGap: 8.0,
    );
  }

  Widget _buildPinned(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsetsGeometry.fromLTRB(8, 16, 8, 8),
      child: EndTaxiRideButton(onSlideComplete: () {}),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    const aliceSize = 56.0;
    const alicePadding = EdgeInsets.only(right: 12.0);

    return const Padding(
      padding: alicePadding,
      child: AliceWidget(
        messageText: 'Расскажу про детали поездки',
        size: aliceSize,
      ),
    );
  }

  Widget _buildInnerWidget(BuildContext context, ScrollController sc) {
    // TODO: add to context.colors
    final grey = Theme.of(context).colorScheme.surfaceDim;

    final avatarBox = Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(16, 8, 8, 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset('assets/images/polina_icon.png'),
          Positioned(
            right: -8,
            top: -8,
            child: SvgPicture.asset('assets/icons/icon_arrow_up.svg'),
          ),
        ],
      ),
    );

    final textBox = Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 9.5, 0, 13.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Забрать Полину',
              style: context.textStyles.boldMedium,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Комфорт+',
              style: context.textStyles.medium,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );

    final arrowBox = Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(8, 8, 16, 8),
      child: SvgPicture.asset(
        'assets/icons/fork_right.svg',
        height: 40,
        width: 40,
      ),
    );

    final takePassengerBox = SizedBox(
      height: 68,
      child: Row(
        children: [avatarBox, textBox, arrowBox],
      ),
    );

    const optionsBox = Row(
      children: [
        SizedBox(width: 12),
        CardPaymentWidget(),
        SizedBox(width: 4),
        KidsChairTag(),
      ],
    );

    final buttonsRows = Container(
      height: 98,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          const SizedBox(width: 8),
          _buildWeirdButton(
            context,
            'Сообщение',
            'assets/icons/msg_icon.svg',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _buildWeirdButton(
            context,
            'Звонок',
            'assets/icons/phone_icon.svg',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _buildWeirdButton(
            context,
            'Конфликт',
            'assets/icons/flasher_filled.svg',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _buildWeirdButton(
            context,
            'Отмена',
            'assets/icons/no_icon.svg',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
    );

    final contractBox = Container(
      padding: const EdgeInsets.all(4.0),
      height: 56,
      color: grey,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: SvgPicture.asset(
              'assets/icons/Union.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
          Text(
            'Договор фрахта',
            style: context.textStyles.regular,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 8, 16),
            child: SvgPicture.asset(
              'assets/icons/chevron_right.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        takePassengerBox,
        optionsBox,
        buttonsRows,
        contractBox,
      ],
    );
  }

  Widget _buildWeirdButton(
    BuildContext context,
    String title,
    String path, {
    required VoidCallback onPressed,
  }) {
    final grey = Theme.of(context).colorScheme.surfaceDim;

    final box = SizedBox(
      height: 74,
      child: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: grey,
              ),
              child: Center(
                child: SvgPicture.asset(path, height: 24, width: 24),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: context.textStyles.mediumSmall.copyWith(
              color: context.colors.text,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: box,
      ),
    );
  }
}
