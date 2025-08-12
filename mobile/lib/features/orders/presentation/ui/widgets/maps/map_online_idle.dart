import 'package:flutter/material.dart';

class MapOnline extends StatelessWidget {
  const MapOnline({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/online_driver.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 360,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/52_busy.png'),
                        Spacer(),
                        Image.asset('assets/images/speed_60.png'),
                      ],
                    ),
                    Spacer(),
                    Align(alignment: Alignment.bottomRight ,child: Image.asset('assets/images/map_controllers.png')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
