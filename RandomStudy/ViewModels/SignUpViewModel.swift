//
//  SignUpViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 5/18/24.
//

import Foundation
import FirebaseAuth

class SignUpViewModel {
    // 회원가입
    func signUp(email: String, password: String, confirmPassword: String, completion: @escaping (Bool,String) -> Void) {
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

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("Create User Fail")
                guard let authError = error as? NSError else { return }
                completion(false, authError.localizedDescription)
                return
            }
            completion(true, "")
            print("Created User")
        }
    }
}
