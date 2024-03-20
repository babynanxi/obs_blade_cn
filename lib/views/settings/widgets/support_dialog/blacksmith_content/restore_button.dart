import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../../../shared/dialogs/info.dart';
import '../../../../../shared/general/hive_builder.dart';
import '../../../../../shared/general/themed/cupertino_button.dart';
import '../../../../../shared/overlay/base_progress_indicator.dart';
import '../../../../../types/enums/hive_keys.dart';
import '../../../../../types/enums/settings_keys.dart';
import '../../../../../utils/modal_handler.dart';
import '../../../../../utils/overlay_handler.dart';

class RestoreButton extends StatelessWidget {
  const RestoreButton({Key? key});

  @override
  Widget build(BuildContext context) {
    return HiveBuilder<dynamic>(
      hiveKey: HiveKeys.Settings,
      rebuildKeys: const [SettingsKeys.BoughtBlacksmith],
      builder: (context, settingsBox, child) => ThemedCupertinoButton(
        text: '恢复',
        onPressed: !settingsBox.get(
          SettingsKeys.BoughtBlacksmith.name,
          defaultValue: false,
        )
            ? () {
                /// Initiate to restore all (currently only Blacksmith) non-consumable purchases.
                /// Show an overlay to wait for the purchase stream in purchase_base to receive
                /// the restore status (if successful) where we will close the overlay and show
                /// the info dialog which says that it worked!
                InAppPurchase.instance.restorePurchases();
                OverlayHandler.showStatusOverlay(
                  context: context,
                  showDuration: const Duration(seconds: 10),
                  content: BaseProgressIndicator(
                    text: '正在尝试恢复...',
                  ),
                );

                /// After a fixed amount of time we check if the user got the "BoughtBlacksmith"
                /// status in Hive which would be there if the restoration worked out earlier.
                /// If not, we will close the overlay and show a unsuccessfull info dialog!
                Future.delayed(
                  const Duration(seconds: 5),
                  () {
                    if (!settingsBox.get(SettingsKeys.BoughtBlacksmith.name,
                        defaultValue: false)) {
                      OverlayHandler.closeAnyOverlay();
                      ModalHandler.showBaseDialog(
                        context: context,
                        barrierDismissible: true,
                        dialogWidget: const InfoDialog(
                          body:
                              '铁匠无法恢复。 确保您有可用的互联网连接，并且您之前确实购买过它！\n\n您可以尝试再次购买 - 如果您使用当前的 App Store 帐户购买，则不可能。\n\n如果出现以下情况，请与我联系： 你找不到解决方案!',
                        ),
                      );
                    }
                  },
                );
              }
            : null,
      ),
    );
  }
}
