import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/styling_helper.dart';

class PrivacyPolicyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        previousPageTitle: 'Settings',
        middle: Text('Privacy Policy'),
      ),
      body: CustomScrollView(
        physics: StylingHelper.platformAwareScrollPhysics,
        slivers: [],
      ),
    );
  }
}
