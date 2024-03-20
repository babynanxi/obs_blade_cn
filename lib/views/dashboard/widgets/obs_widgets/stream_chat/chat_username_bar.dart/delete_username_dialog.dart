import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../../../models/enums/chat_type.dart';
import '../../../../../../shared/dialogs/confirmation.dart';
import '../../../../../../types/enums/settings_keys.dart';

class DeleteUsernameDialog extends StatelessWidget {
  final Box settingsBox;
  final String username;

  const DeleteUsernameDialog(
      {super.key, required this.settingsBox, required this.username});

  @override
  Widget build(BuildContext context) {
    ChatType chatType = this
        .settingsBox
        .get(SettingsKeys.SelectedChatType.name, defaultValue: ChatType.Twitch);

    return ConfirmationDialog(
      title: '删除 ${chatType.text} 用户名',
      body:
          '您确定要删除 ${chatType.text} 用户名？ 此操作无法撤消!',
      isYesDestructive: true,
      onOk: (_) {
        if (chatType == ChatType.Twitch) {
          List<String> twitchUsernames = this
              .settingsBox
              .get(SettingsKeys.TwitchUsernames.name, defaultValue: <String>[]);
          twitchUsernames.removeAt(twitchUsernames.indexOf(this.username));
          this
              .settingsBox
              .put(SettingsKeys.TwitchUsernames.name, twitchUsernames);
          this.settingsBox.put(SettingsKeys.SelectedTwitchUsername.name,
              twitchUsernames.isNotEmpty ? twitchUsernames.last : null);
        } else if (chatType == ChatType.YouTube) {
          Map<String, String> youtubeUsernames = Map<String, String>.from((this
              .settingsBox
              .get(SettingsKeys.YouTubeUsernames.name,
                  defaultValue: <String, String>{})));
          youtubeUsernames.remove(this.username);
          this
              .settingsBox
              .put(SettingsKeys.YouTubeUsernames.name, youtubeUsernames);
          this.settingsBox.put(
              SettingsKeys.SelectedYouTubeUsername.name,
              youtubeUsernames.isNotEmpty
                  ? youtubeUsernames[youtubeUsernames.keys.last]
                  : null);
        } else if (chatType == ChatType.Owncast) {
          Map<String, String> owncastUsernames = Map<String, String>.from((this
              .settingsBox
              .get(SettingsKeys.OwncastUsernames.name,
                  defaultValue: <String, String>{})));
          owncastUsernames.remove(this.username);
          this
              .settingsBox
              .put(SettingsKeys.OwncastUsernames.name, owncastUsernames);
          this.settingsBox.put(
              SettingsKeys.SelectedOwncastUsername.name,
              owncastUsernames.isNotEmpty
                  ? owncastUsernames[owncastUsernames.keys.last]
                  : null);
        }
      },
    );
  }
}
