//
//  LoginViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 5/18/24.
//

import Foundation

class LoginViewModel {
//  MARK: Method
    // 로그인
    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void ) {
        if email.isEmpty || password.isEmpty {
            completion(false, "이메일 혹은 비밀번호를 입력해주세요.")
            return
        }
        FirebaseManager.shared.login(email: email, password: password) { (result, message) -> Void in
            completion(result, message)
        }
    }
    // uid 문서 생성
    func makeFirebaseDocument() {
        FirebaseManager.shared.makeFirebaeDocument()
    }
    // 해당 계정의 데이터 불러오기
    func fetchData() {
        print("loginVM:: fetchData")
        FirebaseManager.shared.fetchData()
    }

}
