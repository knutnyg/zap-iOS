//
//  Zap
//
//  Created by Otto Suess on 23.04.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

extension UIStoryboard {
    static func instantiateSetupPinViewController(with delegate: SetupPinDelegate) -> SetupPinViewController {
        let setupPinViewController = Storyboard.numericKeyPad.instantiate(viewController: SetupPinViewController.self)
        setupPinViewController.delegate = delegate
        return setupPinViewController
    }
}

protocol SetupPinDelegate: class {
    func didSetupPin()
}

class SetupPinViewController: UIViewController {

    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var pinStackView: PinView!
    @IBOutlet private weak var keyPadView: KeyPadView!
    
    private let setupPinViewModel = SetupPinViewModel()
    fileprivate weak var delegate: SetupPinDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Style.label.apply(to: topLabel) {
            $0.textColor = .white
        }
        Style.button.apply(to: doneButton) {
            $0.tintColor = .white
        }
        
        setupKeyPad()
        
        [setupPinViewModel.state
            .observeNext { [weak self] in
                guard let state = $0 else { return }
                switch state {
                case .reset:
                    self?.keyPadView?.numberString = ""
                case .completed:
                    print("completed")
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self?.delegate?.didSetupPin()
                }
            },
         combineLatest(setupPinViewModel.pinCharacterCount, setupPinViewModel.pinAtiveCount)
            .observeNext { [weak self] in
                self?.updatePinView(characterCount: $0, activeCount: $1)
            },
         setupPinViewModel.doneButtonEnabled.bind(to: doneButton.reactive.isEnabled),
         setupPinViewModel.topLabelText.bind(to: topLabel.reactive.text)]
            .dispose(in: reactive.bag)
        
        doneButton.setTitle("Done", for: .normal)
        view.backgroundColor = UIColor.zap.darkBackground
    }
    
    private func setupKeyPad() {
        keyPadView.backgroundColor = UIColor.zap.darkBackground
        keyPadView.textColor = .white
        keyPadView.state = .setupPin
        
        keyPadView.handler = { [setupPinViewModel] in
            return setupPinViewModel.updateCurrentPin($0)
        }
    }
    
    @IBAction private func doneButtonTapped(_ sender: Any) {
        setupPinViewModel.doneButtonTapped()
        keyPadView.numberString = ""
    }
    
    private func updatePinView(characterCount: Int, activeCount: Int) {
//        UIView.animate(withDuration: 0.2) { [pinStackView] in
        pinStackView?.characterCount = characterCount
        pinStackView?.activeCount = activeCount
//        }
    }
}
