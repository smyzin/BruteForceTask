//
//  PasswordController.swift
//  Pr2503
//
//  Created by Sergey Myzin on 30.01.2022.
//

import UIKit

// All functions which control brute forcing and generating password

public func generatePassword(length: Int = 3) -> String {
    let characters = String().letters + String().printable
    var s = ""
    for _ in 0 ..< length {
        s.append(characters.randomElement()!)
    }
    return s
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
    : Character("")
}

public func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string
    
    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
        
        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    
    return str
}
