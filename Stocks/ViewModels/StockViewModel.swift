import Foundation

class StockViewModel: ObservableObject {
    @Published var messages = [StockMessage(time: 0, price: StockInfo.openPrice, volume: 0)]
    @Published var totalVolume: Double = 0.0
    @Published var avgPrice: Double = StockInfo.openPrice
    @Published var news: [StockNews] = []

    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.messages.count > Settings.marketTime {
                timer.invalidate()
                return
            }
            
            let lastMessage = self.messages.last!
            let rangeValue = Double(lastMessage.time % Settings.interval) * lastMessage.price / 10000.0
            let increment = Double.random(in: -rangeValue...rangeValue)
            let newPrice = lastMessage.price + increment
            let volume = increment == 0 ? 0 : Double.random(in: 0.0..<(abs(increment) * 10))
            let newTotal = self.totalVolume + volume
            
            self.messages.append(StockMessage(time: lastMessage.time + 1, price: newPrice, volume: volume))
            self.avgPrice = newTotal == 0 ? 0 : (self.totalVolume * self.avgPrice + newPrice * volume) / newTotal
            self.totalVolume = newTotal
        }
        
        self.news = loadNews()
    }
    
    func loadNews() -> [StockNews] {
        let file = Bundle.main.url(forResource: "stocknews", withExtension: "json")!
        let data = try! Data(contentsOf: file)
        return try! JSONDecoder().decode([StockNews].self, from: data)
    }
    
    var currentPrice: Double {
        messages.last!.price
    }
    
    var currentChange: Double {
        currentPrice - StockInfo.preClosePrice
    }
    
    var currentRate: Double {
        currentChange * 100 / StockInfo.preClosePrice
    }
    
    var highest: Double {
        messages.map { $0.price } .max()!
    }
    
    var lowest: Double {
        messages.map { $0.price } .min()!
    }
    
    var capital: String {
        let value = currentPrice * StockInfo.shares
        return value >= 1000 ? "\((value / 1000.0).toString2())T" : "\(value.toString2())B"
    }
}

struct StockMessage {
    let time: Int
    let price: Double
    let volume: Double
}

struct StockInfo {
    static let preClosePrice: Double = 156.70
    static let openPrice: Double = 157.00
    static let shares: Double = 16.41
    static let week52High: Double = 170.3
    static let week52Low: Double = 115.67
    static let pe: Double = 28.93
}

struct Settings {
    static let marketTime = 300
    static let interval = 20
}

struct StockNews: Codable {
    let title: String
    let url: String
}
