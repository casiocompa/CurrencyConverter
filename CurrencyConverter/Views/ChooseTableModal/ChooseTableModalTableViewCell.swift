//
//  ChooseTableModalTableViewCell.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//


import UIKit

final class ChooseTableModalTableViewCell: UITableViewCell {
    
    //MARK: - Private properties
    private var separatorIsEnabled: Bool = false {
        didSet {
            self.separator.isHidden = !separatorIsEnabled
        }
    }
    
    //MARK: - UI
    private lazy var baseView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 0
        view.addSubview(self.baseStack)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            baseStack.topAnchor.constraint(equalTo: view.topAnchor),
            baseStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }()
    
    private lazy var baseStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            UIView(),
            mainStack,
            separator
        ]).prepareForAutoLayout()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            separator.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
        ])
        return stack
    }()
    
    private lazy var separator: UIView = {
        let view = UIView().prepareForAutoLayout()
        view.backgroundColor = .label.withAlphaComponent(0.2)
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    private lazy var leftImage: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titlelabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var subtitlelabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var mainTextStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titlelabel,
            subtitlelabel,
        ]).prepareForAutoLayout()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 2
        NSLayoutConstraint.activate([
            titlelabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            titlelabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            subtitlelabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            subtitlelabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
        ])
        return stack
    }()
    
    /// mainBodyStack
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            leftImage,
            mainTextStack,
        ]).prepareForAutoLayout()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 20
        NSLayoutConstraint.activate([
            leftImage.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            leftImage.heightAnchor.constraint(equalToConstant: 40),
            leftImage.widthAnchor.constraint(equalToConstant: 40),
            mainTextStack.topAnchor.constraint(equalTo: stack.topAnchor),
            mainTextStack.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
        ])
        return stack
    }()
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.addSubview(self.baseView)
        
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            baseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - inits
    required override init(
        style: UITableViewCell.CellStyle = .default,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChooseTableModalTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        separatorIsEnabled = false
        leftImage.image = nil
        titlelabel.text = ""
        subtitlelabel.text = ""
    }
}

// MARK: - ConfigurableCell
extension ChooseTableModalTableViewCell: ConfigurableCell {
    
    func configure(with model: ChooseModalModel, isSelected: Bool) {
        self.separatorIsEnabled = isSelected
        if let iconName = model.iconName {
            Task {
                self.leftImage.image = await UIImage(named: iconName)?.byPreparingForDisplay()
            }
        }
        
        self.titlelabel.text = model.title
        self.subtitlelabel.text = model.subtitle
    }
}
