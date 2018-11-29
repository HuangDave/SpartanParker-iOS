import PassKit

enum PaymentConfigurations {
    static let merchantId: String = ""
    static let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex ]
    static let capabilities: PKMerchantCapability = .capability3DS
    static let countryCode: String = "US"
    static let currencyCode: String = "USD"
}