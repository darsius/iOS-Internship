//
//  Model.swift
//  Prob
//
//  Created by Dar Dar on 04.10.2023.
//

import Foundation


struct Response: Codable {
    var results: [User]
}

struct User: Codable {
    let name: Name
    let location: Location
    let email: String
    let picture: Picture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let coordinates: Coordinates
    let timezone: Timezone
}

struct Street: Codable {
    let number: Int
    let name: String
}

struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

struct Timezone: Codable {
    let offset: String
    let description: String
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}
