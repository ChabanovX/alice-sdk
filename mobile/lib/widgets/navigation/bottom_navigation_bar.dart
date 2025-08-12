import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';
import '../orders/order_button.dart';

enum BottomNavigationItem { orders, money, chat, profile }

class CustomBottomNavigationBar extends StatelessWidget {
  final BottomNavigationItem selectedItem;
  final Function(BottomNavigationItem) onItemSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 82,
      color: context.colors.semanticBackground,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            // Кнопка "Заказы" - 1/4 ширины экрана
            Expanded(
              child: OrderButton(
                state: selectedItem == BottomNavigationItem.orders
                    ? OrderButtonState.active
                    : OrderButtonState.inactive,
                onTap: () => onItemSelected(BottomNavigationItem.orders),
              ),
            ),
            // Кнопка "Деньги" - 1/4 ширины экрана
            Expanded(
              child: _buildNavigationButton(
                context,
                iconPath: 'assets/icons/wallet_filled.svg',
                label: 'Деньги',
                isSelected: selectedItem == BottomNavigationItem.money,
                onTap: () => onItemSelected(BottomNavigationItem.money),
              ),
            ),
            // Кнопка "Общение" - 1/4 ширины экрана
            Expanded(
              child: _buildNavigationButton(
                context,
                iconPath: 'assets/icons/chat_bubble_filled.svg',
                label: 'Общение',
                isSelected: selectedItem == BottomNavigationItem.chat,
                onTap: () => onItemSelected(BottomNavigationItem.chat),
              ),
            ),
            // Кнопка "Профиль" - 1/4 ширины экрана
            Expanded(
              child: _buildProfileButton(
                context,
                isSelected: selectedItem == BottomNavigationItem.profile,
                onTap: () => onItemSelected(BottomNavigationItem.profile),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required String iconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _getIconColor(context, isSelected),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getTextColor(context, isSelected),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(
    BuildContext context, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: isSelected ? 1.0 : 0.3,
                child: Image.asset(
                  'assets/icons/user_avatar.png',
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Профиль',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getTextColor(context, isSelected),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconColor(BuildContext context, bool isSelected) {
    return isSelected
        ? context.colors.text
        : context.colors.text.withValues(alpha: 0.3);
  }

  Color _getTextColor(BuildContext context, bool isSelected) {
    return isSelected
        ? context.colors.text
        : context.colors.text.withValues(alpha: 0.3);
  }
}
