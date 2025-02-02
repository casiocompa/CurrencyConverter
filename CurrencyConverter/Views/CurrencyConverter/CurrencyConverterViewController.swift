//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit

final class CurrencyConverterViewController: ViewController {
   
    //MARK: - ContentView
    var contentView: CurrencyConverterContentView? {
        return view as? CurrencyConverterContentView
    }
    
    //MARK: - ViewModel
    private let viewModel: CurrencyConverterViewModel!

    //MARK: - Inits
    init() {
        self.viewModel = CurrencyConverterViewModel(
            isPortraitOrientation: UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        )
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func loadView() {
        let model = CurrencyConverterContentViewModel(
            isPortraitOrientation: viewModel.isPortraitOrientation.value,
            isLoading: viewModel.isLoading.value,
            fromAmount: viewModel.fromAmount.value,
            fromCurrency: viewModel.fromCurrency.value,
            fromConversionRate: viewModel.fromConversionRate.value,
            toAmount: viewModel.toAmount.value,
            toConversionRate: viewModel.toConversionRate.value,
            toCurrency: viewModel.toCurrency.value
        )
        
        let contentView = CurrencyConverterContentView(
            viewModel: model,
            delegate: self
        )
        
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        viewModel.startAutoUpdate()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { [weak self] (_) in
            guard let self else {
                return
            }
            self.viewModel.updateOrientation(self.superHeight > self.superWidth)
        }
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private methods
private extension CurrencyConverterViewController {

    func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setupBindings() {
        self.viewModel.fromAmount.bind { [weak self] value in
            guard let self else {
                return
            }
            
            self.contentView?.update(
                fromAmount: value,
                currencySymbol: self.viewModel.fromCurrency.value.symbol
            )
        }
        self.viewModel.fromCurrency.bind { [weak self] value in
            guard let self else {
                return
            }
            
            self.contentView?.update(
                fromCurrency: value
            )
            
            self.contentView?.update(
                fromRate: self.viewModel.fromConversionRate.value,
                fromCurrencySymbol: value.symbol,
                toCurrencySymbol: self.viewModel.toCurrency.value.symbol
            )
        }
        
        self.viewModel.fromConversionRate.bind { [weak self] value in
            guard let self else {
                return
            }
            
            self.contentView?.update(
                fromRate: value,
                fromCurrencySymbol: self.viewModel.fromCurrency.value.symbol,
                toCurrencySymbol: self.viewModel.toCurrency.value.symbol
            )
        }
        
        self.viewModel.toAmount.bind { [weak self] value in
            guard let self else {
                return
            }
            self.contentView?.update(
                toAmount: value,
                currencySymbol: self.viewModel.toCurrency.value.symbol
            )
        }
        
        self.viewModel.toCurrency.bind { [weak self] value in
            guard let self else {
                return
            }
            
            self.contentView?.update(
                toCurrency: value
            )
            
            self.contentView?.update(
                toRate: self.viewModel.fromConversionRate.value,
                fromCurrencySymbol: value.symbol,
                toCurrencySymbol: self.viewModel.fromCurrency.value.symbol
            )
        }
        
        self.viewModel.toConversionRate.bind { [weak self] value in
            guard let self else {
                return
            }
            
            self.contentView?.update(
                toRate: value,
                fromCurrencySymbol: self.viewModel.toCurrency.value.symbol,
                toCurrencySymbol: self.viewModel.fromCurrency.value.symbol
            )
        }
        
        self.viewModel.isLoading.bind { [weak self] value in
            guard let self else {
                return
            }
            self.contentView?.updateActivityIndicator(value)
        }
        
        self.viewModel.isPortraitOrientation.bind { [weak self] value in
            guard let self else {
                return
            }
            self.contentView?.updateaLayoutForOrientation(isPortrait: value)
        }
        
        self.viewModel.error.bind { [weak self] value in
            guard let self else {
                return
            }
            self.didReceiveError(value)
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeOrientation),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc
    func didChangeOrientation() {
        self.viewModel.updateOrientation(superHeight > superWidth)
    }
}

// MARK: - ContentViewDelegate
extension CurrencyConverterViewController: CurrencyConverterContentViewDelegate {
    
    func didTapSwitchCurrencies() {
        viewModel.switchCurrencies()
    }
    
    func didEnterAmount(_ amount: String?) {
        viewModel.updateFromAmount(amount)
    }
    
    func didTapSelectCurrency(type: ExchangeDirection) {
#warning("to do")
    }
}

@available(iOS 17, *)
#Preview {
    let vc = CurrencyConverterViewController()
    return vc
}
