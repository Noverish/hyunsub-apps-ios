# 아키텍처 지도

## 실행 흐름

```
appsApp (@main)
  ├ UIApplicationDelegateAdaptor → AppDelegate.application(didFinishLaunching)
  │     ├ LocationManager.shared.requestPermission()        # Always 권한 요청
  │     └ launchOptions[.location] != nil 면                # 위치 이벤트로 부활한 경우
  │           LocationManager.shared.startMonitoringSignificantLocationChanges()
  └ WindowGroup { ContentView }                             # WKWebView(apps.hyunsub.kim)
```

## 두 가지 책임

| 책임 | 구현 | 비고 |
|---|---|---|
| 웹앱 쉘 | `ContentView` → `WKWebView` | `https://apps.hyunsub.kim` 로드, 커스텀 UA `… Hyunsub/1.0.0`, 당겨서 새로고침 |
| 백그라운드 위치 추적 | `LocationManager` + `TimelineAPI` | significant location change → timeline API PUT |

## 위치 데이터 흐름

```
CLLocationManager (significant changes, 백그라운드)
  → LocationManager.didUpdateLocations(location)
      → TimelineCreateParams(timestamp(ms), lat, lng, altitude, speed, course, accuracy...)
          (음수 정확도/속도는 nil 처리)
      → TimelineAPI.shared.sendTimeline(params)
          → PUT https://timeline.hyunsub.kim/api/v1/timelines/{timestamp}
             Cookie: HYUNSUB_TOKEN=<token>   (현재 하드코딩 — gotchas 참조)
```

권한 변경 시(`locationManagerDidChangeAuthorization`) Always/WhenInUse면 모니터링을 (재)시작한다.

## 권한·백그라운드 전제 (Info.plist)

- `NSLocationAlwaysAndWhenInUseUsageDescription`, `NSLocationWhenInUseUsageDescription` — 권한 문구.
- `UIBackgroundModes: [location]` — 백그라운드 위치.
- `NSAppTransportSecurity.NSAllowsArbitraryLoads = true` — ATS 비활성(임의 HTTP 허용).

<!-- TODO: WebView와 네이티브(위치/푸시) 사이 연동이 있는지, 앱이 timeline 외 다른 API도 호출하는지 -->
