//
//  NetworkErrors.swift
//  UsersApp
//
//  Created by Dar Dar on 09.11.2023.
//

import Foundation


enum NetworkError: Error {
    case invalidUrl
    case invalidReponse
    case invalidData
    case invalidParameter
}
