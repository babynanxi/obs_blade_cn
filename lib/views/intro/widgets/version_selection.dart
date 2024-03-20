import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:obs_blade/shared/animator/selectable_box.dart';
import 'package:obs_blade/shared/general/base/card.dart';
import 'package:obs_blade/shared/general/base/constrained_box.dart';
import 'package:obs_blade/shared/general/question_mark_tooltip.dart';
import 'package:obs_blade/shared/general/themed/cupertino_button.dart';
import 'package:obs_blade/stores/views/intro.dart';

class VersionSelection extends StatefulWidget {
  const VersionSelection({super.key});

  @override
  State<VersionSelection> createState() => _VersionSelectionState();
}

class _VersionSelectionState extends State<VersionSelection> {
  IntroStage? _nextStage;

  @override
  Widget build(BuildContext context) {
    return BaseConstrainedBox(
      hasBasePadding: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '首先，请选择您所使用的OBS版本。 这将决定您需要做什么才能将此应用程序与您的 OBS 实例一起使用！',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontSize: 18,
                ),
          ),
          BaseCard(
            paintBorder: true,
            topPadding: 32.0,
            bottomPadding: 18.0,
            borderColor: Theme.of(context).dividerColor.withOpacity(0.2),
            title: '选择您的obs版本',
            trailingTitleWidget: const QuestionMarkTooltip(
                message:
                    '在哪里可以找到OBS实例的版本取决于您的操作系统:\n\nWindows / Linux:\n帮助 -> 关于\n\nmacOS:\nOBS -> 关于 OBS'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SelectableBox(
                    colorUnselected: Theme.of(context).scaffoldBackgroundColor,
                    selected: _nextStage == IntroStage.TwentyEightParty,
                    text: '28.X 以上',
                    onTap: () => setState(
                        () => _nextStage = IntroStage.TwentyEightParty),
                  ),
                  SelectableBox(
                    colorUnselected: Theme.of(context).scaffoldBackgroundColor,
                    selected: _nextStage == IntroStage.InstallationSlides,
                    text: '27.X 以上',
                    onTap: () => setState(
                        () => _nextStage = IntroStage.InstallationSlides),
                  ),
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () =>
          //       setState(() => _nextStage = IntroStage.TwentyEightParty),
          //   child: BaseCard(
          //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //     constrainedAlignment: CrossAxisAlignment.center,
          //     leftPadding: 0,
          //     rightPadding: 0,
          //     paintBorder: _nextStage == IntroStage.TwentyEightParty,
          //     borderColor: _nextStage == IntroStage.TwentyEightParty
          //         ? Theme.of(context)
          //             .switchTheme
          //             .trackColor!
          //             .resolve({MaterialState.selected})
          //         : null,
          //     title: 'OBS Version 28.X and above',
          //     titlePadding: const EdgeInsets.all(12),
          //     child: const Text('OBS Version >= 28.X'),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () =>
          //       setState(() => _nextStage = IntroStage.InstallationSlides),
          //   child: BaseCard(
          //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //     constrainedAlignment: CrossAxisAlignment.center,
          //     leftPadding: 0,
          //     rightPadding: 0,
          //     paintBorder: _nextStage == IntroStage.InstallationSlides,
          //     borderColor: _nextStage == IntroStage.InstallationSlides
          //         ? Theme.of(context)
          //             .switchTheme
          //             .trackColor!
          //             .resolve({MaterialState.selected})
          //         : null,
          //     title: 'OBS version 27.X and below',
          //     titlePadding: const EdgeInsets.all(12),
          //     child: const Text('OBS Version < 28.X'),
          //   ),
          // ),
          ThemedCupertinoButton(
            onPressed: _nextStage != null
                ? () => GetIt.instance<IntroStore>().setStage(_nextStage!)
                : null,
            text: '继续',
          ),
        ],
      ),
    );
  }
}
