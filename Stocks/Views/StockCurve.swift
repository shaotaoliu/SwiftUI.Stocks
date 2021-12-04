import SwiftUI

struct StockCurve: View {
    let prices: [Double]
    let volumes: [Double]
    private let color1 = Color(red: 0.92, green: 0.92, blue: 0.92)
    private let viewWidth = UIScreen.main.bounds.width - 30
    private let viewHeight: CGFloat = 200
    
    @State private var currentIndex: Int = 0
    @State private var currentX: CGFloat = 0.0
    @State private var currentTime: Int = 0
    @State private var showInfoPopup = false
    
    var body: some View {
        // GeometryReader has some memory issue
        // GeometryReader { geometry in
        let preClosePrice = StockInfo.preClosePrice
        let maxPrice = prices.max()!
        let minPrice = prices.min()!
        let currentPrice = prices.last!
        
        let maxBound: Double = maxPrice * 1.02
        let minBound: Double = minPrice * 0.98
        
        let interval = viewWidth / CGFloat(Settings.marketTime)
        let scale = viewHeight / (maxBound - minBound)
        
        let padding = (maxBound - minBound) * 20 / viewHeight
        let lineInterval = (maxBound - minBound - padding * 2.0) / 4.0
        
        return ZStack {
            
            ForEach(0..<5, id: \.self) { i in
                Path { path in
                    let y1 = (padding + lineInterval * Double(i)) * scale
                    
                    path.move(to: CGPoint(x: 0, y: y1))
                    path.addLine(to: CGPoint(x: viewWidth, y: y1))
                }
                .stroke(color1)
            }
            
            ZStack {
                ForEach(0..<5, id: \.self) { i in
                    let v1 = maxBound - padding - lineInterval * Double(i)
                    
                    HStack {
                        Text(v1.toString2())
                        
                        Spacer()
                        
                        Text("\(((v1 - preClosePrice) * 100.0 / preClosePrice).toString2())%")
                    }
                    .foregroundColor(v1 > preClosePrice ? .green : (v1 == preClosePrice ? .gray : .red))
                    .font(.system(size: 11))
                    .offset(y: (lineInterval * Double(i - 2)) * scale)
                }
            }
            
            if preClosePrice <= maxBound && preClosePrice >= minBound {
                let y2 = (maxBound - preClosePrice) * scale
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: y2))
                    path.addLine(to: CGPoint(x: viewWidth, y: y2))
                }
                .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [3]))
            }
            
            let y3 = (maxBound - currentPrice) * scale
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: y3))
                path.addLine(to: CGPoint(x: viewWidth, y: y3))
            }
            .stroke(.purple, style: StrokeStyle(lineWidth: 0.5, dash: [3]))
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: (maxBound - prices[0]) * scale))
                
                for i in 1..<prices.count {
                    path.addLine(to: CGPoint(x: interval * CGFloat(i), y: (maxBound - prices[i]) * scale))
                }
            }
            .stroke(.blue)
            
            Path { path in
                path.move(to: CGPoint(x: currentX, y: 0))
                path.addLine(to: CGPoint(x: currentX, y: viewHeight))
            }
            .stroke(.brown, style: StrokeStyle(lineWidth: 0.5, dash: [3]))
            .opacity(showInfoPopup ? 1 : 0)
            
            VStack {
                HStack(spacing: 5) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Price")
                        Text("Volume")
                        Text("Time")
                    }
                    
                    VStack(alignment: .trailing, spacing: 3) {
                        Text(prices[currentIndex].toString2())
                        Text(volumes[currentIndex].toVolumeString())
                        Text(getTimeString(index: currentIndex))
                    }
                }
                .font(.system(size: 10))
                .padding(8)
                .background(.white)
                .cornerRadius(5)
                .shadow(radius: 5)
                .padding(.horizontal)
                .opacity(showInfoPopup ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,
                   alignment: currentIndex < Settings.marketTime / 2 ? .topTrailing : .topLeading)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let index = Int(value.location.x * CGFloat(Settings.marketTime) / viewWidth)
                    if index < prices.count && index < volumes.count {
                        currentIndex = index
                        currentX = value.location.x
                        currentTime = Int(value.location.x * CGFloat(360) / viewWidth)
                        showInfoPopup = true
                    }
                    else {
                        showInfoPopup = false
                    }
                }
                .onEnded { value in
                    showInfoPopup = false
                }
        )
    }
    
    func getTimeString(index: Int) -> String {
        let hour = currentTime / 60 + 8
        let minute = currentTime % 60
        
        return "\(hour):\(minute < 10 ? "0" : "")\(minute)"
    }
}

struct PopupField: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 20) {
            Text(label)
            Text(value)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
        }
    }
}

struct StockCurve_Previews: PreviewProvider {
    static let prices: [Double] = {
        var prices: [Double] = []
        var price = 153.0
        
        for _ in 0..<(Settings.marketTime) {
            price += Double.random(in: -1.0..<1.0)
            prices.append(price)
        }
        
        return prices
    }()
    
    static let volumes: [Double] = {
        return (0..<(Settings.marketTime)).map{ _ in
            Double.random(in: 0.0...1.0)
        }
    }()
    
    static var previews: some View {
        VStack {
            StockCurve(prices: prices, volumes: volumes)
        }
        .frame(width: .infinity, height: 200)
    }
}
