import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../shared/general/base/card.dart';
import '../../../../shared/overlay/base_result.dart';

class PlaceholderConnection extends StatelessWidget {
  final double height;
  final double width;

  const PlaceholderConnection(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: this.width,
        child: BaseCard(
          topPadding: 0.0,
          rightPadding: 0.0,
          bottomPadding: 0.0,
          leftPadding: 0.0,
          paddingChild: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: SizedBox(
              height: this.height,
              child: const BaseResult(
                icon: BaseResultIcon.Missing,
                iconSize: 42.0,
                text:
                    '尚未保存连接...\n不过不用担心，成功连接到 OBS 实例后，您可以保存一个以供以后使用！ :)',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
