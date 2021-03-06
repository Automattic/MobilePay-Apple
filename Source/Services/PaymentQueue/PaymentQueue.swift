import Foundation
import StoreKit

public protocol PaymentQueue: AnyObject {

    var storefront: SKStorefront? { get }

    func add(_ observer: SKPaymentTransactionObserver)
    func remove(_ observer: SKPaymentTransactionObserver)

    func add(_ payment: SKPayment)

    func restoreCompletedTransactions()

    func finishTransaction(_ transaction: SKPaymentTransaction)
}

extension SKPaymentQueue: PaymentQueue { }
