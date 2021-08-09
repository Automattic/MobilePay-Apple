import MobilePayKit

extension MobilePayKitConfiguration {

    static func fixture(
        oAuthToken: String = "token",
        bundleId: String? = "",
        siteId: String = "123"
    ) -> MobilePayKitConfiguration {
        return MobilePayKitConfiguration(oAuthToken: oAuthToken, bundleId: bundleId, siteId: siteId)
    }
}
