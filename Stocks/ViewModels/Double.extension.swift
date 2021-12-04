import Foundation

extension Double {
    func toString(precision: Int) -> String {
        return String(format: "%.2f", arguments: [self])
    }
    
    func toString2() -> String {
        return self.toString(precision: 2)
    }
    
    func toVolumeString() -> String {
        return self < 1000 ? "\(self.toString2())K" : "\((self / 1000.0).toString2())M"
    }
}
