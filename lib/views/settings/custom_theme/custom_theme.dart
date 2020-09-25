import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/general/base_card.dart';
import '../../../shared/general/themed/themed_cupertino_scaffold.dart';
import '../../../shared/general/transculent_cupertino_navbar_wrapper.dart';
import '../../../utils/modal_handler.dart';
import 'widgets/add_edit_theme/add_edit_theme.dart';
import 'widgets/custom_theme_list/custom_theme_list.dart';
import 'widgets/theme_active/theme_active.dart';

class CustomThemeView extends StatefulWidget {
  @override
  _CustomThemeViewState createState() => _CustomThemeViewState();
}

class _CustomThemeViewState extends State<CustomThemeView> {
  @override
  Widget build(BuildContext context) {
    return ThemedCupertinoScaffold(
      body: Builder(
        builder: (context) => TransculentCupertinoNavBarWrapper(
          previousTitle: 'Settings',
          title: 'Custom Theme',
          listViewChildren: [
            BaseCard(
              bottomPadding: 12.0,
              child: ThemeActive(),
            ),
            BaseCard(
              title: 'Predefined Themes',
              bottomPadding: 12.0,
              noPaddingChild: true,
              child: CustomThemeList(
                predefinedThemes: true,
              ),
            ),
            BaseCard(
              title: 'Your Themes',
              trailingTitleWidget: CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => ModalHandler.showBaseCupertinoBottomSheet(
                  context: context,
                  modalWidgetBuilder: (context, scrollController) =>
                      AddEditTheme(
                    scrollController: scrollController,
                  ),
                ),
                child: Text('Add Theme'),
              ),
              bottomPadding: 12.0,
              noPaddingChild: true,
              child: CustomThemeList(),
            ),
          ],
        ),
      ),
    );
  }
}