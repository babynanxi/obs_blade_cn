import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../../models/app_log.dart';
import '../../../models/connection.dart';
import '../../../models/custom_theme.dart';
import '../../../models/enums/log_level.dart';
import '../../../models/hidden_scene.dart';
import '../../../models/hidden_scene_item.dart';
import '../../../models/past_stream_data.dart';
import '../../../shared/general/transculent_cupertino_navbar_wrapper.dart';
import '../../../stores/shared/tabs.dart';
import '../../../types/enums/hive_keys.dart';
import '../../../types/enums/settings_keys.dart';
import '../../../utils/routing_helper.dart';
import 'widgets/data_block.dart';
import 'widgets/data_entry.dart';

class DataManagementView extends StatelessWidget {
  const DataManagementView({Key? key});

  Future<void> _deleteAll(BuildContext context) async {
    await Hive.box<Connection>(HiveKeys.SavedConnections.name).clear();
    await Hive.box<PastStreamData>(HiveKeys.PastStreamData.name).clear();
    await Hive.box<HiddenScene>(HiveKeys.HiddenScene.name).clear();
    await Hive.box<HiddenSceneItem>(HiveKeys.HiddenSceneItem.name).clear();
    await Hive.box<CustomTheme>(HiveKeys.CustomTheme.name).clear();
    await Hive.box<AppLog>(HiveKeys.AppLog.name).clear();

    /// Since the Hive-SettingsBox also contains the information whether the user
    /// purchased Blacksmith or not, we save the current value before clearing the whole box
    /// and re-setting it. Worst case here (without doing it) would lead to reset the Blacksmith
    /// status - it would have been re-set though on a restart since I'm also checking
    /// the information from the App Store on startup
    bool boughtBlacksmith = Hive.box(HiveKeys.Settings.name).get(
      SettingsKeys.BoughtBlacksmith.name,
      defaultValue: false,
    );
    await Hive.box(HiveKeys.Settings.name).clear();

    Hive.box(HiveKeys.Settings.name).put(
      SettingsKeys.BoughtBlacksmith.name,
      boughtBlacksmith,
    );

    GetIt.instance<TabsStore>().setActiveTab(Tabs.Home);

    Navigator.of(context, rootNavigator: true)
        .pushReplacementNamed(AppRoutingKeys.Intro.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransculentCupertinoNavBarWrapper(
        previousTitle: '设置',
        title: '数据管理',
        listViewChildren: [
          DataBlock(
            dataEntries: [
              DataEntry(
                title: '已保存的连接',
                description:
                    '主页选项卡中自动发现/连接框下方列出的所有已保存连接（至少在保存任何连接后）。',
                onClear: () {
                  Hive.box<Connection>(HiveKeys.SavedConnections.name).clear();

                  Hive.box<AppLog>(HiveKeys.AppLog.name).add(
                    AppLog(
                      DateTime.now().millisecondsSinceEpoch,
                      LogLevel.Warning,
                      '所有保存的连接已被用户删除。',
                      null,
                      true,
                    ),
                  );
                },
              ),
              DataEntry(
                title: '设置',
                description:
                    '统计选项卡中列出的所有条目都是为连接到的每个实时流 OBS 刀片创建的。',
                onClear: () {
                  /// Since the user might be in a detailed statistic view, we pop until
                  /// we are back in the root view
                  GetIt.instance<TabsStore>()
                      .navigatorKeys[Tabs.Statistics]
                      ?.currentState
                      ?.popUntil((route) => route.isFirst);

                  Hive.box<PastStreamData>(HiveKeys.PastStreamData.name)
                      .clear();

                  Hive.box<AppLog>(HiveKeys.AppLog.name).add(
                    AppLog(
                      DateTime.now().millisecondsSinceEpoch,
                      LogLevel.Warning,
                      '所有统计数据均已被用户删除。',
                      null,
                      true,
                    ),
                  );
                },
              ),
              DataEntry(
                title: '隐藏场景',
                description:
                    '已连接的OBS实例仪表板中隐藏的所有场景。',
                onClear: () {
                  Hive.box<HiddenScene>(HiveKeys.HiddenScene.name).clear();

                  Hive.box<AppLog>(HiveKeys.AppLog.name).add(
                    AppLog(
                      DateTime.now().millisecondsSinceEpoch,
                      LogLevel.Warning,
                      '所有隐藏场景已被用户删除。',
                      null,
                      true,
                    ),
                  );
                },
              ),
              DataEntry(
                title: '隐藏场景物品',
                description:
                    '已连接的 OBS 实例的仪表板中隐藏的所有场景项。',
                onClear: () {
                  Hive.box<HiddenSceneItem>(HiveKeys.HiddenSceneItem.name)
                      .clear();

                  Hive.box<AppLog>(HiveKeys.AppLog.name).add(
                    AppLog(
                      DateTime.now().millisecondsSinceEpoch,
                      LogLevel.Warning,
                      '所有隐藏的场景项目已被用户删除。',
                      null,
                      true,
                    ),
                  );
                },
              ),
              /* DataEntry(
                title: 'Twitch Chats',
                description:
                    'All Twitch usernames that have been added to the stream chat widget in the dashboard.',
                onClear: () {
                  Hive.box(HiveKeys.Settings.name)
                      .delete(SettingsKeys.SelectedTwitchUsername.name);
                  Hive.box(HiveKeys.Settings.name)
                      .delete(SettingsKeys.TwitchUsernames.name);

                  Hive.box<AppLog>(HiveKeys.AppLog.name).add(
                    AppLog(
                      DateTime.now().millisecondsSinceEpoch,
                      LogLevel.Warning,
                      'All twitch chats have been deleted by the user.',
                      null,
                      true,
                    ),
                  );
                },
              ),
              DataEntry(
                title: 'YouTube Chats',
                description:
                    'All YouTube usernames that have been added to the stream chat widget in the dashboard.',
                onClear: () {
                  Hive.box(HiveKeys.Settings.name)
                      .delete(SettingsKeys.SelectedYouTubeUsername.name);
                  Hive.box(HiveKeys.Settings.name)
                      .delete(SettingsKeys.YouTubeUsernames.name);

                  Hive.box<AppLog>(HiveKeys.AppLog.name).add(
                    AppLog(
                      DateTime.now().millisecondsSinceEpoch,
                      LogLevel.Warning,
                      'All youtube chats have been deleted by the user.',
                      null,
                      true,
                    ),
                  );
                },
              ), */
              DataEntry(
                title: '不要再问我检查',
                description:
                    '执行弹出对话框中设置的所有检查，以解释一些非常重要的事情，但可能很快就会变得烦人，并且不再显示。 如果您想再次见到他们 - 就在这里',
                onClear: () {
                  for (SettingsKeys key in SettingsKeys.values
                      .where((key) => key.name.startsWith('dont-show'))) {
                    Hive.box(HiveKeys.Settings.name).delete(key.name);
                  }

                  Hive.box<AppLog>(HiveKeys.AppLog.name).add(
                    AppLog(
                      DateTime.now().millisecondsSinceEpoch,
                      LogLevel.Warning,
                      '所有“不要再问我”检查均已被用户删除。',
                      null,
                      true,
                    ),
                  );
                },
              ),
              DataEntry(
                title: '日志',
                description:
                    '在设置选项卡的“日志”下找到的所有日志条目。 您可以在日志视图中有选择地删除它们！',
                onClear: () => Hive.box<AppLog>(HiveKeys.AppLog.name).clear(),
              ),
            ],
          ),
          DataBlock(
            dataEntries: [
              DataEntry(
                title: '全部数据',
                description:
                    '到目前为止，应用程序保留的所有数据包括自定义主题、唤醒锁等设置或任何保存的连接等。',
                customConfirmationText:
                    '你确定吗？ 就像我的意思是，所有类型的设置（例如设置）或添加的条目（例如连接或统计信息）都将被删除。 没有回头路!',
                additionalConfirmationText:
                    '看来你对此很确定，对吧？ 好吧，继续......只是想确保它确实是有意的！ :)',
                onClear: () => _deleteAll(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
