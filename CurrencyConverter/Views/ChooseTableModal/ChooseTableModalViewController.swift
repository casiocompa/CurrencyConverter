//
//  ChooseTableModalViewController.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit

final class ChooseTableModalViewController: ViewController {
    
    //MARK: - ContentView
    var contentView: ChooseTableModalContentView? {
        return view as? ChooseTableModalContentView
    }
    
    //MARK: - Private properties
    private var dataSource: [ChooseModalModel] = []
    private var selectCompletion: (Int) -> Void = { _ in }
    private var titleLabelText: String?
    
    //MARK: - Inits
    init(
        title: String?,
        list: [ChooseModalModel],
        selectCompletion: @escaping (Int) -> Void
    ) {
        self.dataSource = list
        self.selectCompletion = selectCompletion
        self.titleLabelText = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func loadView() {
        let contentView = ChooseTableModalContentView(
            delegate: self,
            isPortraitOrientation: superHeight > superWidth,
            title: titleLabelText,
            list: dataSource,
            isNeedCloseSwipe: true
        )
        self.view = contentView
        self.contentView?.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { [weak self] (_) in
            guard let self else {
                return
            }
            self.contentView?.updateaLayoutForOrientation(isPortrait: self.superHeight > self.superWidth)
        }
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private methods
private extension ChooseTableModalViewController {
    func setupView() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.contentView?.alpha = 1.0
            }, completion: { [weak self] _ in
                self?.contentView?.start()
            }
        )
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
        self.contentView?.updateaLayoutForOrientation(isPortrait: self.superHeight > self.superWidth)
    }
    
    func selectedAction(_ itemIndex: Int) {
        dismiss(completion: {
            self.selectCompletion(itemIndex)
        })
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.view.backgroundColor = .systemBackground.withAlphaComponent(0.0)
                self.contentView?.alpha = 0.0
            }, completion: { _ in
                self.dismiss(animated: true, completion: completion)
            }
        )
    }
}

// MARK: - ContentViewDelegate
extension ChooseTableModalViewController: ChooseTableModalContentViewDelegate {
    func closeSwipeAction() {
        self.dismiss()
    }
    
    func didTapSelect(itemIndex: Int) {
        self.selectedAction(itemIndex)
    }
}

@available(iOS 17, *)
#Preview {
    let vc = ChooseTableModalViewController(
        title:  Localization.select_currency_title.description,
        list: [
            ChooseModalModel(iconName: Currency.USD.flagImageName, title: Currency.USD.shortName, subtitle: Currency.USD.description),
            ChooseModalModel(iconName: Currency.EUR.flagImageName, title: Currency.EUR.shortName, subtitle: Currency.EUR.description),
            ChooseModalModel(iconName: Currency.UAH.flagImageName, title: Currency.UAH.shortName, subtitle: Currency.UAH.description),
        ],
        selectCompletion: { _ in }
    )
    
    return vc
}
