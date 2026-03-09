import Foundation


enum AppDateFormatters {
    static let ddMMyy: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yy"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
}
