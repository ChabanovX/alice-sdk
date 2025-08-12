part of '../../../presentation.dart';

class ProfileOptionDivider extends StatelessWidget {
  const ProfileOptionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 40),
      child: Divider(
        color: Color(0xFFF5F4F2),
        thickness: 1,
        height: 10,
      ),
    );
  }
}
