//
//  NetworkSinglton.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 24.11.2023.
//

import Foundation

class NetworkSinglton {
    
    static let shared = NetworkSinglton()
    
    private init() { }
    
    private let getRefreshToken = "https://dev-hospital.doct24.com/api/v1/auth/login/refresh/token/"
    
    private func buildURLComponents(from baseURL: String) -> URLComponents? {
        guard let base = URL(string: baseURL),
              let baseScheme = base.scheme,
              let baseHost = base.host else {
            print("Invalid base URL")
            return nil
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = baseScheme
        urlComponents.host = baseHost
        
        // Определяем, какой части пути следует избежать. Это должен быть общий базовый URL до `/api/`.
        let basePathToAvoid = "\(baseScheme)://\(baseHost)"
        // Убеждаемся, что у нас есть путь, начинающийся с '/api/'.
        if let range = baseURL.range(of: basePathToAvoid) {
            let path = baseURL[range.upperBound...] // Получаем подстроку после основного домена.
            urlComponents.path = String(path).hasPrefix("/") ? String(path) : "/\(path)"
        } else {
            print("Base URL does not contain the path starting with '/api/'")
            return nil
        }
        
        return urlComponents
    }
    
    private func createURL(from baseURL: String) -> URL? {
        let urlComponents = buildURLComponents(from: baseURL)
        return urlComponents?.url
    }

    private func postRequestGetRefresh(json: [String: Any]) async throws -> [String: Any] {
        guard let url = createURL(from: getRefreshToken) else {
            throw HError.invalidURL
        }
        var request = try URLRequest(url: url, method: .post)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HError.invalidResponse
        }
        
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            let errorData = String(data: data, encoding: .utf8) ?? "No error information"
            throw HError.serverError(code: httpResponse.statusCode, message: errorData)
        }

        guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw HError.invalidData
        }

        return jsonResult
    }
    
    func getToken(refresh: String) async throws -> [String: Any] {
        let requestBody: [String: Any] = ["refresh": refresh]
        return try await postRequestGetRefresh(json: requestBody)
    }

    func getMoscowTime() async throws -> CurrentDateInfo? {
        let urlString = "https://worldtimeapi.org/api/timezone/Europe/Moscow"
        guard let url = URL(string: urlString) else {
            throw HError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw HError.invalidResponse
        }
        
        guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw HError.invalidData
        }
        
        guard let unixtime = jsonResult["unixtime"] as? Int,
              let timezone = jsonResult["timezone"] as? String,
              let dstOffset = jsonResult["dst_offset"] as? Int,
              let utcOffset = jsonResult["utc_offset"] as? String,
              let dayOfYear = jsonResult["day_of_year"] as? Int,
              let rawOffset = jsonResult["raw_offset"] as? Int,
              let datetime = jsonResult["datetime"] as? String,
              let clientIp = jsonResult["client_ip"] as? String,
              let weekNumber = jsonResult["week_number"] as? Int,
              let dayOfWeek = jsonResult["day_of_week"] as? Int,
              let abbreviation = jsonResult["abbreviation"] as? String,
              let dst = jsonResult["dst"] as? Int,
              let utcDatetime = jsonResult["utc_datetime"] as? String else {
            throw HError.invalidData
        }

        return CurrentDateInfo(
            unixtime: unixtime,
            timezone: timezone,
            dstOffset: dstOffset,
            utcOffset: utcOffset,
            dstUntil: nil,
            dayOfYear: dayOfYear,
            rawOffset: rawOffset,
            datetime: datetime,
            dstFrom: nil,
            clientIp: clientIp,
            weekNumber: weekNumber,
            dayOfWeek: dayOfWeek,
            abbreviation: abbreviation,
            dst: dst,
            utcDatetime: utcDatetime
        )
    }

    func convertToDateTime(from dictionary: [String: Any]) -> Date? {
        guard let dateTimeString = dictionary["datetime"] as? String else {
            print("Дата и время не найдены в словаре")
            return nil
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateTimeString)
    }
}


