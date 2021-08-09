import StoreKit

class TestPaymentTransaction: SKPaymentTransaction {

    let testPayment: SKPayment
    let testTransactionState: SKPaymentTransactionState

    init(payment: SKPayment, transactionState: SKPaymentTransactionState) {
        testPayment = payment
        testTransactionState = transactionState
        super.init()
    }

    override var payment: SKPayment {
        return testPayment
    }

    override var transactionState: SKPaymentTransactionState {
        return testTransactionState
    }
}
