import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:obs_blade/shared/general/base/divider.dart';
import 'package:obs_blade/stores/shared/network.dart';
import 'package:obs_blade/views/home/widgets/connect_box/quick_connect/qr_scan.dart';

import '../../../../../models/connection.dart';
import '../../../../../shared/general/base/button.dart';
import '../../../../../utils/modal_handler.dart';

class QuickConnect extends StatelessWidget {
  const QuickConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
              '扫描WebSocket插件的“连接二维码”即可立即连接OBS。\n\n此功能仅在连接到与该设备处于同一网络的OBS实例时才有效！'),
          const SizedBox(height: 20.0),
          const BaseDivider(),
          const SizedBox(height: 18.0),
          BaseButton(
            onPressed: () =>
                ModalHandler.showBaseCupertinoBottomSheet<Connection?>(
              context: context,
              includeCloseButton: false,
              modalWidgetBuilder: (context, controller) => const QRScan(),
            ).then(
              (connection) {
                if (connection != null) {
                  Future.delayed(
                    const Duration(milliseconds: 500),
                    () => GetIt.instance<NetworkStore>()
                        .setOBSWebSocket(connection),
                  );
                }
              },
            ),
            icon: const Icon(CupertinoIcons.qrcode_viewfinder),
            text: '扫描二维码',
          ),
        ],
      ),
    );
  }
}
