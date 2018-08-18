//
//  Library
//
//  Created by Otto Suess on 17.08.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import UIKit

class ModalDetailViewController: ModalViewController, QRCodeScannerChildViewController {
    private let closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "icon_close", in: Bundle.library, compatibleWith: nil), for: .normal)
        closeButton.addTarget(self, action: #selector(dismissParent), for: .touchUpInside)
        return closeButton
    }()
    
    private let backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.layer.cornerRadius = 14
        backgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        backgroundView.backgroundColor = UIColor.Zap.seaBlue
        return backgroundView
    }()
    
    private let contentStackView: UIStackView = {
        let contentStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        contentStackView.axis = .vertical
        contentStackView.spacing = 14
        return contentStackView
    }()
    
    private let headerIconImageView: UIImageView = {
        let headerIconImageView = UIImageView(image: nil)
        headerIconImageView.alpha = 0
        return headerIconImageView
    }()
    
    weak var delegate: QRCodeScannerChildDelegate?
    
    var stackViewContent: [StackViewElement] = [] {
        didSet {
            contentStackView.set(elements: stackViewContent)
        }
    }
    
    private func setupLayout(for view: UIView) {
        view.addAutolayoutSubview(backgroundView)
        backgroundView.constrainEdges(to: view)

        backgroundView.addAutolayoutSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 45),
            closeButton.heightAnchor.constraint(equalToConstant: 45),
            closeButton.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        ])
        
        view.addAutolayoutSubview(headerIconImageView)
        NSLayoutConstraint.activate([
            headerIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerIconImageView.centerYAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        backgroundView.addAutolayoutSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: headerIconImageView.bottomAnchor, constant: 15),
            contentStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout(for: view)

        view.clipsToBounds = false
        
        headerIconImageView.image = UIImage(named: "icon_header_lightning", in: Bundle.library, compatibleWith: nil)
    }
    
    func updateHeight() {
        guard let height = contentHeight else { return }
        modalPresentationManager?.modalPresentationController?.contentHeight = height
    }
    
    @objc private func dismissParent() {
        guard let presentingViewController = presentingViewController else { return }
        
        // fixes the dismiss animation of two modals at once
        if let snapshotView = view.superview?.snapshotView(afterScreenUpdates: false) {
            snapshotView.frame.origin.y = presentingViewController.view.frame.height - snapshotView.frame.height
            presentingViewController.view.addSubview(snapshotView)
        }

        presentingViewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension ModalDetailViewController: ContentHeightProviding {
    var contentHeight: CGFloat? {
        let headerImageMargin = (headerIconImageView.image?.size.height ?? 0) / 2
        let topMargin: CGFloat = 15
        let bottomMargin: CGFloat = 34
        return stackViewContent.height(spacing: contentStackView.spacing) + headerImageMargin + topMargin + bottomMargin
    }
}

extension ModalDetailViewController: ModalTransitionAnimating {
    func animatePresentationTransition() {
        headerIconImageView.alpha = 1
    }
    
    func animateDismissalTransition() {
        headerIconImageView.alpha = 0
    }
}