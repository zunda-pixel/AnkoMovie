//
//  MyError.swift
//  iOSEngineerCodeCheck
//
//  Created by zunda on 2020/06/30.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

enum MyError: Error {
    case dataNil
    case badData
}

extension MyError:LocalizedError{
    var errorDescription:String?{
        switch self {
        case .dataNil:
            return "データがnilです"
        case .badData:
            return "データが悪いです"
        }
    }
}
