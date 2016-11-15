# QuickTouch - All you need to do is touch once
Inspired by nMBP touch bar, this project make u control your mac using your iPhone or iPad.

这个项目的 idea 是源于 nMBP 的 touch bar 功能，你可以用你的 iPhone / iPad 来作为 "touch bar" 使用。

Demo Video (演示视频) <http://www.bilibili.com/video/av7107528>

#### Now Support Function including (已支持功能包括):

* **NEW 2016.11.14**

  1. Your device will automatically change adaptive interface when you switch mac app, support Finder & Xcode now,
  more functions coming soon. (你的设备快捷键会随你切换 mac 软件而改变，现在支持 Finder/Xcode 的某些快捷键，未来会更新更多功能)

  2. some convenient functions: change brightness/volume, make mac sleep / screenshot etc. (一些快捷方式，修改屏幕亮度/音量，休眠，截图等)

    ![](http://ocnnxadky.bkt.clouddn.com/public/16-11-15/30523796.jpg)

---

* Execute F* keys, like touch F1 button one your device, then your mac will execute F1 function (reduce the brightness). (按下设备对应的 F* 按钮，mac 会指定对应 F* 的功能，比如降低屏幕亮度等...)

* Touch your device to create one command, like touch `pwd` button, your terminal will execute pwd command. (按下 `pwd` 按钮，你的终端会执行 `pwd` 命令)

* Touch your device to execute almost all shortcuts, like `Command + C` / `Command  + V` / `Command + Shift + LEFT` . (使用你的设备来执行 mac 上几乎所有快捷键)

  ![](http://ocnnxadky.bkt.clouddn.com/public/16-11-15/98223314.jpg)

* Quicky open app on your mac and you can custom some actions after opening app. (快速打开 mac 的软件并且可以自定义打开软件后的事件)

#### TODO (正在开发) :

* A simple way to execute a series of custom commands.（执行一系列的自定义命令）

* A more beautiful interface. (更加漂亮易于交互的界面)

#### How to use (使用教程) :

1. clone or download this project. (下载或者 git clone 项目)

2. open **QuickTouchClient.xcworkspace**. (打开 **QuickTouchClient.xcworkspace**)

3. change some paras. (修改一些参数)

    ```
    #define QTHOST @"192.168.1.112" // your mac IP address
    #define QTSENDPORT 9527 // a port not occupy
    #define QTRECEIVEPORT 9526 // a port not occupy
    ```

    in **QuickTouchClient-prefix.pch** file

4. change some paras (修改一些参数)

    ```
    #define QTHOST @"192.168.1.114" // your iOS device IP address
    #define QTRECEIVEPORT 9527 // a port not occupy, must be same as QTSENDPORT in QuickTouchClient-prefix.pch
    #define QTSENDPORT 9526 // a port not occupy, must be same as QTRECEIVEPORT in QuickTouchClient-prefix.pch
    ```

    in **QuickTouchServer-prefix.pch** file

5. run **QuickTouchServer** Target on mac, and then stop, drop **QuickTouchServer.app** (under Products file) into applications. Go to system preference and allow this app to control your mac.

  ![](http://ocnnxadky.bkt.clouddn.com/public/16-11-15/99085664.jpg)

6. run **QuickTouchClient** on iOS device.

7. enjoy **Quick Touch** ~.
