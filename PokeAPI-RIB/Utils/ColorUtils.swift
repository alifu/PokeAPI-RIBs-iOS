//
//  ColorUtils.swift
//  PokeAPI-RIB
//
//  Created by Alif on 03/09/25.
//

import SwiftUI

enum ColorUtils {
    static let primary = UIColor(hex: "#DC0A2D")
    static let bug = UIColor(hex: "#A7B723")
    static let dark = UIColor(hex: "#75574C")
    static let dragon = UIColor(hex: "#7037FF")
    static let electric = UIColor(hex: "#F9CF30")
    static let fairy = UIColor(hex: "#E69EAC")
    static let fighting = UIColor(hex: "#C12239")
    static let fire = UIColor(hex: "#F57D31")
    static let flying = UIColor(hex: "#A891EC")
    static let ghost = UIColor(hex: "#70559B")
    static let grass = UIColor(hex: "#74CB48")
    static let ground = UIColor(hex: "#DEC16B")
    static let ice = UIColor(hex: "#9AD6DF")
    static let poison = UIColor(hex: "#A43E9E")
    static let psychic = UIColor(hex: "#FB5584")
    static let rock = UIColor(hex: "#B69E31")
    static let steel = UIColor(hex: "#B7B9D0")
    static let water = UIColor(hex: "#6493EB")
    static let grayscaleDark = UIColor(hex: "#212121")
    static let grayscaleMedium = UIColor(hex: "#666666")
    static let grayscaleLight = UIColor(hex: "#E0E0E0")
    static let background = UIColor(hex: "#EFEFEF")
    static let white = UIColor(hex: "#FFFFFF")
    static let wireframe = UIColor(hex: "#B8B8B8")
}

enum ColorType: String {
    case bug
    case dark
    case dragon
    case electric
    case fairy
    case fighting
    case fire
    case flying
    case ghost
    case grass
    case ground
    case ice
    case poison
    case psychic
    case rock
    case steel
    case water
    case none
    
    var color: UIColor {
        switch self {
        case .bug:
            return ColorUtils.bug
        case .dark:
            return ColorUtils.dark
        case .dragon:
            return ColorUtils.dragon
        case .electric:
            return ColorUtils.electric
        case .fairy:
            return ColorUtils.fairy
        case .fighting:
            return ColorUtils.fighting
        case .fire:
            return ColorUtils.fire
        case .flying:
            return ColorUtils.flying
        case .ghost:
            return ColorUtils.ghost
        case .grass:
            return ColorUtils.grass
        case .ground:
            return ColorUtils.ground
        case .ice:
            return ColorUtils.ice
        case .poison:
            return ColorUtils.poison
        case .psychic:
            return ColorUtils.psychic
        case .rock:
            return ColorUtils.rock
        case .steel:
            return ColorUtils.steel
        case .water:
            return ColorUtils.water
        case .none:
            return ColorUtils.wireframe
        }
    }
}

func colorStringToType(_ colorString: String?) -> UIColor {
    guard let colorString else {
        return ColorType.none.color
    }
    return ColorType(rawValue: colorString.lowercased())?.color ?? ColorType.none.color
}
