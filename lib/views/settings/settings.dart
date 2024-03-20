import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../shared/general/base/adaptive_switch.dart';
import '../../shared/general/custom_sliver_list.dart';
import '../../shared/general/hive_builder.dart';
import '../../shared/general/themed/cupertino_sliver_navigation_bar.dart';
import '../../stores/shared/tabs.dart';
import '../../types/enums/hive_keys.dart';
import '../../types/enums/settings_keys.dart';
import '../../utils/modal_handler.dart';
import '../../utils/routing_helper.dart';
import '../../utils/styling_helper.dart';
import 'widgets/action_block.dart/action_block.dart';
import 'widgets/action_block.dart/block_entry.dart';
import 'widgets/support_dialog/support_dialog.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller:
            ModalRoute.of(context)!.settings.arguments as ScrollController,
        physics: StylingHelper.platformAwareScrollPhysics,
        slivers: <Widget>[
          const ThemedCupertinoSliverNavigationBar(
            largeTitle: Text('设置'),
          ),
          HiveBuilder<dynamic>(
            hiveKey: HiveKeys.Settings,
            builder: (context, settingsBox, child) => CustomSliverList(
              children: [
                ActionBlock(
                  title: '一般的',
                  blockEntries: [
                    BlockEntry(
                      leading: CupertinoIcons.device_phone_portrait,
                      title: '唤醒锁',
                      help:
                          '此选项将使屏幕在连接到 OBS 实例时保持活动状态。 如果您未连接OBS实例，则将照常使用手机设置中设置的时间。',
                      trailing: BaseAdaptiveSwitch(
                        value: settingsBox.get(
                          SettingsKeys.WakeLock.name,
                          defaultValue: true,
                        ),
                        onChanged: (wakeLock) {
                          settingsBox.put(SettingsKeys.WakeLock.name, wakeLock);
                          if (wakeLock) {
                            /// Check if user is currently in the [DashboardView], therefore
                            /// connected to an OBS instance, we will then activate [Wakelock]
                            /// now since otherwise it won't affect the current connection because
                            /// it will only trigger when entereing the [DashboardView]
                            if (GetIt.instance<TabsStore>()
                                    .activeRoutePerNavigator[Tabs.Home] ==
                                HomeTabRoutingKeys.Dashboard.route) {
                              WakelockPlus.enable();
                            }
                          } else {
                            WakelockPlus.disable();
                          }
                        },
                      ),
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.loop,
                      title: '无限次重试',
                      help:
                          '处于活动状态时，OBS Blade 将无限期地尝试重新连接到丢失的 OBS 连接，而不是在达到固定尝试次数时中止。',
                      trailing: BaseAdaptiveSwitch(
                        value: settingsBox.get(
                          SettingsKeys.UnlimitedReconnects.name,
                          defaultValue: false,
                        ),
                        onChanged: (unlimitedReconnects) {
                          settingsBox.put(SettingsKeys.UnlimitedReconnects.name,
                              unlimitedReconnects);
                        },
                      ),
                    ),
                    const BlockEntry(
                      leading: CupertinoIcons.archivebox_fill,
                      title: '数据管理',
                      navigateTo: SettingsTabRoutingKeys.DataManagement,
                    ),
                  ],
                ),
                ActionBlock(
                  title: '仪表板',
                  description:
                      '自定义允许您更改仪表板视图的 UI，以添加默认隐藏在菜单栏中的快速访问按钮/功能.',
                  blockEntries: [
                    BlockEntry(
                      leading: CupertinoIcons.camera_on_rectangle_fill,
                      leadingSize: 28.0,
                      title: '串流模式',
                      help:
                          '更改仪表板的整体布局，以专注于场景预览和聊天。 最好在直播时保留最重要部分的概览!',
                      trailing: BaseAdaptiveSwitch(
                        value: settingsBox.get(
                          SettingsKeys.StreamingMode.name,
                          defaultValue: false,
                        ),
                        onChanged: (streamingMode) {
                          settingsBox.put(
                            SettingsKeys.StreamingMode.name,
                            streamingMode,
                          );
                        },
                      ),
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.film,
                      leadingSize: 26.0,
                      title: '工作室模式',
                      help:
                          '启用 OBS Blade 中 Studio 模式的感知和使用。 将在仪表板中公开其他设置/按钮。',
                      trailing: BaseAdaptiveSwitch(
                        value: settingsBox.get(
                          SettingsKeys.ExposeStudioControls.name,
                          defaultValue: false,
                        ),
                        onChanged: (exposeStudioControls) {
                          settingsBox.put(
                            SettingsKeys.ExposeStudioControls.name,
                            exposeStudioControls,
                          );
                        },
                      ),
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.table_fill,
                      leadingSize: 28.0,
                      title: '强制平板电脑模式',
                      help:
                          '如果屏幕足够大，仪表板视图中的元素将彼此相邻显示，而不是显示在选项卡中。 如果您愿意，可以手动设置。\n\n注意：可能不适合您的屏幕。',
                      trailing: BaseAdaptiveSwitch(
                        value: settingsBox.get(
                            SettingsKeys.EnforceTabletMode.name,
                            defaultValue: false),
                        onChanged: (enforceTabletMode) {
                          settingsBox.put(
                            SettingsKeys.EnforceTabletMode.name,
                            enforceTabletMode,
                          );
                        },
                      ),
                    ),
                    const BlockEntry(
                      leading: CupertinoIcons.layers_fill,
                      title: '定制化',
                      navigateTo: SettingsTabRoutingKeys.DashboardCustomisation,
                    ),
                  ],
                ),
                ActionBlock(
                  title: '主题',
                  blockEntries: [
                    BlockEntry(
                      leading: CupertinoIcons.lab_flask_solid,
                      title: '自定义主题',
                      navigateTo: SettingsTabRoutingKeys.CustomTheme,
                      navigateToResult: Text(
                        settingsBox.get(SettingsKeys.CustomTheme.name,
                                defaultValue: false)
                            ? 'Active'
                            : 'Inactive',
                      ),
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.moon_circle_fill,
                      leadingSize: 30.0,
                      title: '暗黑模式',
                      trailing: BaseAdaptiveSwitch(
                        value: settingsBox.get(
                          SettingsKeys.TrueDark.name,
                          defaultValue: false,
                        ),
                        enabled: !settingsBox.get(
                          SettingsKeys.CustomTheme.name,
                          defaultValue: false,
                        ),
                        disabledChangeInfo:
                            '当自定义主题处于活动状态时，此设置无效且无法更改',
                        onChanged: (trueDark) {
                          settingsBox.put(
                            SettingsKeys.TrueDark.name,
                            trueDark,
                          );
                        },
                      ),
                    ),
                    if (settingsBox.get(SettingsKeys.TrueDark.name,
                        defaultValue: false))
                      BlockEntry(
                        leading: CupertinoIcons.drop_fill,
                        title: '减少拖尾现象',
                        help:
                            '仅与 OLED 显示器相关。 使用全黑背景可能会导致滚动时出现拖尾现象，因此此选项将应用稍浅的背景颜色。\n\n注意：可能会消耗“更多”电池电量.',
                        trailing: BaseAdaptiveSwitch(
                          value: settingsBox.get(
                            SettingsKeys.ReduceSmearing.name,
                            defaultValue: false,
                          ),
                          enabled: !settingsBox.get(
                            SettingsKeys.CustomTheme.name,
                            defaultValue: false,
                          ),
                          disabledChangeInfo:
                              '当自定义主题处于活动状态时，此设置无效且无法更改',
                          onChanged: (reduceSmearing) {
                            settingsBox.put(
                              SettingsKeys.ReduceSmearing.name,
                              reduceSmearing,
                            );
                          },
                        ),
                      ),
                    BlockEntry(
                      leading: CupertinoIcons.wand_stars,
                      leadingSize: 30.0,
                      title: '强制非本机 UI',
                      help:
                          'OBS Blade 最初主要使用 iOS UI 组件。 它现在具有一定的适应性，并且在某种程度上应该与平台无关。\n\n如果出于某种原因您想要使用非本机元素，请打开它！',
                      trailing: BaseAdaptiveSwitch(
                        value: settingsBox.get(
                          SettingsKeys.ForceNonNativeElements.name,
                          defaultValue: false,
                        ),
                        onChanged: (forceNonNativeElements) {
                          settingsBox.put(
                            SettingsKeys.ForceNonNativeElements.name,
                            forceNonNativeElements,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const ActionBlock(
                  title: '杂项.',
                  blockEntries: [
                    BlockEntry(
                      leading: CupertinoIcons.info_circle_fill,
                      title: '关于',
                      navigateTo: SettingsTabRoutingKeys.About,
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.chat_bubble_text_fill,
                      title: 'FAQ | 帮助',
                      navigateTo: SettingsTabRoutingKeys.FAQ,
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.book_fill,
                      title: '介绍幻灯片',
                      navigateTo: AppRoutingKeys.Intro,
                      rootNavigation: true,
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.doc_person_fill,
                      title: '隐私政策',
                      navigateTo: SettingsTabRoutingKeys.PrivacyPolicy,
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.square_list_fill,
                      title: '日志',
                      navigateTo: SettingsTabRoutingKeys.Logs,
                    ),
                  ],
                ),
                ActionBlock(
                  title: '支持',
                  descriptionWidget: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      return Row(
                        children: [
                          Text(
                            '版本 ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (snapshot.hasData)
                            Text(
                              snapshot.data!.version,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      );
                     },
                  ),
                  blockEntries: [
                    BlockEntry(
                      leading: CupertinoIcons.hammer_fill,
                      title: '铁匠',
                      navigateToResult: Text(
                        (settingsBox.get(SettingsKeys.BoughtBlacksmith.name,
                                defaultValue: false) as bool)
                            ? 'Active'
                            : 'Inactive',
                      ),
                      onTap: () => ModalHandler.showBaseDialog(
                        context: context,
                        barrierDismissible: true,
                        dialogWidget: const SupportDialog(
                          title: '铁匠',
                          icon: CupertinoIcons.hammer_fill,
                          type: SupportType.Blacksmith,
                        ),
                      ),
                    ),
                    BlockEntry(
                      leading: CupertinoIcons.gift_fill,
                      title: '礼品',
                      onTap: () => ModalHandler.showBaseDialog(
                        context: context,
                        barrierDismissible: true,
                        dialogWidget: const SupportDialog(
                          title: '礼品',
                          icon: CupertinoIcons.gift_fill,
                          type: SupportType.Tips,
                        ),
                      ),
                    ),
                  ], 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
