//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Junior Silva on 13/01/23.
//

import UIKit

final class CharacterInfoCollectionViewCellViewModel {
    
    private let value: String
    private let type: `Type`
    
    public var title: String {
        self.type.displayTitle
    }
    
    static let dateFormatter: DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    public var displayValue: String {
        if value.isEmpty { return "None"}
        
        if let date = Self.dateFormatter.date(from: value), type == .created {
            return Self.shortDateFormatter.string(from: date)
        }
        
        return value.capitalized
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episode
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemYellow
            case .gender:
                return .systemBlue
            case .type:
                return .systemCyan
            case .species:
                return .systemMint
            case .origin:
                return .systemOrange
            case .location:
                return .systemPink
            case .created:
                return .systemPurple
            case .episode:
                return .systemBrown
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "questionmark.square.dashed")
            case .gender:
                return UIImage(systemName: "figure.dress.line.vertical.figure")
            case .type:
                return UIImage(systemName: "person.and.background.dotted")
            case .species:
                return UIImage(systemName: "bonjour")
            case .origin:
                return UIImage(systemName: "globe.americas")
            case .location:
                return UIImage(systemName: "airplane")
            case .created:
                return UIImage(systemName: "clock")
            case .episode:
                return UIImage(systemName: "tv")
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status,
                 .gender,
                 .type,
                 .species,
                 .origin,
                 .location,
                 .created:
                return rawValue.capitalized
            case .episode:
                return "Episodes"
            }
        }
    }
    
    init(type: `Type`, value: String) {
        self.type = type
        self.value = value
    }
    
}
