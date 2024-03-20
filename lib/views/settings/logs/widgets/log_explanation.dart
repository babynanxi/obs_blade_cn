import 'package:flutter/material.dart';
import '../../../../models/enums/log_level.dart';

import '../../../../shared/general/base/card.dart';
import '../../../../shared/general/custom_expansion_tile.dart';
import '../../../../shared/general/enumeration_block/enumeration_block.dart';
import '../../../../shared/general/enumeration_block/enumeration_entry.dart';
import '../../../../shared/general/themed/rich_text.dart';

class LogExplanation extends StatelessWidget {
  const LogExplanation({Key? key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      bottomPadding: 12.0,
      child: CustomExpansionTile(
        headerText: '有关日志的信息',
        headerPadding: const EdgeInsets.all(0.0),
        expandedBody: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),
            const Text(
                '此处列出的日志是我以编程方式创建的，并且仅在本地可用。 我不会将它们发送到任何服务器或类似服务器。 如果您遇到任何问题并且愿意为我提供更多信息以供处理，或者甚至想尝试自己解决问题，您可以在这里查看它们并决定分享它们（例如与我分享）！'),
            const SizedBox(height: 12.0),
            const Text(
                '您可以在此处有选择地删除日志条目，也可以在设置选项卡的“数据管理”中一起删除日志条目.'),
            const SizedBox(height: 12.0),
            const Text('Used log types:'),
            const SizedBox(height: 4.0),
            EnumerationBlock(
              customEntries: [
                EnumerationEntry(
                  customEntry: ThemedRichText(
                    textSpans: [
                      TextSpan(
                        text: '输出',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: LogLevel.Info.color,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ': 由使用过的软件包触发或由我自己手动触发以提供有用的信息',
                      ),
                    ],
                  ),
                ),
                EnumerationEntry(
                  customEntry: ThemedRichText(
                    textSpans: [
                      TextSpan(
                        text: '警告',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: LogLevel.Warning.color,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ':由我手动触发以记录重要信息/事件',
                      ),
                    ],
                  ),
                ),
                EnumerationEntry(
                  customEntry: ThemedRichText(
                    textSpans: [
                      TextSpan(
                        text: '错误',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: LogLevel.Error.color,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ':  由不同类型的异常和（大部分）意外事件触发',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            const Text(
                '日志按天分组，并且可以进行过滤以更轻松地找到相关日志。 请随时提出改进建议！')
          ],
        ),
      ),
    );
  }
}
