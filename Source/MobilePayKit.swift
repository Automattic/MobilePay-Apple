import Foundation
import StoreKit

public struct MobilePayKitConfiguration {
    public let oAuthToken: String
    public let bundleId: String?
    public let siteId: String?

    public init(oAuthToken: String, bundleId: String?, siteId: String?) {
        self.oAuthToken = oAuthToken
        self.bundleId = bundleId
        self.siteId = siteId
    }
}

public class MobilePayKit: NSObject {

    public static var shared: MobilePayKit!

    private let configuration: MobilePayKitConfiguration

    private let appStoreService: AppStoreServiceProtocol

    // MARK: - Init

    public init(configuration: MobilePayKitConfiguration, appStoreService: AppStoreServiceProtocol? = nil) {
        self.configuration = configuration
        self.appStoreService = appStoreService ?? AppStoreService(configuration: configuration)
        super.init()
        MobilePayKit.shared = self
    }

    // MARK: - Public

    public static func configure(oAuthToken: String, bundleId: String?, siteId: String? = nil) {
        let configuration = MobilePayKitConfiguration(oAuthToken: oAuthToken, bundleId: bundleId, siteId: siteId)
        _ = MobilePayKit(configuration: configuration)
    }

    public func fetchProducts(completion: @escaping FetchCompletionCallback) {
        appStoreService.fetchProducts(completion: completion)
    }

    public func purchaseProduct(with identifier: String, completion: @escaping PurchaseCompletionCallback) {

        // Check if the product exists in the App Store before purchasing
        guard let product = appStoreService.fetchProduct(for: identifier) else {
            return
        }

        appStoreService.purchaseProduct(product, completion: completion)

    }

    public func restorePurchases() {
        appStoreService.restorePurchases()
    }
}
