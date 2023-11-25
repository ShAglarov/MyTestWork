//
//  Date.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 25.11.2023.
//

import Foundation

struct CurrentDateInfo {
    var unixtime: Int
    var timezone: String
    var dstOffset: Int
    var utcOffset: String
    var dstUntil: String?
    var dayOfYear: Int
    var rawOffset: Int
    var datetime: String
    var dstFrom: String?
    var clientIp: String
    var weekNumber: Int
    var dayOfWeek: Int
    var abbreviation: String
    var dst: Int
    var utcDatetime: String
    
    init(unixtime: Int, timezone: String, dstOffset: Int, utcOffset: String, dstUntil: String? = nil, dayOfYear: Int, rawOffset: Int, datetime: String, dstFrom: String? = nil, clientIp: String, weekNumber: Int, dayOfWeek: Int, abbreviation: String, dst: Int, utcDatetime: String) {
        self.unixtime = unixtime
        self.timezone = timezone
        self.dstOffset = dstOffset
        self.utcOffset = utcOffset
        self.dstUntil = dstUntil
        self.dayOfYear = dayOfYear
        self.rawOffset = rawOffset
        self.datetime = datetime
        self.dstFrom = dstFrom
        self.clientIp = clientIp
        self.weekNumber = weekNumber
        self.dayOfWeek = dayOfWeek
        self.abbreviation = abbreviation
        self.dst = dst
        self.utcDatetime = utcDatetime
    }
    
    init() {
        self.unixtime = 0
        self.timezone = "timezone"
        self.dstOffset = 0
        self.utcOffset = "utcOffset"
        self.dstUntil = "dstUntil"
        self.dayOfYear = 0
        self.rawOffset = 0
        self.datetime = "datetime"
        self.dstFrom = "dstFrom"
        self.clientIp = "clientIp"
        self.weekNumber = 0
        self.dayOfWeek = 0
        self.abbreviation = "abbreviation"
        self.dst = 0
        self.utcDatetime = "utcDatetime"
    }

    func parsedDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let dateUtc = formatter.date(from: datetime) else {
            return nil
        }
        
        let moscowTimeZone = TimeZone(identifier: "Europe/Moscow")!
        let moscowTimeOffset = moscowTimeZone.secondsFromGMT(for: dateUtc)
        return Date(timeInterval: TimeInterval(moscowTimeOffset), since: dateUtc)
    }
}
