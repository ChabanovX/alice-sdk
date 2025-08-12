import 'package:flutter/material.dart';
import 'order_button.dart';

class OrderButtonExample extends StatelessWidget {
  const OrderButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пример OrderButton')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Состояния OrderButton:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Активное состояние
            const Text('1. Активное состояние (100%):'),
            const SizedBox(height: 8),
            OrderButton(
              state: OrderButtonState.active,
              onTap: () => print('Активная кнопка нажата'),
            ),
            const SizedBox(height: 20),

            // Неактивное состояние
            const Text('2. Неактивное состояние (30%):'),
            const SizedBox(height: 8),
            OrderButton(
              state: OrderButtonState.inactive,
              onTap: () => print('Неактивная кнопка нажата'),
            ),
            const SizedBox(height: 20),

            // Состояние с бейджем
            const Text('3. Состояние с бейджем (30% + бейдж):'),
            const SizedBox(height: 8),
            OrderButton(
              state: OrderButtonState.withBadge,
              countBadge: 5,
              onTap: () => print('Кнопка с бейджем нажата'),
            ),
            const SizedBox(height: 20),

            // Состояние с большим количеством в бейдже
            const Text('4. С большим количеством в бейдже:'),
            const SizedBox(height: 8),
            OrderButton(
              state: OrderButtonState.withBadge,
              countBadge: 99,
              onTap: () => print('Кнопка с большим бейджем нажата'),
            ),
          ],
        ),
      ),
    );
  }
}
