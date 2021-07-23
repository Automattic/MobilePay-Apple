import StoreKit

class TestProduct: SKProduct {

    var testProductIdentifier: String = ""

    override var productIdentifier: String {
        return testProductIdentifier
    }

    init(productIdentifier: String) {
        testProductIdentifier = productIdentifier
        super.init()
    }
}
