import 'package:flutter/material.dart';

import '../../../../../shared/dialogs/confirmation.dart';

class PreviewWarningDialog extends StatelessWidget {
  final void Function(bool) onOk;

  const PreviewWarningDialog({
    Key? key,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: '场景预览警告',
      body:
          'OBS WebSocket 无法检索当前场景的视频流。 此实现是一种解决方法。 它并不反映您的实际 OBS 性能。\n\n请注意，这可能会导致更高的电池使用率和/或 OBS 本身（您的电脑）可能会遇到性能问题。\n\n请谨慎使用！',
      onOk: (checked) => this.onOk(checked),
      enableDontShowAgainOption: true,
      okText: '确认',
      noText: '取消',
    );
  }
}
