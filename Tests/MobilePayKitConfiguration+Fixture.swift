import MobilePayKit

extension MobilePayKitConfiguration {

    static func fixture(
        oAuthToken: String = "token",
        bundleId: String? = ""
    ) -> MobilePayKitConfiguration {
        return MobilePayKitConfiguration(oAuthToken: oAuthToken, bundleId: bundleId)
    }
}
