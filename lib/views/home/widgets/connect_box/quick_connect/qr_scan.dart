import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:obs_blade/shared/dialogs/info.dart';
import 'package:obs_blade/shared/general/question_mark_tooltip.dart';
import 'package:obs_blade/shared/overlay/base_progress_indicator.dart';
import 'package:obs_blade/shared/overlay/base_result.dart';
import 'package:obs_blade/utils/modal_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../../models/connection.dart';
import '../../../../../shared/general/themed/cupertino_button.dart';
import '../../../../../shared/general/transculent_cupertino_navbar_wrapper.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  final GlobalKey _key = GlobalKey();

  QRViewController? _controller;
  bool? _qrScanState;

  bool _scanLocked = false;

  bool _permission = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleScanData(Barcode scanData) {
    if (!_scanLocked && _qrScanState == null || !_qrScanState!) {
      bool result = scanData.code!.contains('obsws://');
      if (result != _qrScanState) {
        setState(() {
          if (scanData.code != null) {
            _qrScanState = result;
            if (_qrScanState!) {
              _scanLocked = true;
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pop(
                  _connectionFromQR(scanData.code!),
                );
              });
            } else {
              Future.delayed(
                const Duration(seconds: 3),
                () {
                  if (_qrScanState != null && !_qrScanState!) {
                    setState(() => _qrScanState = null);
                  }
                },
              );
            }
          } else {
            _qrScanState = null;
          }
        });
      }
    }
  }

  Connection _connectionFromQR(String data) {
    String host = data.split('//')[1].split(':')[0];

    String portAndPW = data.split(':')[2];

    int? port;
    String? pw;

    if (portAndPW.contains('/')) {
      port = int.tryParse(data.split(':')[2].split('/')[0]);

      pw = data.split('//')[1].split('/')[1];
    } else {
      port = int.tryParse(data.split(':')[2]);
    }

    return Connection(host, port, pw);
  }

  @override
  Widget build(BuildContext context) {
    return TransculentCupertinoNavBarWrapper(
      leading: Transform.scale(
        scale: 0.8,
        child: const QuestionMarkTooltip(
            message:
                '您可以在以下位置找到 QR 码：\n\n工具 -> WebSocket 服务器设置 -> 显示连接信息'),
      ),
      title: '快速连接',
      actions: ThemedCupertinoButton(
        padding: const EdgeInsets.all(0),
        text: '关闭',
        onPressed: () => Navigator.of(context).pop(),
      ),
      customBody: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                BaseProgressIndicator(
                  text: '初始化相机...',
                ),
                QRView(
                  key: _key,
                  overlay: QrScannerOverlayShape(
                    borderRadius: 0,
                  ),
                  formatsAllowed: const [BarcodeFormat.qrcode],
                  onQRViewCreated: (controller) {
                    setState(() => _controller = controller);
                    _controller!.scannedDataStream.listen(
                      (scanData) {
                        _handleScanData(scanData);
                      },
                    );
                  },
                  onPermissionSet: (_, permission) {
                    if (!permission) {
                      ModalHandler.showBaseDialog(
                        context: context,
                        barrierDismissible: true,
                        dialogWidget: InfoDialog(
                          body:
                              'OBS Blade 无权使用您的相机。 如果不使用摄像头，此功能将无法使用，因为我们将扫描 WebSocket 插件提供的二维码。\n\n如果您改变主意并想要使用此功能，请转至：\n\n设置 -> OBS Blade （向下滚动）-> 打开相机',
                          onPressed: (_) => Navigator.of(context).pop(),
                        ),
                      );
                    } else {
                      setState(() => _permission = permission);
                    }
                  },
                ),
              ],
            ),
          ),
          SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height / 5,
              child: _controller != null && _permission
                  ? _qrScanState == null
                      ? BaseProgressIndicator(
                          text: '扫描二维码...',
                        )
                      : _qrScanState!
                          ? const BaseResult(
                              icon: BaseResultIcon.Positive,
                              iconColor: CupertinoColors.activeGreen,
                              text: '找到快速连接二维码!',
                            )
                          : const BaseResult(
                              icon: BaseResultIcon.Negative,
                              iconColor: CupertinoColors.destructiveRed,
                              text: '二维码错误!',
                            )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
