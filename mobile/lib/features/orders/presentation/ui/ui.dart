import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/navigation/bottom_sheet_manager.dart';
import '../../../../core/navigation/manager.dart';
import '../../../../core/services/alice_command_recognize_service.dart';
import '../../../../core/services/alice_speaker_service.dart';
import '../../../../di.dart';
import '../../../../theme.dart';
import '../../../../widgets/alice/alice_floating_widget.dart';
import '../../../../widgets/alice/alice_need_to_know_widget.dart';
import '../../../../widgets/alice/bloc/alice_bloc.dart';
import '../../../../widgets/bottom_sheet/measured_scaffold_bottom_sheet.dart';
import '../../../../widgets/buttons/buttons.dart';
import '../../../../widgets/ios/ios.dart';
import '../../../../widgets/road_tracker/road_tracker.dart';
import '../../../../widgets/widgets.dart';
import '../../domain/entities/order_offer.dart';
import '../bloc/orders_bloc.dart';
import '../../../components/components.dart';
import '../../../navigation/widgets/aspects_widget.dart';
import '../../../navigation/widgets/navigation_bottom_sheet_widget.dart';
import '../bloc/orders_bloc.dart';
import 'widgets/maps/map_in_red_zone.dart';
import 'widgets/maps/map_offline.dart';
import '../../../chat/view/chat_screen.dart';


part 'orders_page.dart';
part 'widgets/bottom_sheets/sheet_at_pickup.dart';
part 'widgets/bottom_sheets/sheet_leave_line.dart';
part 'widgets/bottom_sheets/sheet_at_arriving.dart';
part 'widgets/bottom_sheets/sheet_ended.dart';
part 'widgets/bottom_sheets/sheet_to_pickup.dart';
part 'widgets/bottom_sheets/sheet_offer.dart';
part 'widgets/bottom_sheets/sheet_offline.dart';
part 'widgets/bottom_sheets/sheet_offline/sheet_leave_lineV2.dart';
part 'widgets/bottom_sheets/sheet_offline/sheet_offlineV2.dart';
part 'widgets/bottom_sheets/sheet_offline/sheet_to_pickupV2.dart';
part 'widgets/draggable_window.dart';

