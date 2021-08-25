import UIKit

public class ShakeSharingWindow: UIWindow {
    
    
    public func shareLogs() {
        
        let logText = TinyLogger.shared.getLogs()
        let fileName = TinyLogger.shared.getLogsTitle()

        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = dir.appendingPathComponent(fileName)
        do {
            try logText.write(to: fileURL, atomically: false, encoding: .utf8)
            let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
            if let rootVC = rootViewController {
                rootVC.present(vc, animated: true)
            } else {
                rootViewController = vc
            }
        }
        catch {
            print(error)
        }
    }

    
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            shareLogs()
        }
    }

}

