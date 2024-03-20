import 'package:flutter/cupertino.dart';

import '../../../shared/general/base/button.dart';
import '../../../shared/general/base/card.dart';
import '../../../shared/general/base/divider.dart';
import '../../../shared/general/social_block.dart';
import '../../../shared/general/themed/cupertino_scaffold.dart';
import '../../../shared/general/themed/rich_text.dart';
import '../../../shared/general/transculent_cupertino_navbar_wrapper.dart';
import '../../../utils/icons/jam_icons.dart';
import '../../../utils/modal_handler.dart';
import 'widgets/about_header.dart';
import 'widgets/license_modal/license_modal.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key});

  @override
  Widget build(BuildContext context) {
    return ThemedCupertinoScaffold(
      body: TransculentCupertinoNavBarWrapper(
        previousTitle: 'Settings',
        title: 'About',
        listViewChildren: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              children: [
                const AboutHeader(),
                // LightDivider(
                //   height: 32.0,
                // ),
                BaseCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Greetings!\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const ThemedRichText(
                        textSpans: [
                          TextSpan(
                              text:
                                  '希望您喜欢使用 OBS Blade。 如果您想与我联系，可以访问这些网站并向我发送消息。 目前，这也是让我了解任何错误/问题/功能请求的首选方式。 我会添加一些 '),
                          TextSpan(
                            text: '真实的',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: ' 未来如何做到这一点。\n\n'),
                        ],
                      ),
                      /* SocialBlock(
                        socialInfos: [
                          SocialEntry(
                            // svgPath: 'assets/svgs/twitter.svg',
                            icon: JamIcons.twitter,
                            link: 'https://twitter.com/Kounexx',
                            linkText: 'Twitter',
                          ),
                          SocialEntry(
                            // svgPath: 'assets/svgs/linkedin.svg',
                            icon: JamIcons.linkedin,
                            iconSize: 26.0,
                            link:
                                'https://www.linkedin.com/in/ren%C3%A9-schramowski-a35342157/',
                            linkText: 'LinkedIn',
                          ),
                          SocialEntry(
                            icon: CupertinoIcons.mail_solid,
                            iconSize: 24.0,
                            link: 'mailto:contact@kounex.com',
                            linkText: 'contact@kounex.com',
                          ),
                        ],
                      ), */
                      const Text(
                          'OBS Blade 是开源的，这意味着您可以了解幕后并查看实际的源代码。 我可能需要隐藏一些敏感的东西，例如密钥/令牌/凭据（显然），但其他所有内容都应该可以访问。'),
                      SocialBlock(
                        socialInfos: [
                          SocialEntry(
                            // svgPath: 'assets/svgs/twitter.svg',
                            icon: JamIcons.github,
                            link: 'https://github.com/Kounex/obs_blade',
                            linkText: 'GitHub',
                          ),
                        ],
                      ),

                      const Padding(padding: EdgeInsets.only(top: 14.0, bottom: 8.0)),

                      const Text('翻译工作由南兮完成'),
                      SocialBlock(
                        socialInfos: [
                          SocialEntry(
                            // svgPath: 'assets/svgs/twitter.svg',
                            icon: JamIcons.github,
                            link: 'https://github.com/babynanxi',
                            linkText: 'GitHub',
                          ),
                        ],
                      ),
                      const Text(
                          '这个应用程序（在很多情况下）最初是一个小型的热情项目，因为我希望能够在不需要任何第三方应用程序/设备的情况下动态控制 OBS。 有时我会自己直播一些与游戏相关的内容，所以如果你想顺便过来一下:'),
                      /* SocialBlock(
                        socialInfos: [
                          SocialEntry(
                            // svgPath: 'assets/svgs/twitter.svg',
                            icon: JamIcons.twitch,
                            link: 'https://www.twitch.tv/Kounex',
                            linkText: 'Twitch',
                          ),
                        ],
                      ), */
                      const BaseDivider(),
                      const Padding(
                        padding: EdgeInsets.only(top: 14.0, bottom: 8.0),
                        child: Text(
                            '有关所用库的简短概述，您可以查看此处：'),
                      ),
                      Builder(builder: (context) {
                        return BaseButton(
                          text: '制作人员',
                          onPressed: () =>
                              // showAboutDialog(context: context),
                              ModalHandler.showBaseCupertinoBottomSheet(
                            context: context,
                            includeCloseButton: false,
                            modalWidgetBuilder: (context, scrollController) =>
                                LicenseModal(
                              scrollController: scrollController,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // LightDivider(
                //   height: 32.0,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
