//
//  ThemeStore.swift
//  Memorize
//
//  Created by Markus Fox on 12.01.22.
//

import SwiftUI

struct Theme: Identifiable, Codable {
    
    var name: String
    var emojis: Array<String>
    var numberOfPairs: Int
    var rgba: RGBAColor
    var color: Color {
        get { Color(rgbaColor: rgba) }
        set { rgba = RGBAColor(color: newValue) }
    }
    var id: Int
    
    init(name: String, emojis: Array<String>, color: RGBAColor, id: Int) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairs = emojis.count
        self.rgba = color
        self.id = id
    }
    
    init(name: String, emojis: Array<String>, numberOfPairs: Int, color: RGBAColor, id: Int) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairs = numberOfPairs
        self.rgba = color
        self.id = id
    }
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]() {
        didSet {
            print("Storing Themes to UserDefaults via didSet")
            storeInUserDefaults()
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            // default themes
            themes = [
                Theme(name: "Vehicles", emojis: ["๐", "๐", "๐", "๐", "๐", "๐ด", "๐ฒ", "๐ต", "๐ฆผ", "๐"], numberOfPairs: 70, color: RGBAColor(color: Color.orange), id: 0),
                Theme(name: "Animals", emojis: ["๐", "๐ฆ", "๐ฆ", "๐ฆ", "๐ฆ", "๐บ", "๐", "๐ด", "๐", "๐", "๐", "๐ข", "๐ฆ", "๐ท", "๐ฆ", "๐ฆ", "๐", "๐ณ", "๐ฆ", "๐ฆญ", "๐", "๐ฆ", "๐", "๐", "๐"], numberOfPairs: 7, color: RGBAColor(color: .green), id: 1),
                Theme(name: "Hearts", emojis: ["โค๏ธ", "๐งก", "๐", "๐", "๐ค", "๐ค", "๐", "๐", "๐ค", "โค๏ธโ๐ฅ", "๐"], numberOfPairs: 5, color: RGBAColor(color: .red), id: 2),
                Theme(name: "Flags", emojis: ["๐ฉ๐ฟ", "๐ช๐ฌ", "๐ฆ๐ท", "๐ง๐ฆ", "๐ง๐ฌ", "๐ฉ๐ฐ", "๐ฏ๐ฒ", "๐ฎ๐ธ", "๐ถ๐ฆ", "๐จ๐ฆ", "๐ฆ๐น", "๐ท๐บ"], color: RGBAColor(color: .purple), id: 3),
                Theme(name: "Sport", emojis: ["โฝ๏ธ", "๐", "๐", "โพ๏ธ", "๐พ", "๐ฑ"], numberOfPairs: 6, color: RGBAColor(color: .indigo), id: 4),
                Theme(name: "Smilies", emojis: ["๐", "๐", "๐", "๐ฅฐ", "๐", "๐ฅณ", "๐ญ", "๐คฌ"], numberOfPairs: 30, color: RGBAColor(color: .yellow), id: 5)
            ]
        }
    }
    
    private var userDefaultsKey: String {
        "ThemeStore: " + name
    }
    
    func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    func insertTheme(named name: String, emojis: [String]? = nil, at index: Int = 0) -> Int {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? [], color: RGBAColor(color: .orange), id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
        return safeIndex
    }
}
 
