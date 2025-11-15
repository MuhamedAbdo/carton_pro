import Flutter
import AVFoundation
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    var splashCoordinator: EasySplashCoordinator?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        let splashConfig = EasySplashNativeConfig(
            duration: 3.2,
            text: "CartonPro",
            backgroundLightHex: "#FFFFFF",
            backgroundDarkHex: "#121212",
            imageLightName: "simple_splash_view_image_light.png",
            imageDarkName: "simple_splash_view_image_dark.png",
            lottieLightName: nil,
            lottieDarkName: nil,
            soundName: nil,
            textColorLightHex: "#1E1E1E",
            textColorDarkHex: "#FAFAFA",
            indicatorColorLightHex: "#FF5722",
            indicatorColorDarkHex: "#FFC107",
            showsIndicator: true,
            indicatorPosition: "below_visual",
            textPosition: "bottom",
            flutterImageAssetLight: "assets/images/logo_light.png",
            flutterImageAssetDark: "assets/images/logo_dark.png",
            flutterLottieAssetLight: nil,
            flutterLottieAssetDark: nil,
            flutterSoundAsset: nil
        )
        splashCoordinator = EasySplashCoordinator(window: window, config: splashConfig)
        splashCoordinator?.presentIfNeeded()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
