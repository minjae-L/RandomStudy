//
//  DataMigrationViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 5/21/24.
//

import Foundation

class DataMigrationViewModel {
    // 데이터 마이그레이션 함수
    func dataMigration() {
        print("DataMigrationVM:: dataMigration:: Excuted")
        FirebaseManager.shared.dataMigration()
    }
}
