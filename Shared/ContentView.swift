//
//  ContentView.swift
//  Shared
//
//  Created by Momo Ozawa on 2021/07/19.
//

import SwiftUI

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

struct ContentView: View {
    @EnvironmentObject private var coordinator: PaymentCoordinator
    
    var body: some View {
        NavigationView {
            List(coordinator.contentList, id: \.self) { content in
                Group {
                    if !content.isLocked {
                        NavigationLink(destination:
                                        VStack(alignment: .leading) {
                                            Text(content.title)
                                                .font(.headline)
                                            Image(content.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 256, height: 256)
                                                .cornerRadius(9)
                                                .padding()
                                        }
                                       
                        ) {
                            
                            // Content is already unlocked - nothing to see here
                            PurchasableContentRow(content: content) { }
                        }
                    } else {
                        PurchasableContentRow(content: content) {
                            
                            // Check if the product exists before purchasing
                            if let product = coordinator.fetchProduct(for: content.id) {
                                coordinator.purchaseProduct(product)
                            }
                        }
                    }
                }.navigationBarItems(trailing: Button("Restore") {
                    coordinator.restorePurchases()
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
