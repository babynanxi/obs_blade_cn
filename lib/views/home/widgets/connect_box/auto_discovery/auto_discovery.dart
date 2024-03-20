import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:obs_blade/stores/shared/network.dart';

import '../../../../../models/connection.dart';
import '../../../../../shared/animator/fader.dart';
import '../../../../../shared/general/base/divider.dart';
import '../../../../../shared/general/keyboard_number_header.dart';
import '../../../../../shared/general/question_mark_tooltip.dart';
import '../../../../../shared/overlay/base_progress_indicator.dart';
import '../../../../../stores/views/home.dart';
import '../../../../../utils/validation_helper.dart';
import 'result_entry.dart';
import 'session_tile.dart';

class AutoDiscovery extends StatefulWidget {
  const AutoDiscovery({Key? key});

  @override
  _AutoDiscoveryState createState() => _AutoDiscoveryState();
}

class _AutoDiscoveryState extends State<AutoDiscovery> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _portFocusNode = FocusNode();

  String _processResult(AsyncSnapshot<List<Connection>> snapshot) {
    if (snapshot.error.toString().contains('NotInWLANException')) {
      return '您的设备未通过 WLAN 连接！ 仅当您通过 WLAN 连接到本地网络时，自动发现才起作用。';
    }
    if (snapshot.error.toString().contains('NoNetworkException')) {
      return 'OBS Blade 无法检索您的本地 IP 地址，因此无法执行自动发现！\n\n请确保您的设备已通过 WLAN 连接并已分配 IP 地址。';
    }
    if (snapshot.hasData && snapshot.data!.isEmpty) {
      if (GetIt.instance<NetworkStore>().subnetMask != null &&
          GetIt.instance<NetworkStore>().nonDefaultSubnetMask) {
        return '您的网络正在使用“非默认”子网掩码来分配本地客户端 IP 地址 (${GetIt.instance<NetworkStore>().subnetMask}). 因此 OBS Blade 无法可靠地执行自动发现。\n\n请调整路由器的网络设置（如果确实需要自动发现）或使用快速连接或手动模式！';
      }
      return '无法通过自动发现找到打开的 OBS 会话！ 确保您的本地网络中有一个打开的 OBS 会话，并且安装了 OBS WebSocket 插件！\n\n检查设置选项卡中的常见问题解答部分。';
    }

    return '发生了错误！ 您的 WLAN 连接出现问题，或者应用程序无法使用自动发现。\n\n请检查设置选项卡中的常见问题解答部分。';
  }

  @override
  Widget build(BuildContext context) {
    HomeStore homeStore = GetIt.instance<HomeStore>();

    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 18.0, right: 18.0, left: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text('自动发现端口: '),
              ),
              SizedBox(width: 10.0),
              QuestionMarkTooltip(
                  message:
                      '通常为 4455。可以在 OBS 的 WebSocket 插件设置中查看和更改：\n\n工具 -> WebSocket 服务器设置'),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 24.0),
          width: 65.0,
          child: Form(
            key: _formKey,
            child: KeyboardNumberHeader(
              focusNode: _portFocusNode,
              child: TextFormField(
                focusNode: _portFocusNode,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFeatures: [
                    FontFeature.tabularFigures(),
                  ],
                ),
                controller:
                    TextEditingController(text: homeStore.autodiscoverPort),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  homeStore.setAutodiscoverPort(text);
                  _formKey.currentState!.validate();
                },
                validator: (text) => ValidationHelper.portValidator(text),
              ),
            ),
          ),
        ),
        const BaseDivider(),
        Observer(
          builder: (context) => FutureBuilder<List<Connection>>(
            future: homeStore.autodiscoverConnections,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Fader(
                    child: Column(
                      children: snapshot.data!
                          .expand(
                            (availableObsConnection) => [
                              SessionTile(
                                connection: availableObsConnection,
                              ),
                              const BaseDivider(),
                            ],
                          )
                          .toList()
                        ..removeLast(),
                    ),
                  );
                }
                return ResultEntry(
                  result: _processResult(snapshot),
                );
              }
              return Fader(
                child: SizedBox(
                  height: 150.0,
                  child: BaseProgressIndicator(text: '搜寻中...'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
