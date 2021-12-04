import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: StockViewModel
    
    private var prices: [Double] {
        vm.messages.map { $0.price }
    }
    
    private var volumes: [Double] {
        vm.messages.map { $0.volume }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView()
                .padding(.bottom, 5)
            
            ScrollView {
                StockInfoView()
                
                StockCurve(prices: prices, volumes: volumes)
                    .frame(height: 200)
                    .padding(.top)
                
                StockTimeView()
                    .frame(height: 30)
                
                StockVolume(prices: prices, volumes: volumes)
                    .frame(height: 80)
                
                StockNewsView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StockViewModel())
    }
}
