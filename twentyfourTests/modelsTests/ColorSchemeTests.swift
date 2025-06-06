import XCTest
import SwiftUI
@testable import twentyfour

final class ColorSchemeTests: XCTestCase {
    func testAllCases() {
        let allSchemes = twentyfour.ColorScheme.allCases
        XCTAssertEqual(allSchemes.count, 9)
        XCTAssertTrue(allSchemes.contains(.classic))
        XCTAssertTrue(allSchemes.contains(.hermes))
        XCTAssertTrue(allSchemes.contains(.barbie))
        XCTAssertTrue(allSchemes.contains(.seahawks))
        XCTAssertTrue(allSchemes.contains(.barcelona))
        XCTAssertTrue(allSchemes.contains(.interMilan))
        XCTAssertTrue(allSchemes.contains(.psg))
        XCTAssertTrue(allSchemes.contains(.lakers))
        XCTAssertTrue(allSchemes.contains(.bocaJuniors))
    }
    
    func testIdentifiable() {
        for scheme in twentyfour.ColorScheme.allCases {
            XCTAssertEqual(scheme.id, scheme.rawValue)
        }
    }
    
    func testLocalizationKeys() {
        XCTAssertEqual(ColorScheme.classic.localizationKey, .colorSchemeClassic)
        XCTAssertEqual(ColorScheme.hermes.localizationKey, .colorSchemeHermes)
        XCTAssertEqual(ColorScheme.barbie.localizationKey, .colorSchemeBarbie)
        XCTAssertEqual(ColorScheme.seahawks.localizationKey, .colorSchemeSeahawks)
        XCTAssertEqual(ColorScheme.barcelona.localizationKey, .colorSchemeBarcelona)
        XCTAssertEqual(ColorScheme.interMilan.localizationKey, .colorSchemeInterMilan)
        XCTAssertEqual(ColorScheme.psg.localizationKey, .colorSchemePSG)
        XCTAssertEqual(ColorScheme.lakers.localizationKey, .colorSchemeLakers)
        XCTAssertEqual(ColorScheme.bocaJuniors.localizationKey, .colorSchemeBocaJuniors)
    }
    
    func testLocalizedNames() {
        for scheme in twentyfour.ColorScheme.allCases {
            let englishName = scheme.localizedName(language: .english)
            let chineseName = scheme.localizedName(language: .chinese)
            
            XCTAssertFalse(englishName.isEmpty)
            XCTAssertFalse(chineseName.isEmpty)
            XCTAssertNotEqual(englishName, chineseName)
        }
    }
    
    func testPrimaryColors() {
        // Test a few specific color values
        let classicPrimary = ColorScheme.classic.primary
        let hermesPrimary = ColorScheme.hermes.primary
        let barbiePrimary = ColorScheme.barbie.primary
        
        // Test classic soft black
        XCTAssertEqual(classicPrimary, Color(white: 0.15))
        
        // Test Hermes black (#1A1A1A)
        let hermesComponents = UIColor(hermesPrimary).cgColor.components
        XCTAssertNotNil(hermesComponents)
        if let components = hermesComponents {
            XCTAssertEqual(components[0], 0x1A/255, accuracy: 0.01) // R
            XCTAssertEqual(components[1], 0x1A/255, accuracy: 0.01) // G
            XCTAssertEqual(components[2], 0x1A/255, accuracy: 0.01) // B
        }
        
        // Test Barbie blue (#163273)
        let barbieComponents = UIColor(barbiePrimary).cgColor.components
        XCTAssertNotNil(barbieComponents)
        if let components = barbieComponents {
            XCTAssertEqual(components[0], 0x16/255, accuracy: 0.01) // R
            XCTAssertEqual(components[1], 0x32/255, accuracy: 0.01) // G
            XCTAssertEqual(components[2], 0x73/255, accuracy: 0.01) // B
        }
    }
    
    func testSecondaryColors() {
        // Test a few specific color values
        let classicSecondary = ColorScheme.classic.secondary
        let hermesSecondary = ColorScheme.hermes.secondary
        let barbieSecondary = ColorScheme.barbie.secondary
        
        // Test classic soft red
        let classicComponents = UIColor(classicSecondary).cgColor.components
        XCTAssertNotNil(classicComponents)
        if let components = classicComponents {
            XCTAssertEqual(components[0], 0.87, accuracy: 0.01) // R
            XCTAssertEqual(components[1], 0.27, accuracy: 0.01) // G
            XCTAssertEqual(components[2], 0.27, accuracy: 0.01) // B
        }
        
        // Test Hermes orange (#FF8700)
        let hermesComponents = UIColor(hermesSecondary).cgColor.components
        XCTAssertNotNil(hermesComponents)
        if let components = hermesComponents {
            XCTAssertEqual(components[0], 0xFF/255, accuracy: 0.01) // R
            XCTAssertEqual(components[1], 0x87/255, accuracy: 0.01) // G
            XCTAssertEqual(components[2], 0x00/255, accuracy: 0.01) // B
        }
        
        // Test Barbie pink (#FA517C)
        let barbieComponents = UIColor(barbieSecondary).cgColor.components
        XCTAssertNotNil(barbieComponents)
        if let components = barbieComponents {
            XCTAssertEqual(components[0], 0xFA/255, accuracy: 0.01) // R
            XCTAssertEqual(components[1], 0x51/255, accuracy: 0.01) // G
            XCTAssertEqual(components[2], 0x7C/255, accuracy: 0.01) // B
        }
    }
    
    func testTextAndIconColor() {
        for scheme in twentyfour.ColorScheme.allCases {
            let textColor = scheme.textAndIcon
            let components = UIColor(textColor).cgColor.components
            XCTAssertNotNil(components)
            if let components = components {
                // Should be white with 0.9 opacity
                XCTAssertEqual(components[0], 1.0, accuracy: 0.01) // R
                XCTAssertEqual(components[1], 1.0, accuracy: 0.01) // G
                XCTAssertEqual(components[2], 1.0, accuracy: 0.01) // B
                XCTAssertEqual(components[3], 0.9, accuracy: 0.01) // Alpha
            }
        }
    }
    
    func testDisabledBackgroundColor() {
        for scheme in twentyfour.ColorScheme.allCases {
            let disabledColor = scheme.disabledBackground
            XCTAssertEqual(disabledColor, .gray)
        }
    }
} 