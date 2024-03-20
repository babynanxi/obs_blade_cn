import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../../shared/general/base/button.dart';
import '../../../../../shared/general/base/divider.dart';
import '../../../../../shared/general/hive_builder.dart';
import '../../../../../shared/general/themed/rich_text.dart';
import '../../../../../stores/shared/tabs.dart';
import '../../../../../types/enums/hive_keys.dart';
import '../../../../../types/enums/settings_keys.dart';
import '../../../../../utils/modal_handler.dart';
import '../../../../../utils/routing_helper.dart';
import '../donate_button.dart';
import 'restore_button.dart';

class BlacksmithContent extends StatelessWidget {
  final List<ProductDetails>? blacksmithDetails;

  const BlacksmithContent({
    Key? key,
    required this.blacksmithDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedRichText(
          textAlign: TextAlign.center,
          textSpans: [
            TextSpan(
              text: '成为一名铁匠，打造属于你自己的 OBS 之刃',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: BaseDivider(),
              ),
            ),
            TextSpan(
              text:
                  'Blacksmith 为您提供了该应用程序的视觉定制选项，使其更加个性化！ 创建您自己的主题来更改此应用程序的整体外观和感觉，使其成为您的主题！',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        HiveBuilder<dynamic>(
          hiveKey: HiveKeys.Settings,
          rebuildKeys: const [SettingsKeys.BoughtBlacksmith],
          builder: (context, settingsBox, child) {
            if (!settingsBox.get(
              SettingsKeys.BoughtBlacksmith.name,
              defaultValue: false,
            )) {
              if (this.blacksmithDetails != null &&
                  this.blacksmithDetails!.isNotEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const RestoreButton(),
                    DonateButton(
                      price: this.blacksmithDetails![0].price,
                      purchaseParam: PurchaseParam(
                        productDetails: this.blacksmithDetails![0],
                      ),
                    ),
                  ],
                );
              }
              return DonateButton(
                errorText: this.blacksmithDetails != null &&
                        this.blacksmithDetails!.isEmpty
                    ? '无法检索 App Store 信息！ 请检查您的互联网连接，然后重试。 如果问题依然存在，请联系我，谢谢！'
                    : null,
              );
            }
            return BaseButton(
              text: '创建主题',
              secondary: true,
              onPressed: () {
                Navigator.of(context).pop(true);
                TabsStore tabsStore = GetIt.instance<TabsStore>();

                if (tabsStore.activeRoutePerNavigator[Tabs.Settings] !=
                    SettingsTabRoutingKeys.CustomTheme.route) {
                  Future.delayed(
                    ModalHandler.transitionDelayDuration,
                    () => tabsStore.navigatorKeys[Tabs.Settings]?.currentState
                        ?.pushNamed(
                      SettingsTabRoutingKeys.CustomTheme.route,
                      arguments: {'铁匠': true},
                    ),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
