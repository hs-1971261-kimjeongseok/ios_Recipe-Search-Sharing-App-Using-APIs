//
//  Recipe.swift
//  TermProject-1971261-kimjeongseok
//
//  Created by kjs on 2024/06/13.
//


import Foundation

struct RecipeResponse: Codable {
    let COOKRCP01: RecipeData
}

struct RecipeData: Codable {
    let total_count: String
    let row: [Recipe]
}

class Recipe: Codable {
    var RCP_SEQ: String
    var RCP_NM: String
    var RCP_WAY2: String
    var RCP_PAT2: String
    var INFO_WGT: String?
    var INFO_ENG: String?
    var INFO_CAR: String?
    var INFO_PRO: String?
    var INFO_FAT: String?
    var INFO_NA: String?
    var HASH_TAG: String?
    var ATT_FILE_NO_MAIN: String?
    var ATT_FILE_NO_MK: String?
    var RCP_PARTS_DTLS: String
    var MANUAL01: String?
    var MANUAL_IMG01: String?
    var MANUAL02: String?
    var MANUAL_IMG02: String?
    var MANUAL03: String?
    var MANUAL_IMG03: String?
    var MANUAL04: String?
    var MANUAL_IMG04: String?
    var MANUAL05: String?
    var MANUAL_IMG05: String?
    var MANUAL06: String?
    var MANUAL_IMG06: String?
    var MANUAL07: String?
    var MANUAL_IMG07: String?
    var MANUAL08: String?
    var MANUAL_IMG08: String?
    var MANUAL09: String?
    var MANUAL_IMG09: String?
    var MANUAL10: String?
    var MANUAL_IMG10: String?
    var MANUAL11: String?
    var MANUAL_IMG11: String?
    var MANUAL12: String?
    var MANUAL_IMG12: String?
    var MANUAL13: String?
    var MANUAL_IMG13: String?
    var MANUAL14: String?
    var MANUAL_IMG14: String?
    var MANUAL15: String?
    var MANUAL_IMG15: String?
    var MANUAL16: String?
    var MANUAL_IMG16: String?
    var MANUAL17: String?
    var MANUAL_IMG17: String?
    var MANUAL18: String?
    var MANUAL_IMG18: String?
    var MANUAL19: String?
    var MANUAL_IMG19: String?
    var MANUAL20: String?
    var MANUAL_IMG20: String?
    var RCP_NA_TIP: String?

    init?(document: [String: Any]) {
        guard let RCP_SEQ = document["RCP_SEQ"] as? String,
              let RCP_NM = document["RCP_NM"] as? String,
              let RCP_WAY2 = document["RCP_WAY2"] as? String,
              let RCP_PAT2 = document["RCP_PAT2"] as? String,
              let RCP_PARTS_DTLS = document["RCP_PARTS_DTLS"] as? String else { return nil }

        self.RCP_SEQ = RCP_SEQ
        self.RCP_NM = RCP_NM
        self.RCP_WAY2 = RCP_WAY2
        self.RCP_PAT2 = RCP_PAT2
        self.INFO_WGT = document["INFO_WGT"] as? String
        self.INFO_ENG = document["INFO_ENG"] as? String
        self.INFO_CAR = document["INFO_CAR"] as? String
        self.INFO_PRO = document["INFO_PRO"] as? String
        self.INFO_FAT = document["INFO_FAT"] as? String
        self.INFO_NA = document["INFO_NA"] as? String
        self.HASH_TAG = document["HASH_TAG"] as? String
        self.ATT_FILE_NO_MAIN = document["ATT_FILE_NO_MAIN"] as? String
        self.ATT_FILE_NO_MK = document["ATT_FILE_NO_MK"] as? String
        self.RCP_PARTS_DTLS = RCP_PARTS_DTLS
        self.MANUAL01 = document["MANUAL01"] as? String
        self.MANUAL_IMG01 = document["MANUAL_IMG01"] as? String
        self.MANUAL02 = document["MANUAL02"] as? String
        self.MANUAL_IMG02 = document["MANUAL_IMG02"] as? String
        self.MANUAL03 = document["MANUAL03"] as? String
        self.MANUAL_IMG03 = document["MANUAL_IMG03"] as? String
        self.MANUAL04 = document["MANUAL04"] as? String
        self.MANUAL_IMG04 = document["MANUAL_IMG04"] as? String
        self.MANUAL05 = document["MANUAL05"] as? String
        self.MANUAL_IMG05 = document["MANUAL_IMG05"] as? String
        self.MANUAL06 = document["MANUAL06"] as? String
        self.MANUAL_IMG06 = document["MANUAL_IMG06"] as? String
        self.MANUAL07 = document["MANUAL07"] as? String
        self.MANUAL_IMG07 = document["MANUAL_IMG07"] as? String
        self.MANUAL08 = document["MANUAL08"] as? String
        self.MANUAL_IMG08 = document["MANUAL_IMG08"] as? String
        self.MANUAL09 = document["MANUAL09"] as? String
        self.MANUAL_IMG09 = document["MANUAL_IMG09"] as? String
        self.MANUAL10 = document["MANUAL10"] as? String
        self.MANUAL_IMG10 = document["MANUAL_IMG10"] as? String
        self.MANUAL11 = document["MANUAL11"] as? String
        self.MANUAL_IMG11 = document["MANUAL_IMG11"] as? String
        self.MANUAL12 = document["MANUAL12"] as? String
        self.MANUAL_IMG12 = document["MANUAL_IMG12"] as? String
        self.MANUAL13 = document["MANUAL13"] as? String
        self.MANUAL_IMG13 = document["MANUAL_IMG13"] as? String
        self.MANUAL14 = document["MANUAL14"] as? String
        self.MANUAL_IMG14 = document["MANUAL_IMG14"] as? String
        self.MANUAL15 = document["MANUAL15"] as? String
        self.MANUAL_IMG15 = document["MANUAL_IMG15"] as? String
        self.MANUAL16 = document["MANUAL16"] as? String
        self.MANUAL_IMG16 = document["MANUAL_IMG16"] as? String
        self.MANUAL17 = document["MANUAL17"] as? String
        self.MANUAL_IMG17 = document["MANUAL_IMG17"] as? String
        self.MANUAL18 = document["MANUAL18"] as? String
        self.MANUAL_IMG18 = document["MANUAL_IMG18"] as? String
        self.MANUAL19 = document["MANUAL19"] as? String
        self.MANUAL_IMG19 = document["MANUAL_IMG19"] as? String
        self.MANUAL20 = document["MANUAL20"] as? String
        self.MANUAL_IMG20 = document["MANUAL_IMG20"] as? String
        self.RCP_NA_TIP = document["RCP_NA_TIP"] as? String
    }

    var dictionary: [String: Any] {
        return [
            "RCP_SEQ": RCP_SEQ,
            "RCP_NM": RCP_NM,
            "RCP_WAY2": RCP_WAY2,
            "RCP_PAT2": RCP_PAT2,
            "INFO_WGT": INFO_WGT ?? "",
            "INFO_ENG": INFO_ENG ?? "",
            "INFO_CAR": INFO_CAR ?? "",
            "INFO_PRO": INFO_PRO ?? "",
            "INFO_FAT": INFO_FAT ?? "",
            "INFO_NA": INFO_NA ?? "",
            "HASH_TAG": HASH_TAG ?? "",
            "ATT_FILE_NO_MAIN": ATT_FILE_NO_MAIN ?? "",
            "ATT_FILE_NO_MK": ATT_FILE_NO_MK ?? "",
            "RCP_PARTS_DTLS": RCP_PARTS_DTLS,
            "MANUAL01": MANUAL01 ?? "",
            "MANUAL_IMG01": MANUAL_IMG01 ?? "",
            "MANUAL02": MANUAL02 ?? "",
            "MANUAL_IMG02": MANUAL_IMG02 ?? "",
            "MANUAL03": MANUAL03 ?? "",
            "MANUAL_IMG03": MANUAL_IMG03 ?? "",
            "MANUAL04": MANUAL04 ?? "",
            "MANUAL_IMG04": MANUAL_IMG04 ?? "",
            "MANUAL05": MANUAL05 ?? "",
            "MANUAL_IMG05": MANUAL_IMG05 ?? "",
            "MANUAL06": MANUAL06 ?? "",
            "MANUAL_IMG06": MANUAL_IMG06 ?? "",
            "MANUAL07": MANUAL07 ?? "",
            "MANUAL_IMG07": MANUAL_IMG07 ?? "",
            "MANUAL08": MANUAL08 ?? "",
            "MANUAL_IMG08": MANUAL_IMG08 ?? "",
            "MANUAL09": MANUAL09 ?? "",
            "MANUAL_IMG09": MANUAL_IMG09 ?? "",
            "MANUAL10": MANUAL10 ?? "",
            "MANUAL_IMG10": MANUAL_IMG10 ?? "",
            "MANUAL11": MANUAL11 ?? "",
            "MANUAL_IMG11": MANUAL_IMG11 ?? "",
            "MANUAL12": MANUAL12 ?? "",
            "MANUAL_IMG12": MANUAL_IMG12 ?? "",
            "MANUAL13": MANUAL13 ?? "",
            "MANUAL_IMG13": MANUAL_IMG13 ?? "",
            "MANUAL14": MANUAL14 ?? "",
            "MANUAL_IMG14": MANUAL_IMG14 ?? "",
            "MANUAL15": MANUAL15 ?? "",
            "MANUAL_IMG15": MANUAL_IMG15 ?? "",
            "MANUAL16": MANUAL16 ?? "",
            "MANUAL_IMG16": MANUAL_IMG16 ?? "",
            "MANUAL17": MANUAL17 ?? "",
            "MANUAL_IMG17": MANUAL_IMG17 ?? "",
            "MANUAL18": MANUAL18 ?? "",
            "MANUAL_IMG18": MANUAL_IMG18 ?? "",
            "MANUAL19": MANUAL19 ?? "",
            "MANUAL_IMG19": MANUAL_IMG19 ?? "",
            "MANUAL20": MANUAL20 ?? "",
            "MANUAL_IMG20": MANUAL_IMG20 ?? "",
            "RCP_NA_TIP": RCP_NA_TIP ?? ""
        ]
    }

    static func emptyRecipe() -> Recipe {
        return Recipe(document: [
            "RCP_SEQ": UUID().uuidString,
            "RCP_NM": "",
            "RCP_WAY2": "",
            "RCP_PAT2": "",
            "RCP_PARTS_DTLS": ""
        ])!
    }
}

