import SwiftUI

struct StockInfoView: View {
    @EnvironmentObject var vm: StockViewModel
    private let rowSpace: CGFloat = 10
    private let columnSpace: CGFloat = 30
    private let fontSize: CGFloat = 14
    
    var body: some View {
            VStack(spacing: rowSpace) {
                HStack(spacing: columnSpace) {
                    StockField(label: "Pre Close", value: StockInfo.preClosePrice.toString2())
                    StockField(label: "Volumes", value: vm.totalVolume.toVolumeString())
                }
                
                HStack(spacing: columnSpace) {
                    StockField(label: "Open", value: StockInfo.openPrice.toString2())
                    StockField(label: "Mkt cap", value: vm.capital)
                }
                
                HStack(spacing: columnSpace) {
                    StockField(label: "High", value: vm.highest.toString2())
                    StockField(label: "P/E", value: StockInfo.pe.toString2())
                }
                
                HStack(spacing: columnSpace) {
                    StockField(label: "Low", value: vm.lowest.toString2())
                    StockField(label: "52-wk high", value: max(StockInfo.week52High, vm.highest).toString2())
                }
                
                HStack(spacing: columnSpace) {
                    StockField(label: "Avg price", value: vm.avgPrice.toString2())
                    StockField(label: "52-wk low", value: min(StockInfo.week52Low, vm.lowest).toString2())
                }
            }
            .font(.system(size: fontSize))
    }
}

struct StockField: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
        }
    }
}

struct InfoField_Previews: PreviewProvider {
    static var previews: some View {
        StockInfoView()
            .padding()
            .environmentObject(StockViewModel())
    }
}
