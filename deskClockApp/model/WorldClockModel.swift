import Foundation

struct WorldClockModel {
    let cityName: String
    let country: String
    let timeZoneIdentifier: String
    
    // 타임존이 적용된 현재 날짜 반환
    var localTime: Date {
        let now = Date()
        let tz = TimeZone(identifier: timeZoneIdentifier) ?? .current
        let seconds = TimeInterval(tz.secondsFromGMT(for: now))
        return now.addingTimeInterval(seconds - TimeInterval(TimeZone.current.secondsFromGMT(for: now)))
    }
}
