//
//  ChooseTableModalContentViewDelegate.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit

protocol ChooseTableModalContentViewDelegate: AnyObject {
    func didTapSelect(itemIndex: Int)
    func closeSwipeAction()
}

final class ChooseTableModalContentView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let stackSpacing: CGFloat = 0
        static let rowHeight: CGFloat = 70
        static let cornerRadius: CGFloat = 16
        static let topPadding: CGFloat = 20
        
        static let maxTableHeightPortrait: CGFloat = Constants.isIpad ? 600 : 500
        static let maxTableHeightLandscape: CGFloat = Constants.isIpad ? 600 : 200
        static let maxModalHeightPortrait: CGFloat = Constants.isIpad ? 650: 550
        static let maxModalHeightLandscape: CGFloat = Constants.isIpad ? 650 : 300
        static let maxModalHeightExtra: CGFloat = 70
        static let modalViewStartBottomConstraint: CGFloat = Constants.isIpad ? 650 : 550
        
        private static var isIpad: Bool {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    
    // MARK: - Delegate
    private weak var delegate: ChooseTableModalContentViewDelegate?
    
    //MARK: - Private roperties
    private let dataSource: [ChooseModalModel]
    private let titleLabelText: String?
    private let isNeedCloseSwipe: Bool
    
    private var modalBottomConstraint: NSLayoutConstraint?
    private var modalHeightConstraint: NSLayoutConstraint?
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var viewForCloseSwipeBottomConstraint: NSLayoutConstraint?

    // MARK: - UI
    private lazy var modalView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = Constants.cornerRadius
        layer.maskedCorners = [
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        view.addSubview(contentStackView)
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        view.alpha = 0
        return view
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.layer.cornerRadius = 2.5
        view.backgroundColor = .label.withAlphaComponent(0.15)
        view.heightAnchor.constraint(equalToConstant: 4.5).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    private lazy var viewForCloseSwipe: UIView = {
        let view = UIView().prepareForAutoLayout()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        view.backgroundColor = .clear
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        ).prepareForAutoLayout()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .label
        label.text = titleLabelText
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                tableView,
            ]
        ).prepareForAutoLayout()
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        delegate: ChooseTableModalContentViewDelegate?,
        isPortraitOrientation: Bool,
        title: String?,
        list: [ChooseModalModel],
        isNeedCloseSwipe: Bool = true
    ) {
        self.delegate = delegate
        self.titleLabelText = title
        self.dataSource = list
        self.isNeedCloseSwipe = isNeedCloseSwipe
        
        super.init(frame: .zero)
        setupView()
        setupConstraints(isPortrait: isPortraitOrientation)
    }
}

// MARK: - Private Methods
private extension ChooseTableModalContentView {
    
    func setupView() {
        backgroundColor = .black.withAlphaComponent(0)
        
        if isNeedCloseSwipe {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(close))
            swipe.direction = .down
            isUserInteractionEnabled = true
            addGestureRecognizer(swipe)
            addSubview(viewForCloseSwipe)
        }
        
        addSubview(modalView)
        tableView.reloadData()
    }
    
    @objc
    func close() {
        delegate?.closeSwipeAction()
    }
    
    func setupConstraints(isPortrait: Bool) {
        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: trailingAnchor),
            modalView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.modalViewStartBottomConstraint),//
            
            viewForCloseSwipe.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewForCloseSwipe.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewForCloseSwipe.topAnchor.constraint(equalTo: topAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: modalView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: modalView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: modalView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: modalView.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let tableContentHeight: CGFloat = CGFloat(dataSource.count) * Constants.rowHeight
        let maxTableHeight: CGFloat = isPortrait ? Constants.maxTableHeightPortrait : Constants.maxTableHeightLandscape
        
        let tableHeight = min(tableContentHeight, maxTableHeight)
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableHeight)
        tableViewHeightConstraint?.priority = .init(999)
        tableViewHeightConstraint?.isActive = true
        tableView.isScrollEnabled = tableContentHeight > maxTableHeight
        
        let maxModalHeight: CGFloat = isPortrait ? Constants.maxModalHeightPortrait : Constants.maxModalHeightLandscape
        modalHeightConstraint = modalView.heightAnchor.constraint(equalToConstant: maxModalHeight)
        modalHeightConstraint?.priority = .init(999)
        modalHeightConstraint?.isActive = true
        
        viewForCloseSwipeBottomConstraint = viewForCloseSwipe.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -maxModalHeight)
        viewForCloseSwipeBottomConstraint?.priority = .init(999)
        viewForCloseSwipeBottomConstraint?.isActive = true
        
        let contentHeight = contentStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + Constants.maxModalHeightExtra

        
        let modalHeight = min(contentHeight, maxModalHeight + Constants.maxModalHeightExtra)
        modalHeightConstraint?.constant = modalHeight
        viewForCloseSwipeBottomConstraint?.constant = -modalHeight
        
    }
    
    func startPosition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.backgroundColor = .black.withAlphaComponent(0.5)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        guard let self else {
                            return
                        }
                        self.modalView.transform = CGAffineTransform(translationX: 1, y: -Constants.modalViewStartBottomConstraint)
                        self.modalView.alpha = 1
                    }
                    
                }
            )
        }
    }
    
    func animationForAdjustLayoutForOrientation(isPortrait: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else {
                return
            }
            self.adjustLayoutForOrientation(isPortrait: isPortrait)
        }
    }
       
    func adjustLayoutForOrientation(isPortrait: Bool) {
 
        let tableContentHeight: CGFloat = CGFloat(dataSource.count) * Constants.rowHeight
        let maxTableHeight: CGFloat = isPortrait ? Constants.maxTableHeightPortrait : Constants.maxTableHeightLandscape
        
        let tableHeight = min(tableContentHeight, maxTableHeight)
        tableViewHeightConstraint?.constant = tableHeight
        tableView.isScrollEnabled = tableContentHeight > maxTableHeight
        
        layoutIfNeeded()
        
        let contentHeight = contentStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + Constants.maxModalHeightExtra
        
        let maxModalHeight: CGFloat = isPortrait ? Constants.maxModalHeightPortrait : Constants.maxModalHeightLandscape
        let modalHeight = min(contentHeight, maxModalHeight + Constants.maxModalHeightExtra)
        
        modalHeightConstraint?.constant = modalHeight
        viewForCloseSwipeBottomConstraint?.constant = -modalHeight

        layoutIfNeeded()
    }
}

// MARK: - Methods
extension ChooseTableModalContentView {
    
    func start() {
        startPosition()
    }
    
    func updateaLayoutForOrientation(isPortrait: Bool) {
        animationForAdjustLayoutForOrientation(isPortrait: isPortrait)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChooseTableModalContentView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell - \(indexPath.description)"
        
        let dataCell = dataSource[indexPath.row]
        let cell = ChooseTableModalTableViewCell(style: .default, reuseIdentifier: identifier)
        
        let isSingleCell = dataSource.count == 1
        let separatorIsEnabled: Bool = isSingleCell || (indexPath.row < dataSource.count - 1)
        
        cell.configure(with: dataCell, isSelected: separatorIsEnabled)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapSelect(itemIndex: indexPath.row)
    }
}

@available(iOS 17, *)
#Preview {
    let vc = ChooseTableModalViewController(
        title: Localization.select_currency_title.description ,
        list: [
            ChooseModalModel(iconName: Currency.USD.flagImageName, title: Currency.USD.shortName, subtitle: Currency.USD.description),
            ChooseModalModel(iconName: Currency.EUR.flagImageName, title: Currency.EUR.shortName, subtitle: Currency.EUR.description),
            ChooseModalModel(iconName: Currency.UAH.flagImageName, title: Currency.UAH.shortName, subtitle: Currency.UAH.description),
            ChooseModalModel(iconName: Currency.PLN.flagImageName, title: Currency.PLN.shortName, subtitle: Currency.PLN.description),
            ChooseModalModel(iconName: Currency.EUR.flagImageName, title: Currency.EUR.shortName, subtitle: Currency.EUR.description),
            ChooseModalModel(iconName: Currency.USD.flagImageName, title: Currency.USD.shortName, subtitle: Currency.USD.description),
            ChooseModalModel(iconName: Currency.EUR.flagImageName, title: Currency.EUR.shortName, subtitle: Currency.EUR.description),
            ChooseModalModel(iconName: Currency.UAH.flagImageName, title: Currency.UAH.shortName, subtitle: Currency.UAH.description),
            ChooseModalModel(iconName: Currency.PLN.flagImageName, title: Currency.PLN.shortName, subtitle: Currency.PLN.description),
            ChooseModalModel(iconName: Currency.EUR.flagImageName, title: Currency.EUR.shortName, subtitle: Currency.EUR.description),
            ChooseModalModel(iconName: Currency.USD.flagImageName, title: Currency.USD.shortName, subtitle: Currency.USD.description),
            ChooseModalModel(iconName: Currency.EUR.flagImageName, title: Currency.EUR.shortName, subtitle: Currency.EUR.description),
            ChooseModalModel(iconName: Currency.UAH.flagImageName, title: Currency.UAH.shortName, subtitle: Currency.UAH.description),
            ChooseModalModel(iconName: Currency.PLN.flagImageName, title: Currency.PLN.shortName, subtitle: Currency.PLN.description),
            ChooseModalModel(iconName: Currency.EUR.flagImageName, title: Currency.EUR.shortName, subtitle: Currency.EUR.description),
        ],
        selectCompletion: { _ in }
    )
    
    return vc
}
