import SwiftUI

struct StockTimeView: View {
    let viewWidth = UIScreen.main.bounds.width - 30
    
    var body: some View {
        // GeometryReader has some memory issue
        //GeometryReader { geometry in
            let interval = viewWidth / 6 - 1
            
            VStack(spacing: 5) {
                HStack {
                    Path { path in
                        for i in 0..<7 {
                            let x = interval * CGFloat(i) + 1
                            path.move(to: CGPoint(x: x, y: 0.0))
                            path.addLine(to: CGPoint(x: x, y: 5.0))
                        }
                    }
                    .stroke(.red)
                }
                .frame(height: 5)
                
                ZStack {
                    HStack {
                        Text("8:00")
                        Spacer()
                        Text("14:00")
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(1..<6, id: \.self) { i in
                            Text("\(8 + i):00")
                                .frame(width: interval)
                        }
                    }
                }
                .font(.system(size: 12))
            }
        //}
    }
}

struct StockTimeView_Previews: PreviewProvider {
    static var previews: some View {
        StockTimeView()
            .padding()
            .frame(maxWidth: .infinity)
    }
}
