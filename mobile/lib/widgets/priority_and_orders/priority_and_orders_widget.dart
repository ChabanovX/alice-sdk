import 'package:flutter/material.dart';
import 'priority_widget.dart';
import 'orders_widget.dart';

/// Объединенный виджет для отображения приоритета и заказов
class PriorityAndOrdersWidget extends StatelessWidget {
  /// Значение приоритета для PriorityWidget
  final int priorityValue;

  /// Количество заказов для OrdersWidget
  final int ordersValue;

  /// Сумма заказов для OrdersWidget
  final int ordersAmount;

  const PriorityAndOrdersWidget({
    super.key,
    this.priorityValue = 52,
    this.ordersValue = 0,
    this.ordersAmount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // PriorityWidget
          PriorityWidget(priorityValue: priorityValue),
          // Разделительная линия
          SizedBox(
            width: 26.5,
            height: 56,
            child: Center(
              child: Container(
                width: 0.5,
                height: 40,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          // OrdersWidget
          OrdersWidget(ordersValue: ordersValue, ordersAmount: ordersAmount),
        ],
      ),
    );
  }
}
