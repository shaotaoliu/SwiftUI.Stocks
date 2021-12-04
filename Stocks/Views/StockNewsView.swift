import SwiftUI

struct StockNewsView: View {
    @EnvironmentObject var vm: StockViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Financial News")
                .font(.title3.bold())
            
            ForEach(vm.news, id: \.title) { news in
                Link(destination: URL(string: news.url)!) {
                    Text(news.title)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

struct StockNewsView_Previews: PreviewProvider {
    static var previews: some View {
        StockNewsView()
            .environmentObject(StockViewModel())
    }
}
