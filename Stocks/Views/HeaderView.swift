import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var vm: StockViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 15) {
                Text("AAPL")
                    .font(.system(size: 22).bold())
                
                Text("Apple Inc.")
                    .font(.system(size: 16))
            }
            
            HStack(alignment: .lastTextBaseline, spacing: 10) {
                Text(vm.currentPrice.toString2())
                    .font(.system(size: 32).bold())
                
                HStack {
                    Text("\(vm.currentChange > 0 ? "+" : "")\(vm.currentChange.toString2())")
                    Text("(\(vm.currentChange > 0 ? "+" : "")\(vm.currentRate.toString2())%)")
                }
                .foregroundColor(vm.currentChange < 0 ? .red : (vm.currentChange > 0 ? .green : .gray))
            }
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .environmentObject(StockViewModel())
    }
}
