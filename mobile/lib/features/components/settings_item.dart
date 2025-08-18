part of 'components.dart';

enum SettingType {
  switcher,
  button,
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.title,
    required this.type,
    this.icon,
    this.description,
    this.onTap,
    this.switchValue,
    this.onSwitchChanged,
    this.optionalDescriptionBeforeChevron,
  });

  final String title;
  final String? icon;
  final String? description;
  final String? optionalDescriptionBeforeChevron;
  final SettingType type;
  final VoidCallback? onTap;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    final optionalDescriptionBeforeChevron =
        this.optionalDescriptionBeforeChevron;
    final icon = this.icon;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 16,
          right: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SvgPicture.asset(icon),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (description != null)
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            switch (type) {
              SettingType.switcher => CustomCupertinoSwitch(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                ),
              SettingType.button => Row(
                  children: [
                    if (optionalDescriptionBeforeChevron != null)
                      Text(
                        optionalDescriptionBeforeChevron,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ),
                    SvgPicture.asset(AppIcons.chevronRight),
                  ],
                ),
            },
          ],
        ),
      ),
    );
  }
}
