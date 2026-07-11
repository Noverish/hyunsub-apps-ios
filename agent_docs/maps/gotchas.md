# 런타임 함정 (gotchas)

각 항목 **문제 → 근본 원인 → 수정 → 감지**.

## ⚠️ 하드코딩된 장수명 토큰 (보안)

- **문제**: `apps/TimelineAPI.swift`에 admin 권한 JWT가 평문으로 박혀 있고 만료가 2081년이다.
- **근본 원인**: 토큰을 소스 상수로 둠 → 깃 히스토리·앱 바이너리에서 추출 가능, 회전/폐기 불가.
- **수정**: 토큰을 회전/폐기하고(서버측), 클라이언트는 Keychain 저장 또는 로그인 흐름으로 주입. 소스에서 제거해도 **깃 히스토리에는 남으므로 토큰 자체를 무효화**해야 한다.
- **감지**: `git grep -n "eyJ" apps/`.

## 다른 머신/CI에서 `-scheme apps`가 안 보인다

- **문제**: `xcodebuild -scheme apps`가 "scheme not found".
- **근본 원인**: 스킴이 공유(shared)되지 않고 `apps.xcodeproj/xcuserdata`에만 있다 → 다른 사용자/CI에서 미인식.
- **수정**: Xcode에서 스킴을 "Shared"로 체크해 `xcshareddata/xcschemes`에 커밋하거나, `xcodebuild -list`로 사용 가능한 스킴 확인.

## 백그라운드에서 위치가 안 올라온다

- **문제**: 앱을 내리면 timeline 전송이 멈춘다.
- **근본 원인**: "Always" 권한 미허용, 또는 `UIBackgroundModes: location` 누락, 또는 significant-change 미가용 기기.
- **수정**: 권한 Always 확인, Info.plist 백그라운드 모드 유지, `significantLocationChangeMonitoringAvailable()` 체크. `pausesLocationUpdatesAutomatically=false`·`allowsBackgroundLocationUpdates=true` 유지.
- **감지**: `Logger` 출력에 "Authorization: …" / "Started monitoring …" 확인.

## HTTP 호출이 막히지 않는다(의도된 ATS 비활성)

- **문제**: ATS 위반인데 통과해서 보안 점검에 안 걸림.
- **근본 원인**: `Info.plist`의 `NSAllowsArbitraryLoads = true`로 ATS 전체 비활성.
- **수정**: 모든 통신이 https라면 ATS 예외를 도메인 한정으로 좁히는 것을 검토.

<!-- TODO 후보:
- 위치 전송 실패 시 재시도/버퍼링 없음 — 유실 허용 여부
- WKWebView 캐시 정책(returnCacheDataElseLoad)으로 오래된 웹앱이 뜰 가능성
-->
