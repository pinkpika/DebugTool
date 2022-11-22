# DebugTool

DebugTool for iOS

## Demo

https://user-images.githubusercontent.com/5244890/203271313-7ee89894-824c-4b22-b639-8b16f3752d31.mov

## Install

1. Download Repo 
2. Edit Podfile

```ruby
target 'DemoABC' do
  use_frameworks!
  pod 'DebugTool', :path => '../DebugTool'
end
```

## Usage

1. Declare Static DebugTool and Show it. ( 宣告靜態的 DebugTool 並且顯示它 )

```swift
import DebugTool

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    static var debugTool: DebugTool?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        #if DEBUG
        SceneDelegate.debugTool = DebugTool(windowScene: scene, point: CGPoint(x: 100, y: 100))
        SceneDelegate.debugTool?.show()
        #endif
    }
}
```

2. Call addToast. ( 呼叫新增Toast )

```swift
SceneDelegate.debugTool?.addToast("客製化訊息: 123")
SceneDelegate.debugTool?.addToast("客製化訊息: 123", .custom(UIColor.purple))
SceneDelegate.debugTool?.addToast("使用者訊息: 點擊了A按鈕", .userEvent)
SceneDelegate.debugTool?.addToast("Api發送事件: 發送了OOXX的請求", .apiSend)
SceneDelegate.debugTool?.addToast("Api花費時間: 花費了0000ms", .apiTime)
```

3. Show the setting => Tap the apple. ( 點擊 Apple 可以打開設定畫面 )

4. Hide the apple => LongPress the apple. ( 長按 Apple 可以隱藏 Apple )

## Extension

You can edit `DebugMessageType` and `DebugTypeOptions` for supporting more types.

```swift
public enum DebugMessageType: CaseIterable{
    case custom(_ toastColor: UIColor)
    case userEvent
    case apiSend
    case apiTime
    ....
    ....
}
```
