import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'point_a_widget.dart';

/// Виджет для отображения точки A с адресом и комментарием
class PointAWithCommentWidget extends StatelessWidget {
  /// Адрес точки A
  final String pointAddress;

  /// Комментарий к точке A
  final String pointAComment;

  const PointAWithCommentWidget({
    super.key,
    required this.pointAddress,
    required this.pointAComment,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 97,
      child: Column(
        children: [
          // Первый ребенок - как PointAWidget
          // SizedBox(
          //   width: double.infinity,
          //   height: 48,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(left: 12),
          //         child: SizedBox(
          //           width: 48,
          //           height: 48,
          //           child: Center(
          //             child: SvgPicture.asset(
          //               'assets/icons/point_a.svg',
          //               width: 32,
          //               height: 32,
          //             ),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.only(left: 4, right: 16),
          //           child: Text(
          //             pointAddress,
          //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //                   color: Theme.of(context).colorScheme.onSurface,
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 16,
          //                   letterSpacing: 0,
          //                 ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          PointAWidget(
            pointAddress: pointAddress,
          ),
          // Второй ребенок - комментарий с иконкой чата
          SizedBox(
            width: double.infinity,
            height: 49,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 4,
                    right: 6,
                    bottom: 21,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/chat_bubble_outlined.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28, top: 7.5),
                    child: Text(
                      pointAComment,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
