//
//  UIViewControllerExtensions.swift
//  RandomStudy
//
//  Created by 이민재 on 5/12/24.
//

import Foundation
import UIKit

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
    
    func hideSpinner(_ completion: (() -> Void)?) {
        if let controller = SaveAlertHandle.get() {
            SaveAlertHandle.clear()
            controller.dismiss(animated: true, completion: completion)
        }
    }
}
