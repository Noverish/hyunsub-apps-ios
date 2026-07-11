# agent_docs — hyunsub-ios 참조 레퍼런스

에이전트가 **필요할 때 직접 조회**하는 심화 문서. 항상 로드되는 [CLAUDE.md](../CLAUDE.md), 편집 시 자동 로드되는 [.claude/rules/](../.claude/rules/)와 역할이 다르다.

## 3-way 역할 분담

| 위치 | 역할 | 로드 방식 | 들어가는 것 |
|---|---|---|---|
| `CLAUDE.md` | 목차 + 핵심 요약 | 항상 | Quick Reference, 디렉토리, 명령, Guides·Sensors 링크 |
| `.claude/rules/*.md` | 경로 조건부 컨벤션(피드포워드) | 매칭 파일 편집 시 | SwiftUI 수명주기·위치·WebView, 네트워킹/시크릿 |
| `agent_docs/` | 참조 레퍼런스(피드백·심화) | 필요 시 직접 | 실행 흐름, 함정, 빌드/서명/권한 |

## 색인

- **maps/**
  - [architecture.md](maps/architecture.md) — 실행 흐름, WebView/위치 두 책임, 데이터 흐름
  - [gotchas.md](maps/gotchas.md) — 런타임 함정(문제→원인→수정→감지)
  - [sensors.md](maps/sensors.md) — Guides & Sensors 프레임
- **patterns/**
  - [templates.md](patterns/templates.md) — API 클라이언트 / 매니저 스캐폴드
- **specs/**
  - [build-and-signing.md](specs/build-and-signing.md) — 번들 ID·배포 타깃·스킴·서명·Info.plist 권한
