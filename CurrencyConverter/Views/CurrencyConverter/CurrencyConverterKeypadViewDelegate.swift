//
//  CurrencyConverterKeypadViewDelegate.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit

protocol CurrencyConverterKeypadViewDelegate: AnyObject {
    func didTapKey(_ key: String)
}

final class CurrencyConverterKeypadView: UIView {
    
    // MARK: - Constants & Defaults
    private enum Constants {
        static let buttonCornerRadius: CGFloat = 8
        static let stackSpacingPortrait: CGFloat = Constants.isIpad ? 30 : 16
        static let stackSpacingLandscape: CGFloat = Constants.isIpad ? 30 : 5
        static let buttonMinHeightPortrait: CGFloat = Constants.isIpad ? 80 : 60
        static let buttonMinHeightLandscape: CGFloat = Constants.isIpad ? 80 : 40
        
        private static var isIpad: Bool {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    
    // MARK: - Delegate
    private weak var delegate: CurrencyConverterKeypadViewDelegate?
    
    //MARK: - Property
    private var buttonConstraints: [UIView: NSLayoutConstraint] = [:]
    
    // MARK: - Keys
    private let keys: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [Config.decimalSeparator, "0", "⌫"]
    ]
    
    // MARK: - UI
    private lazy var stackView: UIStackView = {
        let stack = UIStackView().prepareForAutoLayout()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Initialization
    init(delegate: CurrencyConverterKeypadViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension CurrencyConverterKeypadView {
    
    func setupView() {
        for row in keys {
            let rowStack = UIStackView().prepareForAutoLayout()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.spacing = 0
            rowStack.distribution = .fillEqually
            for key in row {
                let button = createButton(with: key)
                rowStack.addArrangedSubview(button)
                let constraint = button.heightAnchor.constraint(equalToConstant: Constants.buttonMinHeightPortrait)
                constraint.priority = .init(999)
                constraint.isActive = true
                buttonConstraints[button] = constraint
            }
            stackView.addArrangedSubview(rowStack)
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func createButton(with title: String) -> UIButton {
        let button = UIButton(type: .system).prepareForAutoLayout()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.backgroundColor = UIColor(white: 0.2, alpha: 1)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        let actionbutton = UIAction { [weak self] _ in
            self?.didTapButton(key: title)
        }
        button.addAction(actionbutton, for: .primaryActionTriggered)
        return button
    }
    
    func didTapButton(key: String) {
        delegate?.didTapKey(key)
    }
    
    func adjustLayoutForOrientation(isPortrait: Bool) {
        
        let stackSpacing = isPortrait ? Constants.stackSpacingPortrait : Constants.stackSpacingLandscape
        let buttonHeight = isPortrait ? Constants.buttonMinHeightPortrait : Constants.buttonMinHeightLandscape
        
        for rowStack in stackView.arrangedSubviews {
            if let stack = rowStack as? UIStackView {
                stack.spacing = stackSpacing
                for button in stack.arrangedSubviews {
                    if let _button = button as? UIButton {
                        buttonConstraints[_button]?.constant = buttonHeight
                    }
                }
            }
        }
        
        stackView.spacing = stackSpacing
        layoutIfNeeded()
    }
}

// MARK: - Methods
extension CurrencyConverterKeypadView {

    func updateaLayoutForOrientation(isPortrait: Bool) {
        adjustLayoutForOrientation(isPortrait: isPortrait)
    }
}
