//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 01.02.2025.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    var superHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    var superWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    //MARK: - UI
    private lazy var networkErrorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        return view
    }()
    
    private var networkErrorLabel: UILabel {
        return networkErrorView.subviews.compactMap { $0 as? UILabel }.first!
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworkErrorView()
    }
}

// MARK: - Private methods
private extension ViewController {
    
    func setupNetworkErrorView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.addSubview(networkErrorView)
        NSLayoutConstraint.activate([
            networkErrorView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            networkErrorView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            networkErrorView.topAnchor.constraint(equalTo: window.topAnchor),
            networkErrorView.heightAnchor.constraint(equalToConstant: 50 + window.safeAreaInsets.top)
        ])
        networkErrorView.alpha = 0.0
        networkErrorView.isHidden = true
    }
}

// MARK: - Methods
extension ViewController {
    
    func showNetworkError(message: String? = nil, backgroundColor: UIColor? = nil) {
        networkErrorLabel.text = message ?? Localization.error_network_unreachable_title.description
        networkErrorView.backgroundColor = backgroundColor ?? .red
        
        UIView.animate(withDuration: 0.3, animations: {
            self.networkErrorView.alpha = 1.0
        }) { _ in
            self.networkErrorView.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 3.0, animations: {
                self.networkErrorView.alpha = 0.0
            }) { _ in
                self.networkErrorView.isHidden = true
            }
        }
    }
    
    func showError(title: String, description: String) {
        
        let alertController = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        )
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present( alertController,
                animated: true,
                completion: nil
            )
        }
    }
    
    func didReceiveError(_ failure: Swift.Error?) {
        guard let failure else {
            return
        }
        switch failure as? ApplicationError {
        case .decodingFailure:
            showError(
                title: Localization.error_decoding_failure_title.description,
                description: Localization.error_decoding_failure_description.description
            )
        case .networkUnreachable:
            showNetworkError()
        case let .external(code, message, title):
            var titleTxt: String = Localization.error_external_title.description
            if let title {
                titleTxt = "\(title)"
            }
            
            if let code {
                titleTxt += " (\(code))"
            }
            
            showError(
                title: titleTxt,
                description: message ?? Localization.error_external_description.description
            )
        case .unknown:
            showError(
                title: Localization.error_unknown_title.description ,
                description: Localization.error_unknown_description.description
            )
        case .none:
            return
        }
    }
}

@available(iOS 17, *)
#Preview {
    let vc = CurrencyConverterViewController()
    return vc
}
