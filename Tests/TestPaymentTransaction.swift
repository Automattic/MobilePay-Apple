import StoreKit

class TestPaymentTransaction: SKPaymentTransaction {

    let testPayment: SKPayment
    let testTransactionState: SKPaymentTransactionState
    let testError: Error?

    init(payment: SKPayment, transactionState: SKPaymentTransactionState, error: Error? = nil) {
        testPayment = payment
        testTransactionState = transactionState
        testError = error
        super.init()
    }

    override var payment: SKPayment {
        return testPayment
    }

    override var transactionState: SKPaymentTransactionState {
        return testTransactionState
    }

    override var error: Error? {
        return testError
    }
}
