import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:obs_blade/shared/general/base/constrained_box.dart';
import 'package:obs_blade/shared/general/base/divider.dart';

import '../../../../shared/general/social_block.dart';
import '../../../../shared/general/themed/rich_text.dart';
import '../../../../stores/views/intro.dart';
import 'intro_slide.dart';
import 'slide_controls.dart';

const double kIntroControlsBottomPadding = 12.0;

class IntroSlides extends StatefulWidget {
  final bool manually;

  const IntroSlides({super.key, this.manually = false});

  @override
  _IntroSlidesState createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {
  final PageController _pageController = PageController();
  late List<Widget> _pageChildren;

  /// Will be used to force the user to stay on a slide for a given time
  /// before being able to move on. This will ensure they at least see
  /// a slide for a speciic time and hopefully use this time to take
  /// a look at the instrcutions / possibilities
  // Timer? _timerToContinue;
  /// 将用于强制用户在给定时间内停留在幻灯片上
   /// 在能够继续之前。 这将确保他们至少看到
   /// 特定时间的幻灯片并希望利用这个时间来拍摄
   /// 看一下说明/可能性
   // 定时器？ _timerToContinue；

  final List<bool> _pagesLockedPreviously = [false, false, false];
  final List<bool> _pagesToLockOn = [true, true, true];

  final List<ReactionDisposer> _disposers = [];

  @override
  void initState() {
    super.initState();

    IntroStore introStore = GetIt.instance<IntroStore>();
    introStore.setCurrentPage(0);

    _checkAndSetSlideLock(introStore, 0);

    _disposers.add(reaction<int>(
      (_) => introStore.currentPage,
      (currentPage) {
        _checkAndSetSlideLock(introStore, currentPage);
      },
    ));
  }

  void _checkAndSetSlideLock(IntroStore introStore, int currentPage) {
    if (!this.widget.manually &&
        _pagesToLockOn[currentPage] &&
        !_pagesLockedPreviously[currentPage]) {
      introStore.setLockedOnSlide(true);
    }
  }

  @override
  void dispose() {
    for (var d in _disposers) {
      d();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageChildren = [
      IntroSlide(
        imagePath: 'assets/images/intro/intro_obs_websocket_page.png',
        child: ThemedRichText(
          textSpans: [
            const TextSpan(
              text:
                  '访问 OBS WebSocket GitHub 页面以获取使该应用程序运行的插件:\n\n',
            ),
            WidgetSpan(
              child: SocialBlock(
                topPadding: 0,
                bottomPadding: 0,
                socialInfos: [
                  SocialEntry(
                    link: 'https://github.com/obsproject/obs-websocket',
                    textStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
            const TextSpan(
              text:
                  '\n\n单击“下载”部分中的“发布”链接，如屏幕截图所示或 ',
            ),
            WidgetSpan(
              child: SocialBlock(
                topPadding: 0.0,
                bottomPadding: 0.0,
                socialInfos: [
                  SocialEntry(
                    linkText: 'here',
                    link:
                        'https://github.com/obsproject/obs-websocket/releases',
                    textStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
          ],
          textAlign: TextAlign.left,
          textStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 16,
              ),
        ),
      ),
      IntroSlide(
        imagePath: 'assets/images/intro/intro_obs_websocket_download.png',
        child: ThemedRichText(
          textSpans: const [
            TextSpan(
              text:
                  '向下滚动到“资产”并下载正确的安装程序（适用于您的操作系统）\n\n',
            ),
            TextSpan(
              text: 'IMPORTANT: Download version 5.X and above!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
          textAlign: TextAlign.left,
          textStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 16,
              ),
        ),
      ),
      IntroSlide(
        imagePath: 'assets/images/intro/intro_obs_websocket_settings.png',
        child: ThemedRichText(
          textSpans: const [
            TextSpan(
              text:
                  '安装插件并重新启动 OBS 后，检查工具 -> WebSocket 服务器设置是否可用，并使用推荐设置（如上）',
            ),
          ],
          textAlign: TextAlign.left,
          textStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 16,
              ),
        ),
      ),
    ];

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pageChildren.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Center(
                  child: BaseConstrainedBox(
                    child: _pageChildren[index],
                  ),
                ),
                onPageChanged: (page) =>
                    GetIt.instance<IntroStore>().setCurrentPage(page),
              ),
            ),
            const BaseDivider(),
            const SizedBox(height: 12.0),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom +
                    kIntroControlsBottomPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: min(
                    MediaQuery.sizeOf(context).width * 0.75,
                    500.0,
                  ),
                ),
                child: SlideControls(
                  pageController: _pageController,
                  amountChildren: _pageChildren.length,
                  manually: this.widget.manually,
                  onSlideLockWaited: () => _pagesLockedPreviously[
                      GetIt.instance<IntroStore>().currentPage] = true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
