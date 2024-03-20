import 'package:flutter/material.dart';

import 'stats/stats.dart';
import 'stream_chat/stream_chat.dart';

class OBSWidgetsMobile extends StatelessWidget {
  const OBSWidgetsMobile({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Theme.of(context)
                    .cupertinoOverrideTheme!
                    .barBackgroundColor,
                child: const TabBar(
                  tabs: [
                    Tab(
                      child: Text('聊天'),
                    ),
                    Tab(
                      child: Text('统计数据'),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 720.0,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
                      child: StreamChat(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Stats(
                        pageIndicatorPadding: EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
