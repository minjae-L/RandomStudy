//
//  SignUpViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 5/18/24.
//

import Foundation

class SignUpViewModel {
    // 회원가입
    func signUp(email: String, password: String, confirmPassword: String, completion: @escaping (Bool, String) -> Void) {
        if email.isEmpty {
            completion(false, "이메일을 입력해주세요.")
            return
        }
        if password.isEmpty || confirmPassword.isEmpty {
            completion(false, "비밀번호를 입력해주세요.")
            return
        }
        if password != confirmPassword {
            completion(false, "비밀번호가 일치하지 않습니다.")
            return
        }
        FirebaseManager.shared.signUp(email: email, password: password) { (result, message) -> Void in
            completion(result, message)
        }
    }
}
