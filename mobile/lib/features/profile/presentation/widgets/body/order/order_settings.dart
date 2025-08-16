part of '../../../presentation.dart';

class OrderSettings extends StatelessWidget {
  const OrderSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          OrderSettingsItem(title: 'Тарифы и опции', description: '5 из 10'),
          OrderSettingsItem(title: 'Режим дохода', description: 'Эффективный'),
          OrderSettingsItem(title: 'Оплата', description: 'Наличные и карта'),
        ],
      ),
    );
  }
}
