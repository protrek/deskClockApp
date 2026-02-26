//
//  WorldClock.swift
//  deskClockApp
//
//  Created by protrek on 2/25/26.
//

struct WorldClock {
    let cityName: String
    let timeZoneIdentifier: String
    let country: String
    
    var currentTime: Date {
        return Date()
    }
    
    // 타임존에 맞는 시간 문자열 생성
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        return formatter.string(from: currentTime)
    }
}
