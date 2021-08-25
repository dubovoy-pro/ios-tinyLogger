import Foundation


public class TinyLogger {


    public static let shared = TinyLogger()
    
    public func getLogsTitle() -> String {
        let time = TinyLogger.makeFormatter(dateFormat: "YYYY-MM-DD (H-m)").string(from: Date())
        return "iOS App Logs \(time).txt"
    }
    
    public func getLogs() -> String {
        var result: String?
        queue.sync() {
            result = logs.joined(separator: "\n")
        }
        return result ?? ""
    }
    
    public static func log(_ text: String) {
        #if DEBUG
        print(text)
        #endif
        TinyLogger.shared.addLine(text)
    }

    private let queue = DispatchQueue(label: "LoggerQueue", qos: .utility, attributes: .concurrent)

    private let dateFormatter: DateFormatter
    
    private var logs = [String]()
    
    private init() {
        dateFormatter = TinyLogger.makeFormatter(dateFormat: "MMM d, HH:mm:ss")
    }

    private func addLine(_ text: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            let timestamp = self.dateFormatter.string(from: Date())
            self.logs.append("[\(timestamp)] \(text)")
        }
    }
    
    private static func makeFormatter(dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        return dateFormatter
    }
    
}
