import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

void showOnboarding(BuildContext context) {
  bool isPress1 = false;
  bool isPress2 = false;
  bool isPress3 = false;

  final dialog = showModalBottomSheet(
    context: context,
    barrierColor: Colors.transparent,
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(150, 20),
        topRight: Radius.elliptical(150, 20),
      ),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 17),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: context.colors.semanticBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(150, 20),
                topRight: Radius.elliptical(150, 20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 13),
                Container(
                  height: 4,
                  width: 34,
                  color: context.colors.textMiror,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Чем могу помочь?',
                      style: context.textStyles.mediumBig.copyWith(
                        fontSize: 28,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/alice_online.svg',
                      height: 80,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  spacing: 10,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isPress1 = !isPress1;
                          isPress2 = false;
                          isPress3 = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: (isPress1) ? Color(0xFFFAF9FF) : context.colors.semanticBackground,
                        padding: EdgeInsetsGeometry.all(10),
                        side: BorderSide(color: context.colors.border),
                      ),
                      child: Text(
                        'Поехали домой',
                        style: context.textStyles.mediumBig,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isPress2 = !isPress2;
                          isPress3 = false;
                          isPress1 = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: (isPress2) ? Color(0xFFFAF9FF) : context.colors.semanticBackground,
                        padding: EdgeInsetsGeometry.all(10),
                        side: BorderSide(color: context.colors.border),
                      ),
                      child: Text(
                        'Помоги с заказами',
                        style: context.textStyles.mediumBig,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isPress3 = !isPress3;
                          isPress2 = false;
                          isPress1 = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: (isPress3) ? Color(0xFFFAF9FF) : context.colors.semanticBackground,
                        padding: EdgeInsetsGeometry.all(10),
                        side: BorderSide(color: context.colors.border),
                      ),
                      child: Text(
                        'Расскажи куда едем',
                        style: context.textStyles.mediumBig,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
