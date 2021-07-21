import SwiftUI
import MobilePayKit

struct PurchasableContentRow: View {

    let content: PurchasableContent
    let action: () -> Void

    var body: some View {
        HStack {
            ZStack {
                Image(content.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(9)
                    .opacity(content.isLocked ? 0.8 : 1)
                    .blur(radius: content.isLocked ? 3.0 : 0)
                    .padding()

                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .opacity(content.isLocked ? 1 : 0)
            }

            VStack(alignment: .leading) {
                Text(content.title)
                    .font(.headline)
                Text(content.description)
                    .font(.caption)
            }

            Spacer()

            if let price = content.price, content.isLocked {
                Button(action: action, label: {
                    Text(price)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing])
                        .padding([.top, .bottom ], 5)
                        .background(Color.blue)
                        .cornerRadius(25)
                })
            }
        }
    }

}

struct PurchasableContentDetail: View {

    let content: PurchasableContent

    @Environment(\.presentationMode) var presentation

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Image(content.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 256, height: 256)
                    .cornerRadius(9)
                    .padding()
            }

        }.navigationTitle(content.title)
    }
}

struct ContentView: View {

    @EnvironmentObject private var paymentManager: PaymentManager

    var body: some View {
        NavigationView {
            List(paymentManager.contentList, id: \.self) { content in
                Group {
                    if !content.isLocked {

                        NavigationLink(destination: PurchasableContentDetail(content: content)) {

                            // Content is already unlocked - nothing to see here
                            PurchasableContentRow(content: content) { }
                        }
                    } else {
                        PurchasableContentRow(content: content) {

                            // Check if the product exists before purchasing
                            if let product = paymentManager.fetchProduct(for: content.id) {
                                paymentManager.purchaseProduct(product) { _ in }
                            }
                        }
                    }
                }.navigationBarItems(trailing: Button("Restore") {
                    paymentManager.restorePurchases()
                })
            }.navigationTitle("Rocket fuel shop")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
