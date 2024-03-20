import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:obs_blade/shared/general/base/button.dart';
import 'package:obs_blade/shared/general/base/divider.dart';
import 'package:obs_blade/stores/shared/network.dart';
import 'package:obs_blade/stores/views/dashboard.dart';
import 'package:obs_blade/types/enums/request_type.dart';
import 'package:obs_blade/utils/modal_handler.dart';
import 'package:obs_blade/utils/network_helper.dart';
import 'package:obs_blade/views/dashboard/widgets/scenes/exposed_controls/hotkeys_control/hotkey_list.dart';

import '../../../../../../models/hotkey.dart';
import '../../../../../../shared/dialogs/confirmation.dart';
import '../../../../../../shared/general/hive_builder.dart';
import '../../../../../../types/enums/hive_keys.dart';
import '../../../../../../types/enums/settings_keys.dart';

class HotkeysControl extends StatelessWidget {
  const HotkeysControl({super.key});

  void _onHotkeys(BuildContext context) {
    GetIt.instance<DashboardStore>().hotkeys = null;
    NetworkHelper.makeRequest(
      GetIt.instance<NetworkStore>().activeSession!.socket,
      RequestType.GetHotkeyList,
    );
    ModalHandler.showBaseCupertinoBottomSheet(
      context: context,
      modalWidgetBuilder: (context, controller) => HotkeyList(
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HiveBuilder<Hotkey>(
      hiveKey: HiveKeys.Hotkey,
      builder: (context, hotkeyBox, child) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: BaseButton(
                onPressed: () {
                  !Hive.box<dynamic>(HiveKeys.Settings.name).get(
                          SettingsKeys
                              .DontShowHotkeysTechnicalPreviewWarning.name,
                          defaultValue: false)
                      ? ModalHandler.showBaseDialog(
                          context: context,
                          dialogWidget: ConfirmationDialog(
                            enableDontShowAgainOption: true,
                            title: '技术预览 ',
                            body:
                                'WebSocket API 的热键功能目前非常有限，因此该功能目前处于技术预览阶段。 由于即使在这种情况下它对某些人可能仍然有用，所以我添加了基本功能。 预计将无法正常工作。 等这个功能成熟了我会更新的！',
                            noText: '取消',
                            okText: '确认',
                            onOk: (checked) {
                              Hive.box<dynamic>(HiveKeys.Settings.name).put(
                                  SettingsKeys
                                      .DontShowHotkeysTechnicalPreviewWarning
                                      .name,
                                  checked);
                              _onHotkeys(context);
                            },
                          ),
                        )
                      : _onHotkeys(context);
                },
                icon: const Icon(
                  CupertinoIcons.rectangle_grid_3x2_fill,
                ),
                text: 'All',
              ),
            ),
            if (hotkeyBox.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              const BaseDivider(),
              const SizedBox(height: 8.0),
              Wrap(
                children: hotkeyBox.values
                    .map(
                      (hotkey) => BaseButton(
                        child: Text(hotkey.name),
                        onPressed: () => NetworkHelper.makeRequest(
                          GetIt.instance<NetworkStore>().activeSession!.socket,
                          RequestType.TriggerHotkeyByName,
                          {'hotkeyName': hotkey.name},
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ],
        );
      },
    );
  }
}
