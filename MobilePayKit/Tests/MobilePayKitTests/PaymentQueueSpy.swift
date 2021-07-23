import MobilePayKit
import StoreKit

class PaymentQueueSpy: PaymentQueue {

    var addObserverCalled = false
    var removeObserverCalled = false
    var addPaymentCalled = false
    var restoreCompletedTransactionCalled = false
    var finishTransactionCalled = false

    func add(_ observer: SKPaymentTransactionObserver) {
        addObserverCalled = true
    }

    func remove(_ observer: SKPaymentTransactionObserver) {
        removeObserverCalled = true
    }

    func add(_ payment: SKPayment) {
        addPaymentCalled = true
    }

    func restoreCompletedTransactions() {
        restoreCompletedTransactionCalled = true
    }

    func finishTransaction(_ transaction: SKPaymentTransaction) {
        finishTransactionCalled = true
    }
}
