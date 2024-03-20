import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart' as mob_x;
import 'package:obs_blade/types/enums/web_socket_codes/web_socket_close_code.dart';

import '../../models/enums/log_level.dart';
import '../../shared/dialogs/info.dart';
import '../../shared/general/custom_sliver_list.dart';
import '../../shared/general/themed/cupertino_scaffold.dart';
import '../../shared/overlay/base_progress_indicator.dart';
import '../../shared/overlay/base_result.dart';
import '../../stores/shared/network.dart';
import '../../stores/views/home.dart';
import '../../utils/general_helper.dart';
import '../../utils/modal_handler.dart';
import '../../utils/overlay_handler.dart';
import '../../utils/routing_helper.dart';
import '../../utils/styling_helper.dart';
import 'widgets/connect_box/connect_box.dart';
import 'widgets/refresher_app_bar/refresher_app_bar.dart';
import 'widgets/saved_connections/saved_connections.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// Since I'm using (at least one) reaction in this State, I need to dispose
  /// it when this Widget / State is disposing itself as well. I add each reaction call
  /// to this list and dispose every instance in the dispose call of this Widget
  /// 由于我在这种状态下使用（至少一个）反应，所以我需要处理
  /// 当这个 Widget/State 也正在处置自己时。 我添加每个反应调用
  /// 到此列表并在此 Widget 的 dispose 调用中处置每个实例
  final List<mob_x.ReactionDisposer> _disposers = [];

  /// Using [didChangeDependencies] since it is called after [initState] and has access
  /// to a [BuildContext] of this [StatelessWidget] which we need to access the MobX
  /// stores through Provider; GetIt.instance<NetworkStore>() for example
  ///
  /// NEW: Not making use of [didChangeDependencies] since it gets triggered quite often.
  /// Initially I wanted to use this since I thought I would have access to a context
  /// where the provided ViewModel for this View is accessible, but since the context
  /// passed to our build method is the one from the parent, we won't have access to the
  /// provided ViewModel on this way at all - thats why i used the Facade Pattern and
  /// used a Wrapper Widget which has the only pupose to expose the ViewModel via Provider
  /// and making it accessible with the given context here (NEW: this has also been changed
  /// since I switched to GetIt which registers the stores globally (without context) and we
  /// don't need to initialize them in a facade pattern manner and do it in main but now need
  /// to reset those stores). The reactions I registered here should only be registered once
  /// (making use of reaction and when) so thats why its now in [initState]
  ///
  /// Since I'm checking here if the [obsTerminated] value is true (meaning we came to this
  /// view because OBS has terminated) I want to disaplay dialog informing the user about it.
  /// [initState] will get called relatively fast, in this case during the
  /// [pushReplacementNamed] call. Since showing a dialog is also using [Navigator] stuff (it
  /// will push the dialog into the stack) we will get an exepction indicating that problem.
  /// To avoid that I added [SchedulerBinding.instance.addPostFrameCallback] which ensures that
  /// our dialog is pushed when the current build/render cycle is done, thats where our
  /// [pushReplacementNamed] is done and it is safe to use [Navigator] again
     /// 使用 [didChangeDependency]，因为它是在 [initState] 之后调用并具有访问权限
     /// 到我们需要访问 MobX 的 [StatelessWidget] 的 [BuildContext]
     /// 通过Provider存储； 例如 GetIt.instance<NetworkStore>()
     ///
     /// 新：不使用 [didChangeDependency]，因为它经常被触发。
     /// 最初我想使用它，因为我认为我可以访问上下文
     /// 为该视图提供的 ViewModel 是可访问的，但由于上下文
     /// 传递给我们的构建方法的是来自父级的方法，我们将无权访问
     /// 以这种方式提供 ViewModel - 这就是我使用 Facade 模式的原因
     /// 使用了 Wrapper Widget，其唯一目的是通过 Provider 公开 ViewModel
     /// 并使其可以通过此处给定的上下文进行访问（新：这也已更改
     /// 自从我切换到 GetIt 后，它在全局范围内注册商店（没有上下文）并且我们
     /// 不需要以外观模式方式初始化它们并在 main 中执行，但现在需要
     /// 重置这些存储）。 我在这里注册的反应只能注册一次
     /// （利用反应和时间）这就是为什么它现在处于 [initState]
     ///
     /// 因为我在这里检查 [obsTermminate] 值是否为 true（这意味着我们来到了这个
     /// 查看，因为 OBS 已终止）我想显示对话框，通知用户相关信息。
     /// [initState] 将被相对较快地调用，在本例中是在
     /// [pushReplacementNamed] 调用。 由于显示对话框也使用 [Navigator] 东西（它
     /// 将把对话框压入堆栈）我们将得到一个指示该问题的异常。
     /// 为了避免这种情况，我添加了 [SchedulerBinding.instance.addPostFrameCallback] 以确保
     /// 当当前构建/渲染周期完成时，我们的对话框被推送，这就是我们的对话框
     /// [pushReplacementNamed] 已完成，可以安全地再次使用 [Navigator]
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 0),
      () => GetIt.instance<HomeStore>().updateAutodiscoverConnections(),
    );

    /// I have to import the MobX part above with 'as MobX' since the Widget Listener
    /// is part of Material and MobX therefore it can't be resolved on its own. By
    /// naming one import I have to exlicitly use the import name as an prefix to
    /// define which one i mean
    ///
    /// This case here: 'Listener' Widget is part of Material and MobX; I'm using Listener
    /// in my Widget tree; I named the MobX import so now if I mean the MobX 'Listener' I would
    /// have to write 'MobX.Listener', otherwise it's the Material one. Since I'm using Material
    /// stuff here most of the time i named the MobX import instead ob the Material one
         /// 由于 Widget Listener，我必须使用 'as MobX' 导入上面的 MobX 部分
         /// 是 Material 和 MobX 的一部分，因此它无法单独解析。 经过
         /// 命名一个导入我必须明确使用导入名称作为前缀
         /// 定义我的意思是哪一个
         ///
         /// 这里的情况：“Listener”Widget 是 Material 和 MobX 的一部分； 我正在使用监听器
         /// 在我的小部件树中； 我将 MobX 导入命名为 MobX 导入，所以现在如果我指的是 MobX“监听器”，我会
         /// 必须写'MobX.Listener'，否则它就是Material 的。 由于我使用的是材质
         /// 大多数时候我把 MobX 导入命名为 MobX import，而不是 Material 导入
    mob_x.when((_) => GetIt.instance<NetworkStore>().obsTerminated, () {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        GeneralHelper.advLog(
          'Your connection to OBS has been lost and the app was not able to reconnect.',
          level: LogLevel.Warning,
          includeInLogs: true,
        );
        if (this.mounted) {
          ModalHandler.showBaseDialog(
            context: context,
            barrierDismissible: true,
            dialogWidget: const InfoDialog(
                body:
                    'Your connection to OBS has been lost and the app was not able to reconnect.'),
          ).then(
            (_) => GetIt.instance<HomeStore>().updateAutodiscoverConnections(),
          );
        }
      });
    });

    /// Once we recognize a connection attempt inside our reaction ([connectionInProgress] is true)
    /// we will check whether the connection was successfull or not and display overlays and / or
    /// route to the [DashboardView]
         /// 一旦我们在反应中识别出连接尝试（[connectionInProgress] 为 true）
         /// 我们将检查连接是否成功并显示覆盖和/或
         /// 路由到[DashboardView]
    _disposers.add(mob_x
        .reaction((_) => GetIt.instance<NetworkStore>().connectionInProgress,
            (bool connectionInProgress) {
      NetworkStore networkStore = GetIt.instance<NetworkStore>();

      if (connectionInProgress) {
        OverlayHandler.showStatusOverlay(
          context: context,
          showDuration: const Duration(seconds: 5),
          content: BaseProgressIndicator(
            text: 'Connecting...',
          ),
        );
      } else if (!connectionInProgress) {
        if ((networkStore.connectionClodeCode ??
                WebSocketCloseCode.UnknownReason) ==
            WebSocketCloseCode.DontClose) {
          OverlayHandler.closeAnyOverlay(immediately: true);
          Navigator.pushReplacementNamed(
            context,
            HomeTabRoutingKeys.Dashboard.route,
            arguments: ModalRoute.of(context)!.settings.arguments,
          );
        }

        /// If the error for the connection attempt results in an 'Authentication' error,
        /// it is due to providing a wrong password (or none at all) and we don't want to
        /// display an overlay for that - we trigger the validation of the password field
        /// in our [ConnectForm]
        /// 如果连接尝试的错误导致“身份验证”错误，
        /// 这是由于提供了错误的密码（或根本没有密码）而我们不想这样做
        /// 显示覆盖层 - 我们触发密码字段的验证
        /// 在我们的 [ConnectForm] 中
        else if ([
          WebSocketCloseCode.DontClose,
          WebSocketCloseCode.AuthenticationFailed
        ].every((closeCode) => closeCode != networkStore.connectionClodeCode)) {
          OverlayHandler.showStatusOverlay(
            context: context,
            replaceIfActive: true,
            content: const Align(
              alignment: Alignment.center,
              child: BaseResult(
                icon: BaseResultIcon.Negative,
                text: '无法连接到 WebSocket。',
              ),
            ),
          );
        } else {
          OverlayHandler.closeAnyOverlay(immediately: true);
        }
      }
    }));
  }

  @override
  void dispose() {
    super.dispose();

    /// disposing each [ReactionDisposer] of our MobX reactions
    for (var d in _disposers) {
      d();
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeStore homeStore = GetIt.instance<HomeStore>();
    return ThemedCupertinoScaffold(
      /// refreshable is being maintained in our RefresherAppBar - as soon as we reach
      /// our extendedHeight, where we are ready to trigger searching for OBS connections,
      /// it is being set to true, false otherwise. I want to trigger the actual refresh only
      /// if, once the extendedHeight is reached, the user lets go off the screen and could just
      /// scroll up again without triggering a refresh (feels more natural in my opinion)
      body: Listener(
        onPointerUp: (_) {
          if (homeStore.refreshable) {
            /// Used to globally (at least where [HomeStore] is listened to) to act on the
            /// refresh action which has now been triggered
            homeStore.initiateRefresh();

            /// Switch back to autodiscover mode (of our [SwitcherCard]) if we refresh so the
            /// user can actually see the part thats refreshing
            if (homeStore.connectMode != ConnectMode.Autodiscover) {
              homeStore.setConnectMode(ConnectMode.Autodiscover);
            }
            homeStore.updateAutodiscoverConnections();
          }
        },
        child: CustomScrollView(
          physics: StylingHelper.platformAwareScrollPhysics,
          controller:
              ModalRoute.of(context)!.settings.arguments as ScrollController,

          /// Scrolling has a unique behaviour on iOS and macOS where we bounce as soon as
          /// we reach the end. Since we are using the stretch of [RefresherAppBar], which uses
          /// [SliverAppBar] internally, to refresh (looking for OBS connections) we need to
          /// be able to scroll even though we reached the end. To achieve this we need different behaviour
          /// for iOS (macOS) and Android (and possibly the rest) where we use [AlwaysScrollableScrollPhysics]
          /// for the first group and [BouncingScrollPhysics] for the second
          // physics: StylingHelper.platformAwareScrollPhysics,
          slivers: const [
            RefresherAppBar(
              expandedHeight: 200.0,
            ),
            CustomSliverList(
              children: [
                ConnectBox(),
                SavedConnections(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
