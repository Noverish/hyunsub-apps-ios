//
//  AppDelegate.swift
//  apps
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // 위치 권한 요청 및 모니터링 시작
        LocationManager.shared.requestPermission()

        // 백그라운드에서 위치 업데이트로 인해 앱이 실행된 경우
        if launchOptions?[.location] != nil {
            Logger.log("App launched due to location event")
            LocationManager.shared.startMonitoringSignificantLocationChanges()
        }

        return true
    }
}
