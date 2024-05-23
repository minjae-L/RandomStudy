//
//  LoginViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 5/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class LoginViewModel {
    // 로그인
    func login(email: String, password: String, completion: @escaping (Bool,String) -> Void) {
        if email.isEmpty || password.isEmpty {
            completion(false, "이메일 혹은 비밀번호를 입력해주세요.")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let authError = error as NSError
                if let ac = AuthErrorCode.Code(rawValue: authError.code) {
                    switch ac {
                    case .wrongPassword:
                        completion(false, "비밀번호가 일치하지 않습니다.")
                    case .invalidEmail:
                        completion(false, "이메일 형식이 올바르지 않습니다.")
                    case .userDisabled:
                        completion(false, "이 계정은 현재 사용중지 상태입니다.")
                    case .operationNotAllowed:
                        completion(false, "현재 이메일 로그인을 지원하지 않습니다.")
                    default:
                        completion(false, "로그인 실패\n이메일과 비밀번호를 확인해주세요.")
                    }
                }
            } else {
                completion(true, "")
            }
            
        }
    }
    func makeFirebaseDocument() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            if error != nil {
                print("LoginVM:: maekFirebaseDocument Error")
            }
            print("LoginVM:: snapshot: \(snapshot?.data())")
            if snapshot?.data() == nil {
                print("LoginVM:: firebase document is nil")
                do {
                    try db.collection("users").document(uid).setData(["uid": uid])
                    print("LoginVM:: make document success")
                } catch {
                    print("LoginVM:: make document Error")
                }
            }
            
        }
    }

}
