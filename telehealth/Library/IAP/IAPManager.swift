/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import StoreKit

public typealias ProductID = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void
public typealias ProductPurchaseCompletionHandler = (_ success: Bool, _ productId: ProductID?) -> Void

// MARK: - IAPManager
public class IAPManager: NSObject  {
  private let productIDs: Set<ProductID>
  private var purchasedProductIDs: Set<ProductID>
  private var productsRequest: SKProductsRequest?
  private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  private var productPurchaseCompletionHandler: ProductPurchaseCompletionHandler?
  private var jsonResponseDictionary = NSDictionary()
   var delegate: getRecipeData?

  public init(productIDs: Set<ProductID>) {
    self.productIDs = productIDs
    self.purchasedProductIDs = productIDs.filter { productID in
      let purchased = UserDefaults.standard.bool(forKey: productID)
      if purchased {
        print("Previously purchased: \(productID)")
      } else {
        print("Not purchased: \(productID)")
      }
      return purchased
    }
    super.init()
    SKPaymentQueue.default().add(self)
  }
}

// MARK: - StoreKit API
extension IAPManager {
  public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
    DispatchQueue.main.async {
          Utility.showIndecatorForProduct()
    }
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler
    productsRequest = `SKProductsRequest`(productIdentifiers: productIDs)
    productsRequest!.delegate = self
    productsRequest!.start()
  }

  public func buyProduct(_ product: SKProduct, _ completionHandler: @escaping ProductPurchaseCompletionHandler) {
    productPurchaseCompletionHandler = completionHandler
    print("Buying \(product.productIdentifier)...")
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }

  public func isProductPurchased(_ productID: ProductID) -> Bool {
    return purchasedProductIDs.contains(productID)
  }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
  
  public func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}

// MARK: - SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
//        Utility.showIndecatorForProduct()
        let products = response.products
        guard !products.isEmpty else {
            print("Product list is empty...!")
            print("Did you configure the project and set up the IAP?")
            productsRequestCompletionHandler?(false, nil)
            return
        }
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
        Utility.hideIndicatorForProduct()
    }

  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of producASts.")
    
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    Utility.hideIndicatorForProduct()
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

public func validateReceipt(for transaction: SKPaymentTransaction?) {
    // Load the receipt from the app bundle.
    //[Utils showIndicator:@"Please wait" withDelegate:nil];
    //        activityIndicatorView.startAnimating()

    let receiptURL: URL? = Bundle.main.appStoreReceiptURL
    var receipt: Data? = nil
    if let receiptURL = receiptURL {
        receipt = NSData(contentsOf: receiptURL)! as Data
    }
    if receipt == nil {
        // No local receipt -- handle the error.
    }
    
    // ... Send the receipt data to your server ...
    
    
    // Create the JSON object that describes the request
    
    let payload = "{\"receipt-data\" : \"\(receipt?.base64EncodedString(options: []) ?? "")\", \"password\" : \"\(PoohWisdomProducts.secreteId)\"}" //CONTENT_PROVIDER_SHARED_SECRET
    
    //let payload = "{\"receipt-data\" : \"\(receipt?.base64EncodedString(options: []) ?? "")\", \"password\" : \"\(yearlySharedSecret)\"}"
    
    let requestData: Data? = payload.data(using: .utf8)
    
    if requestData == nil {
        // ... Handle error ...
    }
    
    // Create a POST request with the receipt data.
    let storeURL = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")
    var storeRequest: NSMutableURLRequest? = nil
    if let storeURL = storeURL {
        storeRequest = NSMutableURLRequest(url: storeURL)
    }
    storeRequest?.httpMethod = "POST"
    storeRequest?.httpBody = requestData
    // Make a connection to the iTunes Store on a background queue.
    let queue = OperationQueue()
    
        NSURLConnection.sendAsynchronousRequest(storeRequest! as URLRequest, queue: queue, completionHandler: { response, data, connectionError in
        //            activityIndicatorView.startAnimating()
        if connectionError != nil {
            // ... Handle error ...
        } else {
            var error: Error?
            var jsonResponse: [AnyHashable : Any]? = nil
            if let data = data {
                jsonResponse = try! JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable : Any]
            }
            if let jsonResponse = jsonResponse {
                print("receipt data : \(jsonResponse)")
            }
            // [self savePurchasedItemLocally:[jsonResponse mutableCopy]];
            let jsonDictionary = jsonResponse! as NSDictionary
            if jsonDictionary.object(forKey: "pending_renewal_info") as? NSArray != nil {
                let jsonResponseDictionary = jsonResponse! as NSDictionary
                let array = jsonDictionary.object(forKey: "pending_renewal_info") as! NSArray
                let dictionary = array.object(at: 0) as! NSDictionary
                let string = dictionary.object(forKey: "auto_renew_status") as! String
                
                if (string == "1") {
             //   self.isCompleteTransaction = true
                   addSubScription(toServer: jsonResponseDictionary as? [AnyHashable : Any])
                    
                }else{
                 //   SVProgressHUD.dismiss()
                }
            }
         
            if jsonResponse == nil {
                // ... Handle error ...
            }
            // ... Send a response back to the device ...
        }
    })
}

public func addSubScription(toServer subscriptionDetailDictionary: [AnyHashable : Any]?) {

    let subscriptionDetailDic = subscriptionDetailDictionary! as NSDictionary
    let productIdArray = subscriptionDetailDic.object(forKey: "pending_renewal_info") as! NSArray
    let productIdDictionary = productIdArray.object(at: 0) as! NSDictionary
    let purchaseDateArray = subscriptionDetailDic.object(forKey: "latest_receipt_info") as! NSArray
    let purchaseDateDictionary = purchaseDateArray.object(at: 0) as! NSDictionary
    let purchaseDateLastDictionary = purchaseDateArray.object(at: purchaseDateArray.count - 1) as! NSDictionary
    var parameters = [String : Any]()
    
    
    
    if (productIdDictionary.object(forKey: "product_id") as! String) == PoohWisdomProducts.monthlySub
    {
        parameters = 
            ["productId":productIdDictionary.object(forKey: "product_id") as! String,
             "purchaseDate": (purchaseDateLastDictionary.object(forKey: "purchase_date")! as! String).prefix(19),
                //getFormattedDate((purchaseDateLastDictionary.object(forKey: "purchase_date") as! String)),
             "purchaseState":"1",
             "platform":"iOS",
             "deviceToken":UIDevice.current.identifierForVendor!.uuidString,
             "packageName":Bundle.main.bundleIdentifier!,
             "purchaseToken":purchaseDateDictionary.object(forKey: "transaction_id")!,
             "autoRenewing":productIdDictionary.object(forKey: "auto_renew_status")!,
             "expiryDate":(purchaseDateLastDictionary.object(forKey: "expires_date")! as! String).prefix(19),
//                (purchaseDateLastDictionary.object(forKey: "expires_date")! as! String).prefix(10),
             "amount":"3.99",
             "isPaid":1,
              "type":1]
        
//        UserDefaults().set(amountString, forKey: "monthly_plan_amount")
    }
    else{
        parameters =
            ["productId":productIdDictionary.object(forKey: "product_id") as! String,
             "purchaseDate":getFormattedDate((purchaseDateLastDictionary.object(forKey: "purchase_date") as! String)),
             "purchaseState":"1",
             "platform":"iOS",
             "deviceToken":UIDevice.current.identifierForVendor!.uuidString,
             "packageName":Bundle.main.bundleIdentifier!,
             "purchase_token":purchaseDateDictionary.object(forKey: "transaction_id")!,
             "autoRenewing":productIdDictionary.object(forKey: "auto_renew_status")!,
             "expiryDate":(purchaseDateLastDictionary.object(forKey: "expires_date")! as! String).prefix(10),
             "amount":"3.99",
             "isPaid":1,
             "type":1]
//        UserDefaults().set(amountStringForYearly, forKey: "yearly_plan_amount")
    }

    PoohWisdomProducts.store.delegate?.didGetRecipeData(recipeData: parameters as NSDictionary)
}

func getFormattedDate(_ dateString: String?) -> String {
    var dateString = dateString
    dateString = dateString?.replacingOccurrences(of: "Etc/GMT", with: "GMT")
    var dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
    //dateformatter.dateFormat = "yyyy-MM-dd"
    let date: Date? = dateformatter.date(from: dateString ?? "")
    if let date = date {
        print("You may Need This  =========\(date)")
    }
    dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var convertedString: String? = nil
    convertedString = ""
    if let date = date {
        convertedString = dateformatter.string(from: date)
    }
    print("Converted purchase date UTC  : \(convertedString ?? "")")
    return convertedString!
}

// MARK: - SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch (transaction.transactionState) {
      case .purchased:
        complete(transaction: transaction)
        break
      case .failed:
        Utility.hideIndicatorForProduct()
        fail(transaction: transaction)
        break
      case .restored:
        Utility.hideIndicatorForProduct()
        restore(transaction: transaction)
        break
      case .deferred:
        break
      case .purchasing:
        Utility.showIndecatorForProduct()
        break
      @unknown default:
         Utility.hideIndicatorForProduct()
        print(transaction.transactionState.rawValue)
        }
    }
  }

  private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        Utility.hideIndicatorForProduct()
        validateReceipt(for: transaction)
        productPurchaseCompleted(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    
     
  }

  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
    print("restore... \(productIdentifier)")
      validateReceipt(for: transaction)
        productPurchaseCompleted(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
   
  }

    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        Utility.hideIndicatorForProduct()
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        productPurchaseCompletionHandler?(false, nil)
        SKPaymentQueue.default().finishTransaction(transaction)
        clearHandler()
    }

  private func productPurchaseCompleted(identifier: ProductID?) {
    guard let identifier = identifier else { return }

    purchasedProductIDs.insert(identifier)
    UserDefaults.standard.set(true, forKey: identifier)
    productPurchaseCompletionHandler?(true, identifier)
    clearHandler()
  }

  private func clearHandler() {
    productPurchaseCompletionHandler = nil
  }
}
protocol getRecipeData: class {
    func didGetRecipeData(recipeData: NSDictionary)
}
