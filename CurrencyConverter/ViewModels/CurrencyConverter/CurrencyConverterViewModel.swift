//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit
import OSLog

final class CurrencyConverterViewModel {
    
    // MARK: - Private properties
    private(set) var fromAmount: Observable<String?> = Observable(nil)
    private(set) var fromCurrency: Observable<Currency> = Observable(.EUR)
    private(set) var fromConversionRate: Observable<Double> = Observable(0)
    
    private(set) var toAmount: Observable<Double> = Observable(0)
    private(set) var toConversionRate: Observable<Double> = Observable(0)
    private(set) var toCurrency: Observable<Currency> = Observable(.USD)
    
    private(set) var currencyList: Observable<[Currency]> = Observable(Currency.avalibleCurrencies())
    
    private(set) var isPortraitOrientation: Observable<Bool> = Observable(true)
    private(set) var isLoading: Observable<Bool> = Observable(false)
    private(set) var error: Observable<Swift.Error?> = Observable(nil)
    
    private var timer: Timer?
    
    //MARK: - Inits
    init(isPortraitOrientation: Bool) {
        updateOrientation(isPortraitOrientation)
        setupNotifications()
        calculateConversion(isAutoload: false)
    }
}

// MARK: - Methods
extension CurrencyConverterViewModel {
    func updateOrientation(_ isPortrait: Bool) {
        isPortraitOrientation.value = isPortrait
    }
    
    func startAutoUpdate() {
        startAutoRefresh()
    }
    
    func updateFromAmount(_ amount: String?) {
        fromAmount.value = amount
        calculateConversion(isAutoload: false)
    }
    
    func updateFromCurrency(_ currency: Currency) {
        fromCurrency.value = currency
        calculateConversion(isAutoload: false)
    }
    
    func updateToCurrency(_ currency: Currency) {
        toCurrency.value = currency
        calculateConversion(isAutoload: false)
    }
    
    func switchCurrencies() {
        
        let oldFromCurrency = fromCurrency.value
        
        fromCurrency.value = toCurrency.value
        toCurrency.value = oldFromCurrency
        
        fromAmount.value = toAmount.value == 0 ? nil : toAmount.value.currencyFormat()
        calculateConversion(isAutoload: false)
    }
}

// MARK: - Private methods
private extension CurrencyConverterViewModel {
    
     func calculateConversion(isAutoload: Bool) {
        
        let _fromAmount: Double = self.fromAmount.value?.toAmountDouble() ?? 0
        
        var fromAmountValue: Double = _fromAmount
        
        if fromAmountValue == 0 {
            fromAmountValue = 1
        }
        
        let model = ExchangeRateRequest(
            fromAmount: fromAmountValue,
            fromCurrency: fromCurrency.value.rawValue,
            toCurrency: toCurrency.value.rawValue
        )
        
        stopAutoRefresh()
        
        if !isAutoload {
            self.isLoading.value = true
        }
        
        ExchangeRateService.fetchExchangeRates(model: model) { [weak self] result in
            DispatchQueue.main.async {
                
                guard let self else {
                    return
                }
                if !isAutoload {
                    self.isLoading.value = false
                }
                
                switch result {
                case .success(let response):
                    
                    let rateFromTo = response.amount / fromAmountValue
                    let rateToFrom = 1 / rateFromTo
                    
                    self.fromConversionRate.value = rateFromTo
                    self.toConversionRate.value = rateToFrom
                    self.toAmount.value = _fromAmount == 0 ? 0 : response.amount
                    
                    self.startAutoRefresh()
                case .failure(let error):
                    Logger.network.warning(
                        "⚠️ WARNING: Failed to fetch exchange rate: \(error.localizedDescription) ⚠️"
                    )
                    self.error.value = error
                }
            }
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    func startAutoRefresh() {
        stopAutoRefresh()
        timer = Timer.scheduledTimer(
            withTimeInterval: Config.timeIntervalAutoRefresh,
            repeats: true
        ) { [weak self] _ in
            self?.calculateConversion(isAutoload: true)
        }
    }
    
    func stopAutoRefresh() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Actions
extension CurrencyConverterViewModel {
    @objc
    private func appDidBecomeActive() {
        startAutoRefresh()
    }
    
    @objc
    private func appDidEnterBackground() {
        stopAutoRefresh()
    }
}
