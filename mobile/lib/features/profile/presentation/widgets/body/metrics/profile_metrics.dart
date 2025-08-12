part of '../../../presentation.dart';

class ProfileMetrics extends StatelessWidget {
  const ProfileMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MetricItem(
            title: 'Рейтинг',
            value: '4.9',
            icon: SvgPicture.asset(
              AppIcons.starYellow,
              fit: BoxFit.fitWidth,
            ),
          ),
          MetricItem(
            title: 'Статус',
            value: 'Бронза',
            icon: SvgPicture.asset(
              AppIcons.gold,
              fit: BoxFit.fitWidth,
            ),
          ),
          const MetricItem(
            title: 'Достижения',
            value: '3 из 21',
            icon: IconsRowStack(
              icons: [
                AppIcons.star1,
                AppIcons.star1,
                AppIcons.star1,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
