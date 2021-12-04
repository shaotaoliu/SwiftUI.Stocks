import SwiftUI

struct StockVolume: View {
    let prices: [Double]
    let volumes: [Double]
    let viewWidth = UIScreen.main.bounds.width - 30
    let viewHeight: CGFloat = 30
    
    var body: some View {
        // GeometryReader has some memory issue
        //GeometryReader { geometry in
        VStack {
            let maxVolume = volumes.max()!
            let minVolume = volumes.min()!
            
            let maxBound: Double = maxVolume * 1.3
            let minBound: Double = minVolume * 0.7
            
            let interval = viewWidth / CGFloat(Settings.marketTime)
            let scale = maxBound == minBound ? 1 : (viewHeight / (maxBound - minBound))
            
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(1..<volumes.count, id: \.self) { i in
                    Rectangle()
                        .fill(prices[i] < prices[i-1] ? .red : .green)
                        .frame(width: interval, height: (volumes[i] - minBound) * scale)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StockVolume_Previews: PreviewProvider {
    static let prices: [Double] = {
        var prices: [Double] = []
        var price = 153.0
        
        for _ in 0..<(Settings.marketTime * 3 / 4) {
            price += Double.random(in: -1.0..<1.0)
            prices.append(price)
        }
        
        return prices
    }()
    
    static let volumes: [Double] = {
        return (0..<(Settings.marketTime / 2)).map{ _ in
            Double.random(in: 0.0...1.0)
        }
    }()
    
    static var previews: some View {
        VStack {
            StockVolume(prices: prices, volumes: volumes)
        }
        .frame(width: .infinity, height: 30)
    }
}
