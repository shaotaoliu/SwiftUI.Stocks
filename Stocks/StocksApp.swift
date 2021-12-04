import SwiftUI

@main
struct StocksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(StockViewModel())
                .onAppear {
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
