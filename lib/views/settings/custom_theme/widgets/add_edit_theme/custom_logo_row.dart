import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../models/custom_theme.dart';
import '../../../../../shared/dialogs/confirmation.dart';
import '../../../../../utils/modal_handler.dart';
import '../../../../../utils/styling_helper.dart';

import 'theme_row.dart';

class CustomLogoRow extends StatelessWidget {
  final CustomTheme customTheme;

  final void Function(Uint8List imageBytes) onSelectLogo;
  final VoidCallback onReset;

  const CustomLogoRow({
    Key? key,
    required this.customTheme,
    required this.onSelectLogo,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeRow(
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '定制logo',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
            ),
            child: Container(
              alignment: Alignment.center,
              height: 128.0,
              width: 128.0,
              decoration: BoxDecoration(
                border: this.customTheme.customLogo == null
                    ? Border.all(
                        color: Theme.of(context).textTheme.bodySmall!.color!,
                      )
                    : null,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: this.customTheme.customLogo != null
                  ? Image.memory(
                      base64Decode(this.customTheme.customLogo!),
                      key: Key(this.customTheme.customLogo!),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.03,
                          child: Transform.translate(
                            offset: const Offset(0, -8),
                            child: Image.asset(
                              StylingHelper.brightnessAwareOBSLogo(context),
                              key: Key(
                                StylingHelper.brightnessAwareOBSLogo(context),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '- None -',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 14.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      description:
          '您可以选择自己的logo，该logo将显示在主页选项卡的应用程序栏中（而不是 OBS Blade 徽标）',
      buttonText: '选择',
      onButtonPressed: () {
        ImagePicker().pickImage(source: ImageSource.gallery).then(
              (image) => image?.readAsBytes().then(
                    (imageBytes) => this.onSelectLogo(imageBytes),
                  ),
            );
      },
      resetButtonText: '清除',
      onResetButtonPressed: () => ModalHandler.showBaseDialog(
        context: context,
        dialogWidget: ConfirmationDialog(
          title: '删除logo',
          body:
              '您确定要删除您的自定义logo吗？ 除非再次选择，否则您将无法取回它!',
          isYesDestructive: true,
          onOk: (_) => this.onReset(),
        ),
      ),
    );
  }
}
