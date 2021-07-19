//
//  MobilePay_AppleApp.swift
//  Shared
//
//  Created by Momo Ozawa on 2021/07/19.
//

import SwiftUI

@main
struct MobilePay_AppleApp: App {

    @StateObject private var paymentCoordinator = PaymentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(paymentCoordinator)
        }
    }
}
