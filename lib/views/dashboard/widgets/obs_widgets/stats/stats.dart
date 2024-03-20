import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:obs_blade/shared/general/question_mark_tooltip.dart';
import 'package:obs_blade/types/extensions/int.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../shared/general/formatted_text.dart';
import '../../../../../stores/views/dashboard.dart';
import 'stats_container.dart';

class Stats extends StatefulWidget {
  final EdgeInsets? pageIndicatorPadding;

  const Stats({super.key, this.pageIndicatorPadding});

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    DashboardStore dashboardStore = GetIt.instance<DashboardStore>();

    return Column(
      children: [
        Padding(
          padding: this.widget.pageIndicatorPadding ??
              const EdgeInsets.only(
                top: 12.0,
              ),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: ScrollingDotsEffect(
              activeDotColor: Theme.of(context)
                  .switchTheme
                  .trackColor!
                  .resolve({MaterialState.selected})!,
              dotHeight: 10.0,
              dotWidth: 10.0,
            ),
          ),
        ),
        Expanded(
          child: Observer(builder: (context) {
            return PageView(
              controller: _pageController,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: StatsContainer(
                    title: 'OBS 统计数据',
                    trailing: const QuestionMarkTooltip(
                        message:
                            '带*的统计数据是OBS的统计数据，而不是您的计算机的统计数据.'),
                    children: [
                      FormattedText(
                        label: 'FPS',
                        text: dashboardStore.latestOBSStats?.activeFps
                            .round()
                            .toString(),
                      ),
                      FormattedText(
                        label: 'CPU*',
                        unit: '%',
                        text: dashboardStore.latestOBSStats?.cpuUsage != null
                            ? (dashboardStore.latestOBSStats!.cpuUsage)
                                .toStringAsFixed(2)
                            : null,
                        width: 75.0,
                      ),
                      FormattedText(
                        label: '内存使用情况*',
                        unit: ' GB',
                        text: dashboardStore.latestOBSStats?.memoryUsage != null
                            ? (dashboardStore.latestOBSStats!.memoryUsage /
                                    1000)
                                .toStringAsFixed(2)
                            : null,
                        width: 100.0,
                      ),
                      FormattedText(
                        label: '可用磁盘空间',
                        unit: ' GB',
                        text:
                            dashboardStore.latestOBSStats?.availableDiskSpace !=
                                    null
                                ? (dashboardStore.latestOBSStats!
                                            .availableDiskSpace /
                                        1000)
                                    .toStringAsFixed(2)
                                : null,
                        width: 120.0,
                      ),
                      FormattedText(
                        label: '平均帧渲染时间',
                        unit: ' milliseconds',
                        text: dashboardStore
                            .latestOBSStats?.averageFrameRenderTime
                            .toStringAsFixed(4),
                        width: 160.0,
                      ),
                      FormattedText(
                        label: '总渲染帧数',
                        text: dashboardStore.latestOBSStats?.renderTotalFrames
                            .toString(),
                        width: 120.0,
                      ),
                      FormattedText(
                        label: '跳过渲染帧',
                        text: dashboardStore.latestOBSStats?.renderSkippedFrames
                            .toString(),
                        width: 140.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: StatsContainer(
                    title: '推流',
                    children: [
                      FormattedText(
                        label: '推流时长',
                        text: dashboardStore.latestStreamStats?.totalTime
                            .secondsToFormattedDurationString(),
                        width: 100,
                      ),
                      FormattedText(
                        label: 'kbit/s',
                        text: dashboardStore.latestStreamStats?.kbitsPerSec
                            .toString(),
                        width: 80,
                      ),
                      FormattedText(
                        label: '总输出帧数',
                        text: dashboardStore
                            .latestStreamStats?.outputTotalFrames
                            .toString(),
                        width: 120.0,
                      ),
                      FormattedText(
                        label: '跳过的输出帧',
                        text: dashboardStore
                            .latestStreamStats?.outputSkippedFrames
                            .toString(),
                        width: 135.0,
                      ),
                      FormattedText(
                        label: '总渲染帧数',
                        text: dashboardStore
                            .latestStreamStats?.renderTotalFrames
                            .toString(),
                        width: 120.0,
                      ),
                      FormattedText(
                        label: '跳过渲染帧',
                        text: dashboardStore
                            .latestStreamStats?.renderSkippedFrames
                            .toString(),
                        width: 135.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: StatsContainer(
                    title: '录制',
                    children: [
                      FormattedText(
                        label: '录制时长',
                        text: dashboardStore.latestRecordStats?.totalTime
                            .secondsToFormattedDurationString(),
                        width: 100,
                      ),
                      FormattedText(
                        label: 'kbit/s',
                        text: dashboardStore.latestRecordStats?.kbitsPerSec
                            .toString(),
                        width: 80,
                      ),
                      FormattedText(
                        label: '总输出帧数',
                        text: dashboardStore.isRecording
                            ? dashboardStore
                                .latestRecordStats?.outputTotalFrames
                                .toString()
                            : null,
                        width: 120.0,
                      ),
                      FormattedText(
                        label: '跳过的输出帧',
                        text: dashboardStore.isRecording
                            ? dashboardStore
                                .latestRecordStats?.outputSkippedFrames
                                .toString()
                            : null,
                        width: 135.0,
                      ),
                      FormattedText(
                        label: '总渲染帧数',
                        text: dashboardStore.isRecording
                            ? dashboardStore
                                .latestRecordStats?.renderTotalFrames
                                .toString()
                            : null,
                        width: 120.0,
                      ),
                      FormattedText(
                        label: '跳过渲染帧',
                        text: dashboardStore.isRecording
                            ? dashboardStore
                                .latestRecordStats?.renderSkippedFrames
                                .toString()
                            : null,
                        width: 135.0,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
