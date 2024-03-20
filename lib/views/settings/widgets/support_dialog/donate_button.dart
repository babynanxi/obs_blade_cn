import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:obs_blade/shared/overlay/base_progress_indicator.dart';

import '../../../../shared/dialogs/confirmation.dart';
import '../../../../shared/dialogs/info.dart';
import '../../../../shared/general/base/button.dart';
import '../../../../types/enums/hive_keys.dart';
import '../../../../types/enums/settings_keys.dart';
import '../../../../utils/modal_handler.dart';

class DonateButton extends StatelessWidget {
  final String? text;
  final String? price;
  final String? errorText;

  final PurchaseParam? purchaseParam;

  const DonateButton({
    Key? key,
    this.text,
    this.price,
    this.errorText,
    this.purchaseParam,
  });

  @override
  Widget build(BuildContext context) {
    Widget purchaseButton = BaseButton(
      shrinkWidth: true,
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      onPressed: this.purchaseParam != null
          ? () => this.purchaseParam!.productDetails.id.contains('tip') &&
                  !Hive.box(HiveKeys.Settings.name).get(
                    SettingsKeys.BoughtBlacksmith.name,
                    defaultValue: false,
                  ) &&
                  !Hive.box(HiveKeys.Settings.name).get(
                    SettingsKeys.DontShowConsiderBlacksmithBeforeTip.name,
                    defaultValue: false,
                  )
              ? ModalHandler.showBaseDialog(
                  context: context,
                  dialogWidget: ConfirmationDialog(
                    title: '在您留下小费之前...',
                    body:
                        '您还没有购买 Blacksmith，并且想给我小费 - 您不会从给我小费中得到任何东西，但 Blacksmith 至少会为您提供一些定制功能，这样对您来说可能更有意义！\n\n只要考虑一下 在你真正留下小费之前！ :)',
                    noText: '取消',
                    okText: '留下小费',
                    enableDontShowAgainOption: true,
                    onOk: (checked) {
                      Hive.box(HiveKeys.Settings.name).put(
                        SettingsKeys.DontShowConsiderBlacksmithBeforeTip.name,
                        checked,
                      );
                      InAppPurchase.instance
                          .buyConsumable(purchaseParam: this.purchaseParam!);
                    },
                  ),
                )
              : this.purchaseParam!.productDetails.id.contains('tip')
                  ? InAppPurchase.instance
                      .buyConsumable(purchaseParam: this.purchaseParam!)
                  : InAppPurchase.instance
                      .buyNonConsumable(purchaseParam: this.purchaseParam!)
          : this.errorText != null
              ? () => ModalHandler.showBaseDialog(
                  context: context,
                  barrierDismissible: true,
                  dialogWidget: InfoDialog(body: this.errorText!))
              : null,
      child: this.price != null || this.errorText != null
          ? Text(
              this.price ?? '-',
              style: const TextStyle(
                fontFeatures: [
                  FontFeature.tabularFigures(),
                ],
              ),
            )
          : BaseProgressIndicator(size: 18.0),
    );

    if (this.text == null) return purchaseButton;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            this.text!,
            textAlign: TextAlign.left,
          ),
        ),
        purchaseButton,
      ],
    );
  }
}
