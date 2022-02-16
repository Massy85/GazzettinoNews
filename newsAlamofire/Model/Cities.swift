//
//  Cities.swift
//  newsAlamofire
//
//  Created by Massimiliano Bonafede on 16/02/22.
//  Copyright © 2022 Massimiliano Bonafede. All rights reserved.
//

import Foundation

enum Cities: String, CaseIterable {
    case emiratiArabi = "EMIRATI ARABI UNITI"
    case argentina = "ARGENTINA"
    case austria = "AUSTRIA"
    case australia = "AUSTRALIA"
    case belgio = "BELGIO"
    case bulgaria = "BULGARIA"
    case brasile = "BRASILE"
    case canada = "CANADA"
    case cina = "CINA"
    case cuba = "CUBA"
    case germania = "GERMANIA"
    case egitto = "EGITTO"
    case francia = "FRANCIA"
    case granBretagna = "GRAN BRETAGNA"
    case grecia = "GRECIA"
    case hongKong = "HONG KONG"
    case irlanda = "IRLANDA"
    case india = "INDIA"
    case italia = "ITALIA"
    case giappone = "GIAPPONE"
    case olanda = "OLANDA"
    case norvegia = "NORVEGIA"
    case nuovaZelanda = "NUOVA ZELANDA"
    case filippine = "FILIPPINE"
    case russia = "RUSSIA"
    case tailandia = "TAILANDIA"
    case statiUniti = "STATI UNITI D'AMERICA"
    case sudAfrica = "SUD AFRICA"
    
    var initial: String {
        switch self {
        case .emiratiArabi:
            return "ae"
        case .argentina:
            return "ar"
        case .austria:
            return "at"
        case .australia:
            return "au"
        case .belgio:
            return "be"
        case .bulgaria:
            return "bg"
        case .brasile:
            return "br"
        case .canada:
            return "ca"
        case .cina:
            return "cn"
        case .cuba:
            return "cu"
        case .germania:
            return "de"
        case .egitto:
            return "eg"
        case .francia:
            return "fr"
        case .granBretagna:
            return "gb"
        case .grecia:
            return "gr"
        case .hongKong:
            return "hk"
        case .irlanda:
            return "ie"
        case .india:
            return "in"
        case .italia:
            return "it"
        case .giappone:
            return "jp"
        case .olanda:
            return "nl"
        case .norvegia:
            return "no"
        case .nuovaZelanda:
            return "nz"
        case .filippine:
            return "ph"
        case .russia:
            return "ru"
        case .tailandia:
            return "th"
        case .statiUniti:
            return "us"
        case .sudAfrica:
            return "za"
        }
    }
}
