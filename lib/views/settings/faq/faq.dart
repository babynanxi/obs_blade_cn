import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/general/base/card.dart';
import '../../../shared/general/base/divider.dart';
import '../../../shared/general/enumeration_block/enumeration_block.dart';
import '../../../shared/general/enumeration_block/enumeration_entry.dart';
import '../../../shared/general/transculent_cupertino_navbar_wrapper.dart';
import 'widgets/faq_block.dart';

const kFAQSpaceHeight = 32.0;

class FAQView extends StatelessWidget {
  const FAQView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransculentCupertinoNavBarWrapper(
        previousTitle: '设置',
        title: 'FAQ | 帮助',
        listViewChildren: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
              right: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Flexible(
                  child: Icon(
                    CupertinoIcons.chat_bubble_text_fill,
                    size: 92.0,
                  ),
                ),
                const SizedBox(width: 24.0),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '经常问的问题',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '由于我收到了一些有关使用 OBS Blade 的疑问和问题，因此我尝试在这里整理一些信息，如果其他人遇到问题或不确定某些功能/可能性，这些信息也可能会对其他人有所帮助。'),
                BaseDivider(height: 32),
                FAQBlock(
                  heading: '为什么自动发现找不到我的 OBS 实例？',
                  customBody: EnumerationBlock(
                    title:
                        '对于该问题，必须检查几件事:',
                    customEntries: [
                      EnumerationEntry(
                        text:
                            '确保您使用的是最新版本的 OBS、OBS WebSocket 和 OBS Blade',
                      ),
                      EnumerationEntry(
                        text:
                            '使用OBS Blade的设备需要通过 WLAN 连接，并且需要与运行OBS的设备在同一网络中',
                      ),
                      EnumerationEntry(
                        text:
                            'OBS运行的端口未打开。您的防火墙可能会阻止该端口，或者您的路由器可能不允许与该端口通信',
                      ),
                      EnumerationEntry(
                        text:
                            '在iOS上：确保您在手机设置中启用了 "本地网络权限" 在您的手机设置中:\设置 > 隐私 > 本地网络 > OBS Blade',
                      ),
                      EnumerationEntry(
                        text:
                            '除了在同一网络中之外，它们还必须处于相同的IP范围（子网）。默认情况下，位于不同子网中的设备无法相互通信。请确保IP地址仅最后一位数字不同:',
                      ),
                      EnumerationEntry(
                        level: 2,
                        text:
                            '192.168.178.20 (OBS)\n192.168.120.90 (OBS Blade)\n错误的!',
                      ),
                      EnumerationEntry(
                        level: 2,
                        text:
                            '192.168.178.20 (OBS)\n192.168.178.90 (OBS Blade)\n正确的!',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kFAQSpaceHeight),
                FAQBlock(
                  heading: '我无法连接OBS，怎么办？',
                  customBody: EnumerationBlock(
                    title:
                        '在大多数情况下，如果 OBS 在自动发现中列出，您应该能够连接到它。 如果您因为 OBS 未在自动发现中列出而尝试手动连接到 OBS，则通常存在潜在问题（请检查上面的列表）。 另外检查一下:',
                    entries: [
                      '使用正确的密码（如果在 OBS WebSocket 设置中设置）)',
                      '可以使用给定的 IP 地址访问主机（运行 OBS 的设备）。 仅当两台设备位于同一网络且覆盖了前面的要点时，才能使用内部 IP 地址',
                    ],
                  ),
                ),
                SizedBox(height: kFAQSpaceHeight),
                FAQBlock(
                  heading: 'XY 功能何时可用?',
                  text:
                      '我有相当多的积压工作需要处理 - 有些东西我一般想要实现，有些是您要求的！ 我当前没有展示所有任务的公共板（将来可能会添加）。 如需功能请求/错误，请随时与我联系或查看 GitHub 页面！',
                ),
                SizedBox(height: kFAQSpaceHeight),
                FAQBlock(
                  heading: '我想我发现了一个错误！ 该怎么办?',
                  text:
                      '这个应用程序没有任何错误，它们当然都是功能...抛开所有笑话，请随时与我联系（检查“关于”页面以了解不同的方式）或检查 GitHub 页面是否有问题 - 如果您的错误未列出， 请添加新问题！ 如果它已经存在，请竖起大拇指或发表评论以强调它，以便我将重点修复它!',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
