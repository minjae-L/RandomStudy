//
//  StringExtensions.swift
//  RandomStudy
//
//  Created by 이민재 on 11/4/24.
//

import Foundation

extension String {
    // 비교문자의 크기와 같은 문자 경우의수를 모두 구하고 배열로 리턴
    static func separatingString(text: String, length: Int) -> [String] {
        var stringArray = Array(text).map{String($0)}
        var output = [String]()
        if length >= stringArray.count {
            return [text]
        }
        for i in 0...stringArray.count - length {
            var str = ""
            for j in 0..<length {
                str += stringArray[i+j]
            }
            output.append(str)
        }
        return output
    }
}
