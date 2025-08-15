part of 'components.dart';

class EndOrderWidget extends StatelessWidget {
  const EndOrderWidget({
    required this.roadCost,
    required this.bonus,
    required this.income,
    required this.currency,
    this.widgetHeight = 120.0,
    super.key,
  });

  final String roadCost;
  final String bonus;
  final String income;
  final String currency;
  final double widgetHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 28,
                child: Container(
                  height: widgetHeight,
                  decoration: BoxDecoration(
                    color: const Color(0x1A5C5A57),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 18, top: 14, bottom: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$currency $income',
                          style: context.textStyles.boldBig
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Получите наличными',
                          style: context.textStyles.mediumBig
                              .copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: widgetHeight,
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          color: context.colors.semanticBackground,
                        ),
                      ),
                      Flexible(
                        child: Stack(
                          children: [
                            Container(
                              color: const Color(0x1A5C5A57),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(8),
                                ),
                                color: context.colors.semanticBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          color: const Color(0x1A5C5A57),
                        ),
                      ),
                      Flexible(
                        child: Stack(
                          children: [
                            Container(
                              color: const Color(0x1A5C5A57),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                color: context.colors.semanticBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: context.colors.semanticBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 14,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: widgetHeight,
                    color: const Color(0x1A5C5A57),
                    child: SvgPicture.asset(
                      'assets/random/guest_with_cash.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Выручка',
                  style: context.textStyles.boldMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$currency $roadCost',
                  style: context.textStyles.boldMedium
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Бонусы',
                  style: TextStyle(
                    color: Color(0xff4471e4),
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$currency $bonus',
                  style: const TextStyle(
                    color: Color(0xff4471e4),
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
