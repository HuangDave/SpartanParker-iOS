//
//  ViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: -
class ViewController: UIViewController {
    private(set) var dimView: UIView?
    private(set) var alertView: AlertView?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .white
        /*
        navigationController?.navigationBar.barTintColor = .spartanDarkBlue
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.tintColor = .white */
        navigationController?.navigationBar.tintColor = .black
    }

    // MARK: - AlertView Present / Dismiss

    func present(alertView: AlertView, setup: (AlertView) -> Void) {
        guard self.alertView == nil, dimView == nil else { return }

        setup(alertView)

        dimView = UIView()
        dimView!.backgroundColor = .black
        dimView!.alpha = 0.5
        dimView!.isExclusiveTouch = true
        view.addSubview(dimView!)
        dimView!.translatesAutoresizingMaskIntoConstraints = false
        dimView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dimView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        dimView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        dimView!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        let horizontalPadding: CGFloat = 20.0
        self.alertView = alertView
        view.addSubview(self.alertView!)
        self.alertView!.translatesAutoresizingMaskIntoConstraints = false
        self.alertView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.alertView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.alertView!.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                             constant: horizontalPadding).isActive = true
        self.alertView!.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                              constant: -(horizontalPadding)).isActive = true
        self.alertView!.heightAnchor.constraint(equalToConstant: self.alertView!.bounds.size.width).isActive = true
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
