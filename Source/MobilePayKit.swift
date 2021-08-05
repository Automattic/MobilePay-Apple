import Foundation
import StoreKit

public struct MobilePayKitConfiguration {
    public let oAuthToken: String
    public let bundleId: String?

    public init(oAuthToken: String, bundleId: String?) {
        self.oAuthToken = oAuthToken
        self.bundleId = bundleId
    }
}

public class MobilePayKit: NSObject {

    private static let sharedInstance = MobilePayKit()

    private static var configuration: MobilePayKitConfiguration?

    private let appStoreService: AppStoreService

    // MARK: - Init

    private override init() {
        guard let configuration = MobilePayKit.configuration else {
            fatalError("Configuration must be set")
        }

        self.appStoreService = AppStoreService(configuration: configuration)

        super.init()
    }

    // MARK: - Public

    public class func configure(with configuration: MobilePayKitConfiguration) {
        self.configuration = configuration
    }

    public class func fetchProducts(completion: @escaping FetchCompletionCallback) {
        sharedInstance.fetchProducts(completion: completion)
    }

    public class func purchaseProduct(with identifier: String, completion: @escaping PurchaseCompletionCallback) {
        sharedInstance.purchaseProduct(with: identifier, completion: completion)
    }

    public class func restorePurchases() {
        sharedInstance.restorePurchases()
    }
}

extension MobilePayKit {

    // MARK: - Private

    private func fetchProducts(completion: @escaping FetchCompletionCallback) {
        appStoreService.fetchProducts(completion: completion)
    }

    private func purchaseProduct(with identifier: String, completion: @escaping PurchaseCompletionCallback) {

        // Check if the product exists in the App Store before purchasing
        guard let product = appStoreService.fetchProduct(for: identifier) else {
            return
        }

        appStoreService.purchaseProduct(product, completion: completion)

    }

    private func restorePurchases() {
        appStoreService.restorePurchases()
    }
}
