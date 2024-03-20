import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../stores/views/logs.dart';

import '../../../shared/general/transculent_cupertino_navbar_wrapper.dart';
import 'widgets/log_explanation.dart';
import 'widgets/log_filter.dart';
import 'widgets/log_grid/log_list.dart';

class LogsView extends StatelessWidget {
  const LogsView({Key? key});

  @override
  Widget build(BuildContext context) {
    GetIt.instance.resetLazySingleton<LogsStore>();

    return Scaffold(
      body: TransculentCupertinoNavBarWrapper(
        previousTitle: '设置',
        title: '日志',
        showScrollBar: true,
        listViewChildren: const [
          LogExplanation(),
          LogFilter(),
          LogList(),
        ],
      ),
    );
  }
}
