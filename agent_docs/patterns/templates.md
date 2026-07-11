# 스캐폴드 템플릿

## API 클라이언트 (`apps/<Name>API.swift`)

```swift
import Foundation

struct <Name>Params: Codable { /* 요청 필드 */ }

class <Name>API {
    static let shared = <Name>API()
    private let baseURL = "https://<service>.hyunsub.kim/api/v1/<path>"
    private init() {}

    func send(params: <Name>Params) {
        guard let url = URL(string: baseURL) else { Logger.log("Invalid URL"); return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"   // 또는 POST/GET
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // 토큰은 소스에 박지 말 것 → Keychain/로그인으로 주입 (networking.md)
        // request.setValue("HYUNSUB_TOKEN=\(token)", forHTTPHeaderField: "Cookie")
        request.httpBody = try? JSONEncoder().encode(params)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { Logger.log("Request failed: \(error.localizedDescription)"); return }
            if let http = response as? HTTPURLResponse { Logger.log("status \(http.statusCode)") }
        }.resume()
    }
}
```

## 싱글톤 매니저 (부수효과)

```swift
class <Name>Manager: NSObject {
    static let shared = <Name>Manager()
    private override init() { super.init() }
    // 위치/네트워크 등 부수효과를 캡슐화. 뷰에서 직접 다루지 말 것.
}
```

규칙: [../../.claude/rules/architecture.md](../../.claude/rules/architecture.md), [../../.claude/rules/networking.md](../../.claude/rules/networking.md).
