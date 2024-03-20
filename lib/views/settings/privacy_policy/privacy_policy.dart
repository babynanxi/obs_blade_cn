import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/general/social_block.dart';
import '../../../shared/general/themed/rich_text.dart';
import '../../../utils/icons/jam_icons.dart';

import '../../../shared/general/base/card.dart';
import '../../../shared/general/transculent_cupertino_navbar_wrapper.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransculentCupertinoNavBarWrapper(
        previousTitle: '设置',
        title: '隐私政策',
        listViewChildren: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              children: [
                const Icon(
                  CupertinoIcons.doc_person_fill,
                  size: 92.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '隐私政策',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ThemedRichText(
                  textSpans: [
                    TextSpan(
                      text: '现在 ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text:
                          'OBS Blade 不会自行收集任何数据并将其发送到任何类型的服务器！ 相应的应用程序商店（Google Play 商店和 Apple 应用程序商店）将收集有关应用程序使用情况、崩溃等的分析数据，但我不会收集任何内容。 如果您想更多地了解这些应用程序商店收集的内容，请查看他们的隐私政策:',
                    ),
                  ],
                ),
                SocialBlock(
                  socialInfos: [
                    SocialEntry(
                      icon: JamIcons.google,
                      iconSize: 24.0,
                      link: 'https://policies.google.com/privacy',
                      linkText: 'Google Privacy Policy',
                    ),
                    SocialEntry(
                      icon: JamIcons.apple,
                      link: 'https://apple.com/legal/privacy/en-ww/',
                      linkText: 'Apple Privacy Policy',
                    ),
                  ],
                ),
                const Text(
                  '我稍后可能会添加第三方提供商来帮助我解决设备同步、错误处理、反馈、统计等问题，如果我这样做并且该第三方提供商收集了有关您的任何个人数据，我会将其添加到此 隐私政策！ 由于数据隐私对我来说非常重要，因此我会尽量严格地选择与哪个第三方合作。\n\n如果您对自己的数据有任何疑虑或希望帮助我在这方面进行改进，请不要\' 请随时与我联系。 您可以访问应用程序内的“关于”页面，查看与我联系的可能方式。 就此类事情联系我的首选方式是通过电子邮件:',
                ),
                SocialBlock(
                  socialInfos: [
                    SocialEntry(
                      icon: CupertinoIcons.mail_solid,
                      iconSize: 24.0,
                      link: 'mailto:contact@kounex.com',
                      linkText: 'contact@kounex.com',
                    ),
                  ],
                ),
                const Text('谢谢阅读! :)')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
