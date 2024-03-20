import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/general/base/adaptive_switch.dart';
import '../../../shared/general/hive_builder.dart';
import '../../../shared/general/transculent_cupertino_navbar_wrapper.dart';
import '../../../types/enums/hive_keys.dart';
import '../../../types/enums/settings_keys.dart';
import '../widgets/action_block.dart/action_block.dart';
import '../widgets/action_block.dart/block_entry.dart';

class DashboardCustomisationView extends StatelessWidget {
  const DashboardCustomisationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HiveBuilder<dynamic>(
        hiveKey: HiveKeys.Settings,
        builder: (context, settingsBox, child) =>
            TransculentCupertinoNavBarWrapper(
          previousTitle: '设置',
          title: '仪表板定制',
          listViewChildren: [
            ActionBlock(
              dense: true,
              blockEntries: [
                BlockEntry(
                  leading: CupertinoIcons.profile_circled,
                  leadingSize: 30.0,
                  title: '配置文件快速切换',
                  trailing: BaseAdaptiveSwitch(
                    value: settingsBox.get(
                      SettingsKeys.ExposeProfile.name,
                      defaultValue: false,
                    ),
                    onChanged: (exposeProfile) {
                      settingsBox.put(
                        SettingsKeys.ExposeProfile.name,
                        exposeProfile,
                      );
                    },
                  ),
                ),
                BlockEntry(
                  leading: CupertinoIcons.collections_solid,
                  leadingSize: 26.0,
                  title: '场景集合快速切换',
                  trailing: BaseAdaptiveSwitch(
                    value: settingsBox.get(
                      SettingsKeys.ExposeSceneCollection.name,
                      defaultValue: false,
                    ),
                    onChanged: (exposeSceneCollection) {
                      settingsBox.put(
                        SettingsKeys.ExposeSceneCollection.name,
                        exposeSceneCollection,
                      );
                    },
                  ),
                ),
                BlockEntry(
                  leading: Icons.live_tv_rounded,
                  leadingSize: 28.0,
                  title: '流媒体控制',
                  help:
                      '如果处于活动状态，流操作（开始/停止）将显示在仪表板视图中，而不是显示在应用程序栏的操作菜单中。 使其更易于访问。',
                  trailing: BaseAdaptiveSwitch(
                    value: settingsBox.get(
                      SettingsKeys.ExposeStreamingControls.name,
                      defaultValue: false,
                    ),
                    onChanged: (exposeStreamingControls) {
                      settingsBox.put(
                        SettingsKeys.ExposeStreamingControls.name,
                        exposeStreamingControls,
                      );
                    },
                  ),
                ),
                BlockEntry(
                  leading: CupertinoIcons.recordingtape,
                  leadingSize: 30.0,
                  title: '录制控制',
                  help:
                      '如果处于活动状态，录制操作（开始/停止/暂停）将显示在仪表板视图中，而不是显示在应用程序栏的操作菜单中。 使其更易于访问。',
                  trailing: BaseAdaptiveSwitch(
                    value: settingsBox.get(
                      SettingsKeys.ExposeRecordingControls.name,
                      defaultValue: false,
                    ),
                    onChanged: (exposeRecordingControls) {
                      settingsBox.put(
                        SettingsKeys.ExposeRecordingControls.name,
                        exposeRecordingControls,
                      );
                    },
                  ),
                ),
                BlockEntry(
                  leading: CupertinoIcons.reply_thick_solid,
                  leadingSize: 28.0,
                  title: '重播控制',
                  help:
                      '如果处于活动状态，重播缓冲区操作（开始/停止/保存）将显示在仪表板视图中，而不是显示在应用程序栏的操作菜单中。 使其更易于访问。',
                  trailing: BaseAdaptiveSwitch(
                    value: settingsBox.get(
                      SettingsKeys.ExposeReplayBufferControls.name,
                      defaultValue: false,
                    ),
                    onChanged: (exposeReplayBufferControls) {
                      settingsBox.put(
                        SettingsKeys.ExposeReplayBufferControls.name,
                        exposeReplayBufferControls,
                      );
                    },
                  ),
                ),
                BlockEntry(
                  leading: CupertinoIcons.square_grid_3x2_fill,
                  leadingSize: 28.0,
                  title: '热键',
                  help:
                      '如果处于活动状态，热键按钮将添加到仪表板，使您能够列出所有可用的 OBS 热键并触发它们。 实现与OBS更精确的交互，通常只有高级用户才需要。',
                  trailing: BaseAdaptiveSwitch(
                    value: settingsBox.get(
                      SettingsKeys.ExposeHotkeys.name,
                      defaultValue: false,
                    ),
                    onChanged: (exposeHotkeys) {
                      settingsBox.put(
                        SettingsKeys.ExposeHotkeys.name,
                        exposeHotkeys,
                      );
                    },
                  ),
                ),
                BlockEntry(
                  leading: CupertinoIcons.person_2_square_stack,
                  leadingSize: 30.0,
                  title: '场景预览',
                  trailing: BaseAdaptiveSwitch(
                    value: settingsBox.get(SettingsKeys.ExposeScenePreview.name,
                        defaultValue: true),
                    onChanged: (exposeScenePreview) {
                      settingsBox.put(
                        SettingsKeys.ExposeScenePreview.name,
                        exposeScenePreview,
                      );
                    },
                  ),
                ),
                BlockEntry(
                  leading: CupertinoIcons.memories,
                  leadingSize: 30.0,
                  title: '输入同步',
                  help:
                      '在 OBS 中音频输入的高级设置部分中，您可以调整“同步偏移”以将其他元素的潜在延迟与您的音频输入对齐，以便它们再次同步。\n\n打开此功能将为每个音频公开此值 输入，这也使其能够在应用程序中调整这些。',
                  trailing: BaseAdaptiveSwitch(
                    value: settingsBox.get(
                      SettingsKeys.ExposeInputAudioSyncOffset.name,
                      defaultValue: false,
                    ),
                    onChanged: (exposeInputAudioSyncOffset) {
                      settingsBox.put(
                        SettingsKeys.ExposeInputAudioSyncOffset.name,
                        exposeInputAudioSyncOffset,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
