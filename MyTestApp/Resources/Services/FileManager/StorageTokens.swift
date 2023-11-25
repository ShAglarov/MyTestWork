//
//  StorageTokens.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 23.11.2023.
//

import Foundation
class StorageToken {
    
    private let key = "savedAuthUser"
    
    static var shared = StorageToken()
    
    private init() {}
    
    func save(authUser: AuthResponse) {
        do {
            let data = try JSONEncoder().encode(authUser)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to encode and save authUser: \(error)")
        }
    }
    
    func load() -> AuthResponse? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(AuthResponse.self, from: data)
        } catch {
            print("Failed to decode and load authUser: \(error)")
            return nil
        }
    }
    
    // Тип замыкания для декодирования токена
    typealias JWTDecoder = (String) -> [String: Any]?

    // Функция для декодирования JWT
    func exampleJWTDecoder(token: String) -> [String: Any]? {
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else {
            return nil
        }

        var base64String = segments[1]
        let requiredLength = Int(4 * ceil(Float(base64String.count) / 4.0))
        let nbrPaddings = requiredLength - base64String.count
        if nbrPaddings > 0 {
            let padding = String(repeating: "=", count: nbrPaddings)
            base64String += padding
        }

        base64String = base64String.replacingOccurrences(of: "-", with: "+")
                                   .replacingOccurrences(of: "_", with: "/")

        guard let decodedData = Data(base64Encoded: base64String) else {
            return nil
        }

        let json = try? JSONSerialization.jsonObject(with: decodedData, options: [])
        return json as? [String: Any]
    }

    // Функция, использующая замыкание для декодирования токена
    func decodeToken(decodeJWT: JWTDecoder, token: String) {
        if let jwtPayload = decodeJWT(token) {
            print("Декодированная информация токена: \(jwtPayload)")
        } else {
            print("Не удалось декодировать токен.")
        }
    }

    func decode(myToken: String) {
        decodeToken(decodeJWT: exampleJWTDecoder, token: myToken)
    }
  

    // Функция для получения даты истечения срока действия токена в московском времени
    func getExpirationDateInMoscowTime(decodeJWT: JWTDecoder, token: String) -> Date? {
        guard let jwtPayload = decodeJWT(token),
              let expTimestamp = jwtPayload["exp"] as? TimeInterval else {
            return nil
        }

        let expirationDateUTC = Date(timeIntervalSince1970: expTimestamp)
        
        // Перевод UTC в московское время (UTC+3)
        let moscowTimeZone = TimeZone(secondsFromGMT: 3 * 3600) // 3600 секунд в часе
        var calendar = Calendar.current
        calendar.timeZone = moscowTimeZone!

        return calendar.date(byAdding: .hour, value: 3, to: expirationDateUTC)
    }
}
