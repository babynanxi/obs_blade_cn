import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../../shared/dialogs/confirmation.dart';
import '../../../../../types/enums/hive_keys.dart';
import '../../../../../types/enums/settings_keys.dart';

class StartStopStreamingDialog extends StatelessWidget {
  final bool isLive;
  final VoidCallback onStreamStartStop;

  const StartStopStreamingDialog({
    Key? key,
    required this.isLive,
    required this.onStreamStartStop,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: '${this.isLive ? '停止' : '启动'} Streaming',
      body: this.isLive
          ? '您确定要停止直播吗？ '
          : '您确定准备好开始直播了吗？ 一切都设置完成了吗？ ',
      isYesDestructive: true,
      enableDontShowAgainOption: true,
      onOk: (checked) {
        Hive.box(HiveKeys.Settings.name).put(
            this.isLive
                ? SettingsKeys.DontShowStreamStopMessage.name
                : SettingsKeys.DontShowStreamStartMessage.name,
            checked);
        this.onStreamStartStop();
      },
    );
  }
}
