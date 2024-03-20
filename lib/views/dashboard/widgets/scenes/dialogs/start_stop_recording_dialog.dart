import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../../shared/dialogs/confirmation.dart';
import '../../../../../types/enums/hive_keys.dart';
import '../../../../../types/enums/settings_keys.dart';

class StartStopRecordingDialog extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onRecordStartStop;

  const StartStopRecordingDialog({
    Key? key,
    required this.isRecording,
    required this.onRecordStartStop,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
        title: '${this.isRecording ? '停止' : '启动'} Recording',
        body: this.isRecording
            ? ' 您想停止录制吗？ 按预期将所有内容都记录在磁带上吗？\n\n'
            : '你想开始录制吗？ 无意中录制并不像突然开始直播那么糟糕！\n\n还是想确认一下!',
        isYesDestructive: true,
        enableDontShowAgainOption: true,
        onOk: (checked) {
          Hive.box(HiveKeys.Settings.name).put(
              this.isRecording
                  ? SettingsKeys.DontShowRecordStopMessage.name
                  : SettingsKeys.DontShowRecordStartMessage.name,
              checked);
          this.onRecordStartStop();
        });
  }
}
