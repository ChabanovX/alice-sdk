part of 'navigation.dart';

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
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 82,
        decoration: BoxDecoration(
          color: context.colors.semanticBackground,
          border: Border(
            top: BorderSide(color: context.colors.border, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: OrderButton(
                  state: selectedItem == BottomNavigationItem.orders
                      ? OrderButtonState.active
                      : OrderButtonState.inactive,
                  onTap: () => onItemSelected(BottomNavigationItem.orders),
                ),
              ),
              Expanded(
                child: _buildNavigationButton(
                  context,
                  iconPath: 'assets/icons/wallet_filled.svg',
                  label: 'Деньги',
                  isSelected: selectedItem == BottomNavigationItem.money,
                  onTap: () => onItemSelected(BottomNavigationItem.money),
                ),
              ),
              Expanded(
                child: _buildNavigationButton(
                  context,
                  iconPath: 'assets/icons/chat_bubble_filled.svg',
                  label: 'Общение',
                  isSelected: selectedItem == BottomNavigationItem.chat,
                  onTap: () => onItemSelected(BottomNavigationItem.chat),
                ),
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  return Expanded(
                    child: _buildProfileButton(
                      context,
                      state,
                      isSelected: selectedItem == BottomNavigationItem.profile,
                      onTap: () => onItemSelected(BottomNavigationItem.profile),
                    ),
                  );
                },
              ),
            ],
          ),
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
    return _AnimatedNavigationButton(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
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
              const SizedBox(height: 2),
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
    BuildContext context,
    ProfileState state, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return _AnimatedNavigationButton(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 24,
                  maxHeight: 24,
                ),
                child: UserAvatar(
                  avatarUrl:
                      state is ProfileUserState ? state.user.urlAvatar : '',
                ),
              ),
              const SizedBox(height: 2),
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

class _AnimatedNavigationButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedNavigationButton({
    required this.child,
    required this.onTap,
  });

  @override
  State<_AnimatedNavigationButton> createState() =>
      _AnimatedNavigationButtonState();
}

class _AnimatedNavigationButtonState extends State<_AnimatedNavigationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
