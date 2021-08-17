import SwiftUI
import MobilePayKit

struct ProductRow: View {

    let product: Product
    let action: () -> Void

    var body: some View {
        HStack {
            ZStack {
                Image(systemName: "cart.fill")
                    .resizable()
                    .foregroundColor(Color(.lightGray))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(9)
                    .opacity(product.isLocked ? 0.8 : 1)
                    .blur(radius: product.isLocked ? 3.0 : 0)
                    .padding()

                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .opacity(product.isLocked ? 1 : 0)
            }

            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                Text(product.description)
                    .font(.caption)
            }

            Spacer()

            if let price = product.price, product.isLocked {
                Button(action: action, label: {
                    Text(price)
                })
                .buttonStyle(BlueButtonStyle())
            }
        }
    }

}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding([.leading, .trailing])
            .padding([.top, .bottom ], 5)
            .background(Color.blue)
            .cornerRadius(25)
    }
}

struct ProductDetail: View {

    let product: Product

    @Environment(\.presentationMode) var presentation

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Image(systemName: "cart.fill")
                    .resizable()
                    .foregroundColor(Color(.lightGray))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 256, height: 256)
                    .cornerRadius(9)
                    .padding()
            }

        }.navigationTitle(product.title)
    }
}

struct ProductList: View {

    @EnvironmentObject private var viewModel: ProductListViewModel

    var body: some View {
        List(viewModel.products, id: \.self) { product in
            Group {
                if !product.isLocked {

                    NavigationLink(destination: ProductDetail(product: product)) {

                        // Content is already unlocked - nothing to see here
                        ProductRow(product: product) { }
                    }
                } else {
                    ProductRow(product: product) {
                        viewModel.purchaseProduct(with: product.id)
                    }
                }
            }
        }.navigationTitle("MobilePayKit Demo")
    }
}

struct ProductList_Previews: PreviewProvider {
    static var previews: some View {
        ProductList()
    }
}
