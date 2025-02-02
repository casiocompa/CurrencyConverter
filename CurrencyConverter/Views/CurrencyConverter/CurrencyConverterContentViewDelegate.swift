//
//  CurrencyConverterContentViewDelegate.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit

protocol CurrencyConverterContentViewDelegate: AnyObject {
    func didEnterAmount(_ amount: String?)
    func didTapSelectCurrency(type: ExchangeDirection)
    func didTapSwitchCurrencies()
}

enum ExchangeDirection {
    case from
    case to
}

final class CurrencyConverterContentView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let amountFont: UIFont = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let buttonSize: CGSize = CGSize(width: 80, height: 40)
        static let cornerRadius: CGFloat = 20
  
        static let paddingPortrait: CGFloat = Constants.isIpad ? 40 : 16
        static let paddingLandscape: CGFloat = Constants.isIpad ? 40 : 8
        static let stackSpacingPortrait: CGFloat = Constants.isIpad ? 30 : 10
        static let stackSpacingLandscape: CGFloat = Constants.isIpad ? 30 : 4
        static let elementHeightPortrait: CGFloat = 40
        static let elementHeightLandscape: CGFloat = Constants.isIpad ? 40 : 30
        
        static let topStackSpacingPortrait: CGFloat = 8
        static let topStackSpacingLandscape: CGFloat = Constants.isIpad ? 8 : 0
        
        static var isIpad: Bool {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    
    // MARK: - Properties
    private var fromCurrencySymbol: String? = nil
    private var toCurrencySymbol: String? = nil
    
    private var topConstraint: NSLayoutConstraint?
    private var botConstraint: NSLayoutConstraint?
    private var leadConstraint: NSLayoutConstraint?
    private var trailConstraint: NSLayoutConstraint?
    
    // MARK: - Delegate
    private weak var delegate: CurrencyConverterContentViewDelegate?
    
    // MARK: - UI
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large).prepareForAutoLayout()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    private lazy var fillView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    ///from elements
    private lazy var fromFlagImageView: UIImageView = createFlagImageView()
    private lazy var fromTitleLabel: UILabel = createTitleLabel(text: Localization.from_title.description)
    private lazy var fromCurrencyLabel: UILabel = createCurrencyLabel()
    private lazy var fromDropdownButton: UIButton = createDropdownButton(
        action: {
            let actionbutton = UIAction { [weak self] _ in
                self?.didTapFromCurrency()
            }
            return actionbutton
        }()
    )
    
    private  lazy var fromAmountTextField: UITextField = {
        let fld = UITextField().prepareForAutoLayout()
        fld.keyboardType = .decimalPad
        fld.textAlignment = .right
        fld.font = Constants.amountFont
        fld.textColor = .red
        let action = UIAction { [weak self] _ in
            self?.didChangeAmount()
        }
        fld.addAction(action, for: .editingChanged)
        return fld
    }()
    
    private lazy var fromRateLabel: UILabel = createRateLabel()
    
    private lazy var fromStack: UIStackView = {
        return createCurrencyBlock(
            flagImage: fromFlagImageView,
            title: fromTitleLabel,
            currency: fromCurrencyLabel,
            dropdownbutton: fromDropdownButton,
            amount: fromAmountTextField,
            rate: fromRateLabel
        )
    }()
    
    /// to elements
    private lazy var toFlagImageView: UIImageView = createFlagImageView()
    private lazy var toTitleLabel: UILabel = createTitleLabel(text: Localization.to_title.description)
    private lazy var toCurrencyLabel: UILabel = createCurrencyLabel()
    private lazy var toDropdownButton: UIButton = createDropdownButton(
        action: {
            let actionbutton = UIAction { [weak self] _ in
                self?.didTapToCurrency()
            }
            return actionbutton
        }()
    )
    
    private lazy var toAmountLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.textColor = .green
        label.font = Constants.amountFont
        label.textAlignment = .right
        return label
    }()
    
    private lazy var toRateLabel: UILabel = createRateLabel()
    
    private lazy var toStack: UIStackView = {
        return createCurrencyBlock(
            flagImage: toFlagImageView,
            title: toTitleLabel,
            currency: toCurrencyLabel,
            dropdownbutton: toDropdownButton,
            amount: toAmountLabel,
            rate: toRateLabel
        )
    }()
    
    ///
    private lazy var switchCurrenciesButton: UIButton = {
        let button = UIButton(type: .system).prepareForAutoLayout()
        button.setImage(Assets.Images.arrowUpArrowDown.image(), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = Constants.cornerRadius
        button.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width).isActive = true
        let actionbutton = UIAction { [weak self] _ in
            self?.didTapSwitchCurrencies()
        }
        button.addAction(actionbutton, for: .primaryActionTriggered)
        button.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
        ])
        return button
    }()
    
    private lazy var switchView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = .clear
        
        let lineView: UIView = {
            let view = UIView().prepareForAutoLayout()
            view.backgroundColor = .label.withAlphaComponent(0.2)
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return view
        }()
        
        view.addSubview(lineView)
        view.addSubview(switchCurrenciesButton)
        
        NSLayoutConstraint.activate([
            switchCurrenciesButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            switchCurrenciesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lineView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.heightAnchor.constraint(equalTo: switchCurrenciesButton.heightAnchor).isActive = true
        
        return view
    }()
    
    ///top stack
    private lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            fromStack,
            switchView,
            toStack,
        ]).prepareForAutoLayout()
        stack.axis = .vertical
        stack.spacing = Constants.topStackSpacingPortrait
        stack.distribution = .fill
        return stack
    }()
    
    lazy var keypadView: CurrencyConverterKeypadView = {
        let view = CurrencyConverterKeypadView(delegate: self)
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                fillView,
                topStack,
                keypadView
            ]
        ).prepareForAutoLayout()
        stack.axis = .vertical
        stack.spacing = Constants.topStackSpacingPortrait
        stack.alignment = .fill
        stack.distribution = .equalCentering
        return stack
    }()
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        viewModel: CurrencyConverterContentViewModel,
        delegate: CurrencyConverterContentViewDelegate?
    ) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
        setupConstriant()
        setupInitialState(model: viewModel)
    }
}

// MARK: - Update Methods
extension CurrencyConverterContentView {
    
    func update(fromAmount: String?, currencySymbol: String) {
        self.fromAmountTextField.text = createFromAmountText(
            currencySymbol: currencySymbol,
            amount: fromAmount
        )
    }
    
    func update(fromCurrency: Currency) {
        Task {
            self.fromFlagImageView.image = await fromCurrency.flagImage?.byPreparingForDisplay()
        }
        
        fromAmountTextField.text = changeCurrencySymbol(
            from: fromCurrencySymbol,
            to: fromCurrency.symbol,
            text: fromAmountTextField.text
        )
            
        self.fromCurrencyLabel.text = fromCurrency.shortName
        self.fromCurrencySymbol = fromCurrency.symbol
    }
    
    
    func update(fromRate: Double?, fromCurrencySymbol: String, toCurrencySymbol: String) {
        self.fromRateLabel.text = createRateText(
            fromCurrencySymbol: fromCurrencySymbol,
            toCurrencySymbol: toCurrencySymbol,
            rate: fromRate
        )
    }
    
    func update(toAmount: Double, currencySymbol: String) {
        self.toAmountLabel.text = createToAmountText(
            currencySymbol: currencySymbol,
            amount: toAmount
        )
    }
    func update(toCurrency: Currency) {
        Task {
            self.toFlagImageView.image = await toCurrency.flagImage?.byPreparingForDisplay()
        }
        
        toAmountLabel.text = changeCurrencySymbol(
            from: toCurrencySymbol,
            to: toCurrency.symbol,
            text: toAmountLabel.text
        )
        
        self.toFlagImageView.image = toCurrency.flagImage
        self.toCurrencyLabel.text = toCurrency.shortName
        self.toCurrencySymbol = toCurrency.symbol
    }
    
    func update(toRate: Double?, fromCurrencySymbol: String, toCurrencySymbol: String) {
        self.toRateLabel.text = createRateText(
            fromCurrencySymbol: fromCurrencySymbol,
            toCurrencySymbol: toCurrencySymbol,
            rate: toRate
        )
    }
    
    func setupInitialState(model: CurrencyConverterContentViewModel) {
        updateaLayoutForOrientation(isPortrait: model.isPortraitOrientation)
        updateActivityIndicator(model.isLoading)
        update(
            fromAmount: model.fromAmount,
            currencySymbol: model.fromCurrency.symbol
        )
        update(fromCurrency: model.fromCurrency)
        update(
            fromRate: model.fromConversionRate,
            fromCurrencySymbol: model.fromCurrency.symbol,
            toCurrencySymbol: model.toCurrency.symbol
        )
        
        update(
            toAmount: model.toAmount,
            currencySymbol: model.toCurrency.symbol
        )
        update(toCurrency: model.toCurrency)
        update(
            toRate: model.toConversionRate,
            fromCurrencySymbol: model.toCurrency.symbol,
            toCurrencySymbol: model.fromCurrency.symbol
        )
    }
    
    func updateActivityIndicator(_ isLoading: Bool) {
        if isLoading {
            startLoading()
        }else {
            stopLoading()
        }
    }
    
    func updateaLayoutForOrientation(isPortrait: Bool) {
        animationForAdjustLayoutForOrientation(isPortrait: isPortrait)
    }
}

// MARK: - Layout Adjustments
private extension CurrencyConverterContentView {
    
    func setupConstriant() {
        topConstraint = mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        topConstraint?.priority = .init(999)
        topConstraint?.isActive = true
        
        botConstraint = mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        botConstraint?.priority = .init(999)
        botConstraint?.isActive = true
        
        leadConstraint = mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        leadConstraint?.priority = .init(999)
        leadConstraint?.isActive = true
        
        trailConstraint = mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        trailConstraint?.priority = .init(999)
        trailConstraint?.isActive = true
    }
    
    func animationForAdjustLayoutForOrientation(isPortrait: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else {
                return
            }
            self.adjustLayoutForOrientation(isPortrait: isPortrait)
            keypadView.updateaLayoutForOrientation(isPortrait: isPortrait)
        }
    }
    
    func adjustLayoutForOrientation(isPortrait: Bool) {
        let elementHeight: CGFloat = isPortrait ? Constants.elementHeightPortrait : Constants.elementHeightLandscape
        let padding: CGFloat = isPortrait ? Constants.paddingPortrait : Constants.paddingLandscape
        let stackSpacing: CGFloat = isPortrait ? Constants.stackSpacingPortrait : Constants.stackSpacingLandscape
        let topStackSpacing: CGFloat = isPortrait ? Constants.topStackSpacingPortrait : Constants.topStackSpacingLandscape
        
        if !Constants.isIpad {
            fillView.isHidden = !isPortrait
        }
        
        mainStackView.spacing = stackSpacing
        topStack.spacing = topStackSpacing
        
        updateStackViewElementSize(stackView: fromStack, elementHeight: elementHeight)
        updateStackViewElementSize(stackView: toStack, elementHeight: elementHeight)
        
        topConstraint?.constant = padding
        botConstraint?.constant = -padding
        trailConstraint?.constant = -padding
        leadConstraint?.constant = padding
        
        layoutIfNeeded()
    }
    
    func updateStackViewElementSize(stackView: UIStackView, elementHeight: CGFloat) {
        for view in stackView.arrangedSubviews {
            if let imageView = view as? UIImageView {
                imageView.heightAnchor.constraint(equalToConstant: elementHeight).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: elementHeight).isActive = true
            }
            
            if let label = view as? UILabel {
                label.font = label.font.withSize(elementHeight / 2)
            } 
        }
    }
}

// MARK: - Private Methods
private extension CurrencyConverterContentView {
    
    func setupView() {
        backgroundColor = .systemBackground
        addSubview(mainStackView)
    }
    
    func createFlagImageView() -> UIImageView {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.elementHeightPortrait).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.elementHeightPortrait).isActive = true
        return imageView
    }
    
    func createDropdownButton(action: UIAction) -> UIButton {
        let button = UIButton(type: .system).prepareForAutoLayout()
        button.setImage(Assets.Images.chevronDown.image(), for: .normal)
        button.tintColor = .label
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }
    
    func createTitleLabel(text: String) -> UILabel {
        let label = UILabel().prepareForAutoLayout()
        label.textColor = .label.withAlphaComponent(0.5)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }
    
    func createCurrencyLabel() -> UILabel {
        let label = UILabel().prepareForAutoLayout()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }
    
    func createRateLabel() -> UILabel {
        let label = UILabel().prepareForAutoLayout()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }
    
    func createCurrencyBlock(
        flagImage: UIImageView,
        title: UILabel,
        currency: UILabel,
        dropdownbutton: UIButton,
        amount: UIView,
        rate: UILabel
    ) -> UIStackView {
        
        let currencyStack = UIStackView(arrangedSubviews: [
            currency,
            dropdownbutton
        ]
        ).prepareForAutoLayout()
        currencyStack.axis = .horizontal
        currencyStack.spacing = 10
        
        let currencyVerticalStack = UIStackView(arrangedSubviews: [
            title,
            currencyStack
        ]
        ).prepareForAutoLayout()
        currencyVerticalStack.axis = .vertical
        currencyVerticalStack.spacing = 4
        
        let mainCurrencyStack = UIStackView(arrangedSubviews: [
            flagImage,
            currencyVerticalStack
        ]).prepareForAutoLayout()
        mainCurrencyStack.axis = .horizontal
        mainCurrencyStack.spacing = 20
        
        let amountStack = UIStackView(arrangedSubviews: [
            amount,
            rate
        ]).prepareForAutoLayout()
        amountStack.axis = .vertical
        amountStack.spacing = 4
        amount.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let spacerView: UIView = {
            let view = UIView().prepareForAutoLayout()
            view.backgroundColor = .clear
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return view
        }()
        
        let stack = UIStackView(arrangedSubviews: [
            mainCurrencyStack,
            spacerView,
            amountStack
        ]).prepareForAutoLayout()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 15
        return stack
    }
    
    func createRateText(fromCurrencySymbol: String, toCurrencySymbol: String, rate: Double?) -> String {
        let rate: Double = rate ?? 0
        let rateStr = rate.convertToRateFormat()
        return  "1 \(fromCurrencySymbol) = \(rateStr) \(toCurrencySymbol)"
    }
    
    func formatAmountString(_ amount: String) -> String {
        
        var cleanedAmount = amount.replacingOccurrences(of: " ", with: "")
        
        var decimalPart = ""
        if let dotIndex = cleanedAmount.firstIndex(of: ".") {
            decimalPart = String(cleanedAmount.suffix(from: dotIndex))
            cleanedAmount = String(cleanedAmount.prefix(upTo: dotIndex))
        }
        
        var formattedAmount = ""
        let characters = Array(cleanedAmount)
        for (index, char) in characters.reversed().enumerated() {
            if index != 0 && index % 3 == 0 {
                formattedAmount.append(" ")
            }
            formattedAmount.append(char)
        }
        
        formattedAmount = String(formattedAmount.reversed()) + decimalPart
        return formattedAmount
    }
    
    func createFromAmountText(currencySymbol: String, amount: String?) -> String {
        var newText: String = ""
        
        if let amountStr = amount {
            newText = formatAmountString(amountStr)
        }
        
        return "- \(currencySymbol)\(newText)"
    }
    
    func createToAmountText(currencySymbol: String, amount: Double) -> String {
        return "+ \(currencySymbol)\(amount.currencyFormat())"
    }
    
    func extractAmountValue(from text: String?, currencySymbol: String) -> String? {
        guard let text = text.isNilOrEmptyValue else {
            return nil
        }
        
        let numberString = text.replacingOccurrences(of: "- \(currencySymbol)", with: "")
        
        return numberString
    }
    
}

// MARK: - Activity Indicator
private extension CurrencyConverterContentView {
    
    func startLoading() {
        activityIndicatorView.startAnimating()
        switchCurrenciesButton.isEnabled = false
        switchCurrenciesButton.setImage(nil, for: .normal)
    }
    
    func stopLoading() {
        activityIndicatorView.stopAnimating()
        switchCurrenciesButton.isEnabled = true
        switchCurrenciesButton.setImage(
            Assets.Images.arrowUpArrowDown.image(),
            for: .normal
        )
    }
    
}

// MARK: - Actions
private extension CurrencyConverterContentView {
    
    func didTapFromCurrency() {
        delegate?.didTapSelectCurrency(type: .from)
    }
    
    func didTapToCurrency() {
        delegate?.didTapSelectCurrency(type: .to)
    }
    
    func didTapSwitchCurrencies() {
        delegate?.didTapSwitchCurrencies()
    }
    
    func didChangeAmount() {
        delegate?.didEnterAmount(
            extractAmountValue(
                from: fromAmountTextField.text,
                currencySymbol: fromCurrencySymbol ?? ""
            )
        )
    }
}

// MARK: - Keypad Delegate
extension CurrencyConverterContentView: CurrencyConverterKeypadViewDelegate {
    
    func changeCurrencySymbol(from previousSymbol: String?, to symbol: String?, text: String?) -> String? {
        guard let previousSymbol = previousSymbol else {
            return text
        }
        
        guard let _text = text.isNilOrEmptyValue else {
            return text
        }
        return _text.replacingOccurrences(of: previousSymbol, with: symbol ?? "")
    }
    
    func didTapKey(_ key: String) {
        let currencySymbol: String = fromCurrencySymbol ?? ""
        let defaultTxt: String = "- \(currencySymbol)"
        let zeroTxt: String = defaultTxt+"0"
        var newText: String = ""
        
        switch key {
        case "⌫":
            if let text = fromAmountTextField.text.isNilOrEmptyValue {
                if text == defaultTxt {
                    delegate?.didEnterAmount(nil)
                    return
                }
                
                newText = String(text.dropLast())
            }else {
                delegate?.didEnterAmount(nil)
                return
            }
            
        case Config.decimalSeparator:
            if let text = fromAmountTextField.text.isNilOrEmptyValue {
                if text.contains(Config.decimalSeparator) {
                    newText = text
                }else {
                    
                    if text == defaultTxt {
                        delegate?.didEnterAmount("0" + Config.decimalSeparator)
                        return
                    }else {
                        newText = text + key
                    }
                }
            }else {
                delegate?.didEnterAmount("0" + Config.decimalSeparator)
                return
            }
        default:
            if let text = fromAmountTextField.text.isNilOrEmptyValue {
                if text.contains(Config.decimalSeparator) {
                    let parts = text.split(separator: Config.decimalSeparator.first!)
                    if parts.count == 2 && parts[1].count >= 2 {
                        newText = text
                    } else {
                        newText = text + key
                    }
                } else {
                    if text == zeroTxt {
                        newText = text + Config.decimalSeparator + key
                    }else {
                        newText = text + key
                    }
                }
            }else {
                delegate?.didEnterAmount(key + key == "0" ? Config.decimalSeparator : "")
                return
            }
        }
        
        delegate?.didEnterAmount(
            extractAmountValue(
                from: newText,
                currencySymbol: currencySymbol
            )
        )
    }
}


@available(iOS 17, *)
#Preview {
    let vc = CurrencyConverterViewController()
    return vc
}
