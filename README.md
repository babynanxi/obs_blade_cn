# OBS Blade

## 语言选择 language selection

[English](./README.en.md)
[中文](/README.md)

![alt text](https://assets.kounex.com/images/obs-blade/store_banner_3.png "OBS Blade Store Banner")

免责声明：此应用程序不以任何方式附属于 [OBS](https://github.com/obsproject/obs-studio)（开放广播软件）。

通过使用 OBS 的 WebSocket 插件，在使用 OBS 时控制和管理您的流和录制。 该项目是使用 Flutter 框架构建的，因此可以针对各种平台进行编译和部署。 此版本针对 iOS 和 Android（手机和平板电脑）进行了优化。

如果某些功能不起作用或者您想要添加功能请求，请随意创建问题，或者拉取此存储库并进行更改并自行构建！

## 准备

为了能够使用 OBS Blade 连接到 OBS，您需要安装 OBS WebSocket 插件。 根据您安装的 OBS Studio 版本，您要么必须手动安装，要么可以开箱即用。

如果您的OBS Studio版本是：

- 28.0 或更高版本：您已完成 🎉🎉🎉 - 自 OBS Studio 28.0 起，WebSocket 插件是 OBS Studio 开箱即用的一部分，您可以立即使用该应用程序！
- 低于28.0：需要手动安装WebSocket（如果可能，我建议升级OBS Studio本身）。 请按照以下步骤手动继续：
  
  - 访问 https://github.com/obsproject/obs-websocket/
  - 转到此 GitHub 页面的 [Release](https://github.com/obsproject/obs-websocket/releases) 部分，并下载适用于您的操作系统的版本 **5.X 及更高版本**（可在“资产”下找到） '）。
  - 安装此插件后，请确保至少重新启动 OBS Studio 一次
  - 现在您应该可以使用这个应用程序了！

运行 OBS Blade 的设备需要与运行 OBS 本身的设备位于同一网络中，并且自动发现功能应自行找到打开的 OBS 会话！ 您还可以输入运行 OBS 的设备的本地（内部）IP 地址（[如何查找我的本地 IP 地址](https://www.whatismybrowser.com/detect/what-is-my-local-ip-address )) 甚至输入域名！

## 特征

<div align="center">
  <div style="display: flex; align-items: flex-start;">
    <img src="https://assets.kounex.com/images/obs-blade/iphone_1.png" width="134">
    <img src="https://assets.kounex.com/images/obs-blade/iphone_2.png" width="134">
    <img src="https://assets.kounex.com/images/obs-blade/iphone_3.png" width="134">
    <img src="https://assets.kounex.com/images/obs-blade/iphone_4.png" width="134">
    <img src="https://assets.kounex.com/images/obs-blade/iphone_5.png" width="134">
    <img src="https://assets.kounex.com/images/obs-blade/iphone_6.png" width="134">
  </div>
</div>

OBS Blade 旨在成为您的直播伴侣，帮助您管理直播。 使用 OBS（开放广播软件）时，您可以连接到正在运行的实例并控制软件的重要部分。 这应该可以帮助您管理观众可以看到/听到的内容，而无需切换到计算机上的 OBS 并进行此类更改。 您可以继续做您所做的事情并轻松使用此应用程序来控制OBS！

目前OBS Blade支持：

- 开始/停止您的直播/录制
- 更改活动场景
- 切换场景项目的可见性（例如桌面捕获等）
- 更改当前音频源的音量（或将其静音）
- 查看任何 Twitch 和 YouTube 聊天并撰写消息
- 查看流媒体和录制性能的实时统计数据（FPS、CPU 使用率、kbit/s 等）

OBS Blade 还保存您之前的流和录音的统计数据，以便您可以跟踪整体性能和一些值得了解的事实！

这个应用程序仍处于早期阶段，随着时间的推移将更新新功能 - 目前我要添加的主要功能是：

- 更多地参与 OBS（重命名、排序、脚本化切换等）
- 导出/合并统计数据
- 音板
- 传入的功能请求
  -（也许）Streamlabs 客户端连接

我希望您在使用这个应用程序时度过愉快的时光。 如果您遇到任何错误、有功能请求或类似的事情，请随时与我联系！

contact@kounex.com

## 应用商店

该应用程序可在 iOS App Store、Google Play Store、F-Droid 和 GitHub 上找到：

- [iOS App Store](https://apps.apple.com/de/app/obs-blade/id1523915884?l=en)
- [Google Play Store](https://play.google.com/store/apps/details?id=com.kounex.obsBlade)
- [F-Droid](https://f-droid.org/packages/com.kounex.obsBlade/)
- [GitHub](https://github.com/Kounex/obs_blade/releases/latest)

## 如何构建

该应用程序是使用 Flutter 框架构建的。 要自己构建它，您需要在您的环境中设置
Flutter：https://docs.flutter.dev/get-started/install
运行时，确保您要构建的平台已列出并标记为就绪（复选标记）：

```
flutter doctor -v
```

如果您的平台未列出或尚未准备好（感叹号或“x”），请返回查看上面列出的安装指南，并确保您正确遵循了所有内容和/或检查“flutter doctor -v”的输出需要什么 做完了。

完成此操作后，使用您喜欢的 IDE 打开项目（VSCode 和 Android Studio 将自动获取所有依赖项，如果您使用其他 IDE 或者这不会自动发生，请在项目的根目录中运行 `flutter pub get` 获取该项目的依赖项）。 之后，您应该不会留下任何错误，您可以使用以下命令运行该应用程序：

```
flutter run
```

如何选择您想要构建应用程序的设备以及如何使用 IDE 而不是 CLI 运行此项目，请参阅开头的安装指南。

## 支持作者

我喜欢开发免费、高质量的应用程序，供所有人使用，无需应用内购买或广告。 没有人想要这样。 创建和维护我的作品需要花费大量时间 - 如果您喜欢使用它们并希望我继续研究它们，请考虑支持我！

<a href="https://www.buymeacoffee.com/Kounex" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
<a href="https://paypal.me/Kounex" target="_blank"><img src="https://assets.kounex.com/images/general/paypal-me-logo.png" alt="PayPal.Me" height="41"  width="174"></a>

## 支持翻译

[nanxi](https://github.com/babynanxi)
</br>

<a href="https://afdian.net/a/babynanxi" target="_blank"><img src="https://static.afdiancdn.com/static/img/logo/logo.png" alt="PayPal.Me" height="33"  width="33">爱发电</a>





