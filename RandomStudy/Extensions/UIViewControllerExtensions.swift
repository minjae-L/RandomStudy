//
//  UIViewControllerExtensions.swift
//  RandomStudy
//
//  Created by 이민재 on 5/12/24.
//

import Foundation
import UIKit

// AlertVC를 클래스로 관리 (로딩화면을 위해)
private class SaveAlertHandle {
    static var alertHandle: UIAlertController?
    
    class func set(_ handle: UIAlertController) {
        alertHandle = handle
    }
    class func clear() {
        alertHandle = nil
    }
    class func get() -> UIAlertController? {
        return alertHandle
    }
}

extension UIViewController {
//    MARK: AlertController Methods
    // 메세지와 확인버튼만 있는 alert 보여주기
    func showMessageAlert(_ message: String) {
        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인",
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
    // 로딩화면 보여주기
    func showSpinner(_ completion: (() -> Void)?) {
        let alertController = UIAlertController(title: nil,
                                                message: "잠시 기다려주세요...\n\n\n",
                                                preferredStyle: .alert)
        
        SaveAlertHandle.set(alertController)
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = UIColor(ciColor: .black)
        spinner.center = CGPoint(x: alertController.view.frame.midX,
                                 y: alertController.view.frame.midY)
        spinner.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin,
                                    .flexibleLeftMargin, .flexibleRightMargin]
        spinner.startAnimating()
        alertController.view.addSubview(spinner)
        present(alertController, animated: true, completion: completion)
        
    }
    // 재확인 alert 보여주기 (확인 버튼 클릭시 클로저 실행)
    func showReConfirmAlert(_ message: String,_ completion: @escaping ((Bool) -> Void)) {
        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "예",
                                     style: .default, handler: { _ in
            completion(true)
        })
        let cancelButton = UIAlertAction(title: "아니오",
                                         style: .default,
                                         handler: { _ in
            completion(false)
        })
        alertController.addAction(acceptButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    // 로딩화면 숨기기
    func hideSpinner(_ completion: (() -> Void)?) {
        if let controller = SaveAlertHandle.get() {
            SaveAlertHandle.clear()
            controller.dismiss(animated: true, completion: completion)
        }
    }
}
