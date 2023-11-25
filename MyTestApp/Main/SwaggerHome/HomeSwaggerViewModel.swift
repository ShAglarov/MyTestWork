//
//  HomeSwaggerViewModel.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 08.11.2023.
//

import Foundation
import Combine

final class HomeSwaggerViewModel {
    
    let myToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzAwNTg0NDg1LCJpYXQiOjE3MDA1ODA4ODUsImp0aSI6ImFiNzM1ZWI4NjhlMjQ5YzViOWUyMTdhZjQ4OTI1OTM3IiwidXNlcl9pZCI6IjljMmU5NWVkLWY2N2UtNDhjYy1hMDA4LTljMzIyMGJiOWE3NiJ9.E0BJaxKaVcxtkbF_rzqJ6THL9zp9MDxIWq9P8xZ2Kkg"

//    // Тип замыкания для декодирования токена
//    typealias JWTDecoder = (String) -> [String: Any]?
//
//    // Функция для декодирования JWT
//    func exampleJWTDecoder(token: String) -> [String: Any]? {
//        let segments = token.components(separatedBy: ".")
//        guard segments.count > 1 else {
//            return nil
//        }
//
//        var base64String = segments[1]
//        let requiredLength = Int(4 * ceil(Float(base64String.count) / 4.0))
//        let nbrPaddings = requiredLength - base64String.count
//        if nbrPaddings > 0 {
//            let padding = String(repeating: "=", count: nbrPaddings)
//            base64String += padding
//        }
//
//        base64String = base64String.replacingOccurrences(of: "-", with: "+")
//                                   .replacingOccurrences(of: "_", with: "/")
//
//        guard let decodedData = Data(base64Encoded: base64String) else {
//            return nil
//        }
//
//        let json = try? JSONSerialization.jsonObject(with: decodedData, options: [])
//        return json as? [String: Any]
//    }
//
//    // Функция, использующая замыкание для декодирования токена
//    func decodeToken(decodeJWT: JWTDecoder, token: String) {
//        if let jwtPayload = decodeJWT(token) {
//            print("Декодированная информация токена: \(jwtPayload)")
//        } else {
//            print("Не удалось декодировать токен.")
//        }
//    }
//
//    func decode(myToken: String) {
//        decodeToken(decodeJWT: exampleJWTDecoder, token: myToken)
//    }
//  
//
//    // Функция для получения даты истечения срока действия токена в московском времени
//    func getExpirationDateInMoscowTime(decodeJWT: JWTDecoder, token: String) -> Date? {
//        guard let jwtPayload = decodeJWT(token),
//              let expTimestamp = jwtPayload["exp"] as? TimeInterval else {
//            return nil
//        }
//
//        let expirationDateUTC = Date(timeIntervalSince1970: expTimestamp)
//        
//        // Перевод UTC в московское время (UTC+3)
//        let moscowTimeZone = TimeZone(secondsFromGMT: 3 * 3600) // 3600 секунд в часе
//        var calendar = Calendar.current
//        calendar.timeZone = moscowTimeZone!
//
//        return calendar.date(byAdding: .hour, value: 3, to: expirationDateUTC)
//    }
//    
//    func expirationDateInMoscow() {
//        if let expirationDateInMoscow = getExpirationDateInMoscowTime(decodeJWT: exampleJWTDecoder, token: myToken) {
//            print("Дата истечения срока действия токена по Москве: \(expirationDateInMoscow)")
//        } else {
//            print("Не удалось извлечь дату истечения срока действия токена.")
//        }
//    }
}
//еще сотруднику нужно сделать запрос в сервер чтобы сделать рефреш токена после истечения срока токена опиши эту задачу также
//еще нужно сохранить токен на устройстве телефона и при входе в приложение нужно посмотреть срок годности токена если токен действителен
//то автоматически должен быть вход в личный кабинет пользователя, если срок истек то, нужно получить новый токен
