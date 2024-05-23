//
//  DataMigrationViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 5/21/24.
//

import Foundation

class DataMigrationViewModel {
    func dataMigration() {
        print("DataMigrationVM:: dataMigration:: Excuted")
        Firebase.shared.dataMigration()
    }
}
