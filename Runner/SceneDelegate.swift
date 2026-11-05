import UIKit
import Flutter
import AppTrackingTransparency

class SceneDelegate: FlutterSceneDelegate {
    
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // 1. Let Flutter wire up the scene first
        super.scene(scene, willConnectTo: session, options: connectionOptions)
        
        // 2. Now the window is safely available on the SceneDelegate
        if let controller = window?.rootViewController as? FlutterViewController {
            
            // Channel name matches main.dart
            let attChannel = FlutterMethodChannel(name: "Dream2win.Lottery-Aaj/att",
                                                  binaryMessenger: controller.binaryMessenger)
            
            attChannel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              if call.method == "requestATT" {
                if #available(iOS 14, *) {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ATTrackingManager.requestTrackingAuthorization { status in
                      switch status {
                      case .authorized:
                        result("authorized")
                      case .denied:
                        result("denied")
                      case .restricted:
                        result("restricted")
                      case .notDetermined:
                        result("notDetermined")
                      @unknown default:
                        result("unknown")
                      }
                    }
                  }
                } else {
                  result("authorized")
                }
              } else {
                result(FlutterMethodNotImplemented)
              }
            })
        }
    }
}