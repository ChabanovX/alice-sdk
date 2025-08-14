import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Виджет для отображения количества и суммы заказов с иконкой и значением
class OrdersWidget extends StatelessWidget {
  final int ordersValue;
  final int ordersAmount;

  const OrdersWidget({super.key, this.ordersValue = 0, this.ordersAmount = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 160,
      height: 56,
      child: Row(
        children: [
          // Левый SizedBox с иконкой кошелька
          SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/wallet_filled.svg',
                width: 32,
                height: 32,
              ),
            ),
          ),
          // Правый SizedBox с текстом и значением
          SizedBox(
            width: 88,
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Верхний Row с текстом "заказов" и иконкой
                Row(
                  children: [
                    Text(
                      '$ordersValue заказов',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'YandexSansText',
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SvgPicture.asset(
                        'assets/icons/chevron_right_rounded.svg',
                        width: 6.5,
                        height: 11,
                      ),
                    ),
                  ],
                ),
                // Нижний Text с значением суммы заказов
                Text(
                  '$ordersAmount ₽',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'YandexSansText',
                    letterSpacing: -1,
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
