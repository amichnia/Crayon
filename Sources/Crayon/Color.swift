//
//  Color.swift
//  Crayon
//
//  Created by Quentin MED on 2018/10/19.
//

import Foundation
@_exported import Rainbow

public protocol TerminalColor {
    
    var fgCode: String { get }
    var bgCode: String { get }
}

extension TerminalColor {

    var fgCloseCode: String {
        return "\u{001B}[39m"
    }

    var bgCloseCode: String {
        return "\u{001B}[49m"
    }
}

public enum ANSI16Color: UInt8 {
    case black = 30
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white

    case blackBright = 90
    case redBright
    case greenBright
    case yellowBright
    case blueBright
    case magentaBright
    case cyanBright
    case whiteBright
}

extension ANSI16Color: TerminalColor {
    
    private func code(offset: UInt8) -> String {
        return "\u{001B}[\(rawValue + offset)m"
    }
    
    public var fgCode: String {
        return code(offset: 0)
    }
    
    public var bgCode: String {
        return code(offset: 10)
    }
}

public typealias RainbowColor = Rainbow.Color

extension RainbowColor: TerminalColor {
    
    private func code(offset: UInt8) -> String {
        switch TerminalColorSupportLevel.current {
        case .ansi16m:
            let rgba = self.rgba
            return "\u{001B}[\(38 + offset);2;\(rgba.red);\(rgba.green);\(rgba.blue)m"
        case .ansi256:
            return "\u{001B}[\(38 + offset);5;\(ansi256)m"
        case .ansi16:
            return "\u{001B}[\(UInt8(ansi16) + offset)m"
        default:    return ""
        }
    }

    public var fgCode: String {
        return code(offset: 0)
    }

    public var bgCode: String {
        return code(offset: 10)
    }
}
