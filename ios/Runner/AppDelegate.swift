import UIKit
import Flutter
import Firebase
import GoogleMaps
import Braintree

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    BTAppSwitch.setReturnURLScheme("aheschl.links.braintree")

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    GMSServices.provideAPIKey("AIzaSyDavOnmlKHv2dKYcPmxoNCMnl9foHeKftY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

