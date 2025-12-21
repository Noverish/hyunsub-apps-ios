//
//  TimelineAPI.swift
//  apps
//

import Foundation

struct TimelineCreateParams: Codable {
    let timestamp: Int64
    let latitude: Double
    let longitude: Double
    let altitude: Double?
    let speed: Double?
    let course: Double?
    let horizontalAccuracy: Double?
    let verticalAccuracy: Double?
    let speedAccuracy: Double?
    let courseAccuracy: Double?
}

class TimelineAPI {
    static let shared = TimelineAPI()

    private let baseURL = "https://timeline.hyunsub.kim/api/v1/timelines"
    private let token = "eyJhbGciOiJFUzUxMiJ9.eyJleHAiOjIwODE1NTg3MTMsInBheWxvYWQiOiJ7XCJpZE5vXCI6XCIwMDAwMFwiLFwidXNlcm5hbWVcIjpcImFkbWluXCIsXCJhdXRob3JpdGllc1wiOltcImFkbWluXCIsXCJ2aWRlb1wiLFwidmlkZW9fbm9ybWFsXCIsXCJwaG90b1wiLFwiYXBwYXJlbFwiLFwiZHJpdmVcIixcImNvbWljXCIsXCJlbmNvZGVcIixcImRpYXJ5XCIsXCJnaXRcIixcImZyaWVuZFwiLFwiZHV0Y2hcIixcImdlbmV0aWNcIixcImFyY2hpdmVcIixcInRpbWVsaW5lXCJdfSJ9.AIvpSbhY7PuAyFUCB-92CCnZbf_60zwqKcKx8z4sTu4D42S1eoF3JX3FDrdi9Rt4C6SXZmbAtJcx9Xnc1YzWaRSvASaBcvaukjU2nuJ1Gfw1cQKHCSpDKumHvoQRmhuG1g8YnCdiSLNB0AryM3HmSwNzWor5uhQ5TGggNpTA0qLD7iNr"

    private init() {}

    func sendTimeline(params: TimelineCreateParams) {
        let urlString = "\(baseURL)/\(params.timestamp)"
        guard let url = URL(string: urlString) else {
            Logger.log("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("HYUNSUB_TOKEN=\(token)", forHTTPHeaderField: "Cookie")

        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(params)
        } catch {
            Logger.log("Failed to encode params: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Logger.log("Request failed: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                Logger.log("Response status code: \(httpResponse.statusCode)")
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                Logger.log("Response: \(responseString)")
            }
        }

        task.resume()
    }
}
