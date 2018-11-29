//
//  ViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import AVFoundation

import RxSwift

// MARK: -
class ViewController: UIViewController {

    private(set) var disposeBag: DisposeBag = DisposeBag()

    private(set) var dimView: UIView?
    private(set) var alertView: AlertView?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
    }
}

// MARK: - AlertView Present / Dismiss
extension ViewController {
    func present(alertView: AlertView, setup: (AlertView) -> Void) {
        guard self.alertView == nil, dimView == nil else { return }

        setup(alertView)

        DispatchQueue.main.async {
            self.dimView = UIView()
            self.dimView!.backgroundColor = .black
            self.dimView!.alpha = 0.5
            self.dimView!.isExclusiveTouch = true
            self.view.addSubview(self.dimView!)
            self.dimView!.translatesAutoresizingMaskIntoConstraints = false
            self.dimView!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.dimView!.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
            self.dimView!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            self.dimView!.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true

            let horizontalPadding: CGFloat = 20.0
            self.alertView = alertView
            self.view.addSubview(self.alertView!)
            self.alertView!.translatesAutoresizingMaskIntoConstraints = false
            self.alertView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.alertView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.alertView!.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                                  constant: horizontalPadding).isActive = true
            self.alertView!.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                                   constant: -(horizontalPadding)).isActive = true
            self.alertView!.heightAnchor.constraint(equalToConstant: self.alertView!.bounds.size.width).isActive = true
        }
    }

    func presentErrorAlert(message: String, buttonTitle: String) {
        present(alertView: AlertView(style: .alert), setup: {
            $0.accessibilityIdentifier = "ErrorAlertView"
            $0.message = message
            $0.confirmButton.setTitle(buttonTitle, for: .normal)
            $0.confirmButton.backgroundColor = .spartanRed
            $0.onConfirm {
                self.dismissAlertView()
            }
        })
    }

    func dismissAlertView() {
        guard alertView != nil, dimView != nil else { return }
        alertView?.removeFromSuperview()
        alertView = nil
        dimView?.removeFromSuperview()
        dimView = nil
    }
}

// MARK: - Voice Synthesizer
extension ViewController {
    @discardableResult
    func speak(_ message: String) -> AVSpeechSynthesizer {
        let speechSynthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-us")
        speechSynthesizer.speak(utterance)
        return speechSynthesizer
    }
}
