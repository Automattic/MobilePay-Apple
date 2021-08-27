# MobilePayKit

Client library for making in-app purchases on iOS and macOS Automattic apps


## Introduction

MobilePayKit is a client library for making in-app purchases. This project facilitates in-app purchases by coordinating requests to:

- Apple's [StoreKit APIs](https://developer.apple.com/documentation/storekit/original_api_for_in-app_purchase)
- Our WP.com in-app purchase APIs that communicate with the [MobilePay WooCommerce plugin](https://mobilepaymentsp2.wordpress.com/2021/07/14/how-is-this-all-going-to-work-anyways/)

Realistically this library is only useful for Automattic-based projects, but the idea is to share what we've made.


## Features

- [x] iOS and macOS compatible
- [x] **Consumable** in-app purchases support
- [ ]  **Non-Consumable** in-app purchases support
- [ ]  **Auto-Renewable Subscriptions** in-app purchases support
- [ ]  **Non-Renewable Subscriptions** in-app purchases support
- [ ] Restoring purchases


## Requirements
- iOS 13+
- macOS 10.15+
- Swift 5.3


## Installation

### Cocoapods

To integrate MobilePayKit into your Xcode project via [CocoaPods](http://cocoapods.org), specify it in your `Podfile`:

```ruby
pod 'MobilePayKit', :git => 'git@github.com:Automattic/MobilePay-Apple.git', :branch => 'develop'
```

### Swift Package Manager

To integrate MobilePayKit into your Xcode project via [Swift Package Manager](https://swift.org/package-manager/), add MobilePayKit as a dependency in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Automattic/MobilePay-Apple", .upToNextMajor(from: "0.0.1"))
]
```


## Usage

Check out the iOS and macOS examples under the [Example](./Example) directory for more information on how to make in-app purchases via MobilePayKit.

### Import MobilePayKit

Import the MobilePayKit module in your project.

```swift
import MobilePayKit
```

### Configuring MobilePayKit

Before you call any MobilePayKit methods, configure a MobilePayKit shared instance by setting the WordPress oAuth token as well as the app's bundle ID.

```swift
MobilePayKit.configure(
    oAuthToken: "<token>",
    bundleId: "<bundleId>"
)
```

### Fetching products

Fetch products that are available for in-app purchases.

```swift
MobilePayKit.shared.fetchProducts { [weak self] result in
    switch result {
    case .success(let products):
        print("Fetched products: \(products)")
    case .failure(let error):
        print("Error fetching products: \(error.localizedDescription)")
    }
}
```

### Purchasing a product

Purchase a product using the product identifier.

```swift
MobilePayKit.shared.purchaseProduct(with: identifier) { [weak self] result in
    switch result {
    case .success(let transaction):
        print("Purchased product: \(transaction.payment.productIdentifier)")
    case .failure(let error):
        print("Error purchasing product: \(error.localizedDescription)")
    }
}
```

## Testing in-app purchases

### Testing locally via Xcode

To test in-app purchases locally, each developer will have to modify their Xcode scheme to let Xcode know to use the local `Configuration.storekit` file. Check out the [Apple documentation on testing locally via Xcode](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode) for more information.

1. Click on your app's scheme at the top of Xcode and select **Edit Scheme**
2. Select **Run**
3. Select **Options**
4. Change the **StoreKit Configuration** to point to `Configuration.storekit` (the local StoreKit file)


### Testing via the App Store Connect Sandbox

TBD

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D


## License

MobilePayKit is available under the GPL license. See the [LICENSE file](./LICENSE) for more info.
