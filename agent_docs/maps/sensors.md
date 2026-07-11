# Guides & Sensors

## Guides — 피드포워드

편집 대상에 맞는 `.claude/rules/*.md`가 자동 로드된다. 자동 로드가 안 되면 CLAUDE.md Guides 표 링크로 직접 연다.

| 작업 | 먼저 읽을 것 |
|---|---|
| 뷰/매니저/위치/WebView | [../../.claude/rules/architecture.md](../../.claude/rules/architecture.md) |
| API 클라이언트(`*API.swift`) | [../../.claude/rules/networking.md](../../.claude/rules/networking.md) |

## Sensors — 피드백

| 센서 | 명령 | 검증 | 비고 |
|---|---|---|---|
| 빌드 | `xcodebuild -project apps.xcodeproj -scheme apps -destination 'generic/platform=iOS' build` | 컴파일 | 스킴 공유 안 됨(gotchas) |
| 테스트 | `xcodebuild -project apps.xcodeproj -scheme apps -destination 'platform=iOS Simulator,name=iPhone 15' test` | XCTest | 현재 템플릿 스텁뿐 — 커버리지 없음 |

**설정되어 있지 않은 것**: SwiftLint 등 린터, CI 워크플로, 공유 스킴. 작업 환경에 따라 Xcode GUI 빌드가 가장 확실하다.
