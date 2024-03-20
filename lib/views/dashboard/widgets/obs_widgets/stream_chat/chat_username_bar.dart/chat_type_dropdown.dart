import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../../../models/enums/chat_type.dart';
import '../../../../../../shared/dialogs/confirmation.dart';
import '../../../../../../types/enums/hive_keys.dart';
import '../../../../../../types/enums/settings_keys.dart';
import '../../../../../../utils/modal_handler.dart';

class ChatTypeDropdown extends StatelessWidget {
  final Box settingsBox;

  const ChatTypeDropdown({super.key, required this.settingsBox});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ChatType>(
      // isExpanded: true,
      value: this.settingsBox.get(SettingsKeys.SelectedChatType.name,
          defaultValue: ChatType.Twitch),
      isExpanded: true,
      items: ChatType.values
          .map(
            (chatType) => DropdownMenuItem(
              value: chatType,
              child: Row(
                children: [
                  Icon(
                    chatType.icon,
                    color: chatType == ChatType.YouTube
                        ? Colors.red
                        : chatType == ChatType.Twitch
                            ? const Color(0xFF6441a5)
                            : null,
                  ),
                  const SizedBox(width: 12.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chatType.text),
                      if (chatType == ChatType.YouTube)
                        Text(
                          '\u1d47\u1d49\u1d57\u1d43',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                    ],
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (chatType) => chatType == ChatType.YouTube &&
              !Hive.box(HiveKeys.Settings.name).get(
                  SettingsKeys.DontShowYouTubeChatBetaWarning.name,
                  defaultValue: false)
          ? ModalHandler.showBaseDialog(
              context: context,
              dialogWidget: ConfirmationDialog(
                title: 'YoutTube Chat Beta',
                body:
                    'YouTube 聊天支持仍处于测试阶段，因为 YouTube 让我很难集成它。\n\n使用它时请记住这一点，如果您遇到奇怪的行为，请与我联系。',
                enableDontShowAgainOption: true,
                noText: 'Cancel',
                okText: 'Ok',
                onOk: (checked) {
                  if (checked) {
                    this.settingsBox.put(
                        SettingsKeys.DontShowYouTubeChatBetaWarning.name,
                        checked);
                  }
                  this
                      .settingsBox
                      .put(SettingsKeys.SelectedChatType.name, chatType);
                },
              ),
            )
          : this.settingsBox.put(SettingsKeys.SelectedChatType.name, chatType),
    );
  }
}
