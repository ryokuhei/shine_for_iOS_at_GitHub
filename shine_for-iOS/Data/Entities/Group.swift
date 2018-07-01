//
//  Group.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/07/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation

enum Group {
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h
    case i
    case j
    case k
    case l
    case m
    case n
    case o
    case p
    case q
    case r
    case s
    case t
    case u
    case v
    case w
    case x
    case y
    case z
    case あ
    case か
    case さ
    case た
    case な
    case は
    case ま
    case や
    case ら
    case わ
    case none
    
    init() {
        self = .none
    }
    
    init(key: String) {

        let firstCharacter = String(key.lowercased().prefix(1))

        switch firstCharacter {
        case "a": self = .a
        case "b": self = .b
        case "c": self = .c
        case "d": self = .d
        case "e": self = .e
        case "f": self = .f
        case "g": self = .g
        case "h": self = .h
        case "i": self = .i
        case "j": self = .j
        case "k": self = .k
        case "l": self = .l
        case "m": self = .m
        case "n": self = .n
        case "o": self = .o
        case "p": self = .p
        case "q": self = .q
        case "r": self = .r
        case "s": self = .s
        case "t": self = .t
        case "u": self = .u
        case "v": self = .v
        case "w": self = .w
        case "x": self = .x
        case "y": self = .y
        case "z": self = .z
        case "あ": self = .あ
        case "か": self = .か
        case "さ": self = .さ
        case "た": self = .た
        case "な": self = .な
        case "は": self = .は
        case "ま": self = .ま
        case "や": self = .や
        case "ら": self = .ら
        case "わ": self = .わ
        default: self = .none
        }
    }
    
    func byKey() ->String {
        
        switch self {
            case .a: return "a"
            case .b: return "b"
            case .c: return "c"
            case .d: return "d"
            case .e: return "e"
            case .f: return "f"
            case .g: return "g"
            case .h: return "h"
            case .i: return "i"
            case .j: return "j"
            case .k: return "k"
            case .l: return "l"
            case .m: return "m"
            case .n: return "n"
            case .o: return "o"
            case .p: return "p"
            case .q: return "q"
            case .r: return "r"
            case .s: return "s"
            case .t: return "t"
            case .u: return "u"
            case .v: return "v"
            case .w: return "w"
            case .x: return "x"
            case .y: return "y"
            case .z: return "z"
            case .あ: return "あ"
            case .か: return "か"
            case .さ: return "さ"
            case .た: return "た"
            case .な: return "な"
            case .は: return "は"
            case .ま: return "ま"
            case .や: return "や"
            case .ら: return "ら"
            case .わ: return "わ"
            case .none: return "other"
        }
        
    }
    
}
