part of '../../../ui.dart';

class SheetLeaveLineV2 extends StatelessWidget {
  const SheetLeaveLineV2({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const padding1 = EdgeInsetsGeometry.only(bottom: 12, left: 12, right: 12);
    const padding2 = EdgeInsetsGeometry.fromLTRB(12, 0, 12, 16);
    const padding3 = EdgeInsetsGeometry.all(8.0);

    final textStyle1 = context.textStyles.boldBig;
    final textStyle2 = context.textStyles.regular;

    return ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding1,
            child: Text('Перестать получать заказы?', style: textStyle1),
          ),
          Padding(
            padding: padding2,
            child: Text(
              'Вы получаете заказы. Чтобы перестать, уйдите с линии',
              style: textStyle2,
            ),
          ),
          Padding(
            padding: padding3,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onTap,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: context.colors.controlMain,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    'Выйти с линии',
                    style: context.textStyles.mediumBig.copyWith(
                      color: context.colors.text,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
