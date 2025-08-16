import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../theme.dart';
import '../../../../widgets/alice/alice_need_to_know_widget.dart';
import '../../../../widgets/buttons/buttons.dart';
import '../../../../widgets/ios/ios.dart';
import '../../../../widgets/road_tracker/road_tracker.dart';
import '../../../../widgets/widgets.dart';
import '../../../components/components.dart';
import '../bloc/orders_bloc.dart';
import 'widgets/maps/map_offline.dart';
import '../../../chat/view/chat_screen.dart';


part 'orders_page.dart';
part 'widgets/draggable_window.dart';
part 'widgets/bottom_sheets/sheet_at_pickup.dart';
part 'widgets/bottom_sheets/sheet_at_arriving.dart';
part 'widgets/bottom_sheets/sheet_ended.dart';
part 'widgets/bottom_sheets/sheet_to_pickup.dart';
part 'widgets/bottom_sheets/sheet_offer.dart';
part 'widgets/bottom_sheets/sheet_offline.dart';
part 'widgets/bottom_sheets/sheet_online_idle.dart';
part 'widgets/bottom_sheets/sheet_leave_line.dart';
