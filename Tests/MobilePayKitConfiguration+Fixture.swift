import MobilePayKit

extension MobilePayKitConfiguration {

    static func fixture(
        oAuthToken: String = "token",
        bundleId: String? = "",
        siteId: Int? = 123
    ) -> MobilePayKitConfiguration {
        return MobilePayKitConfiguration(oAuthToken: oAuthToken, bundleId: bundleId, siteId: siteId)
    }
}
