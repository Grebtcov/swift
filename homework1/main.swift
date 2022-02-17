//
//  main.swift
//  homework1
//
//  Created by Alex x on 2/1/22.
//

import Foundation


// MARK: Описание Enum
enum EngineType {
    case combustion
    case electric
}

extension EngineType: CustomStringConvertible {
    var description: String {
        switch self {
        case .combustion:
            return "Двигатель внутреннего сгорания"
        case .electric:
            return "Электродвигатель"
        }
    }
}

enum CarAction {
    case onEngine
    case offEngine
    case loadTruck
    case unloadTruck
}

extension CarAction: CustomStringConvertible {
    var description: String {
        switch self {
        case .onEngine:
            return "Двигатель включен"
        case .offEngine:
            return "Двигатель выключен"
        case .loadTruck:
            return "Багаж загружен"
        case .unloadTruck:
            return "Багаж выгружен"
        }
    }
}

enum DoorAction {
    case open
    case close
    
    var statusWindow: String {
        switch self {
        case .open:
            return "Окно открыто"
        case .close:
            return "Окно закрыто"
        }
    }
    
    var statusDoor: String {
        switch self {
        case .open:
            return "Дверь открыта"
        case .close:
            return "Дверь закрыта"
        }
    }
}

// MARK: Описание протоколов

protocol DoorProtocol {
    var doorStatus: DoorAction { get set }
    var windowStatus: DoorAction { get set }
    
    mutating func doorAction(condition: DoorAction) -> String
    mutating func windowAction(condition: DoorAction) -> String
    
}

extension DoorProtocol {
    mutating func doorAction(condition: DoorAction) -> String {
        switch condition {
        case .open:
            doorStatus = .open
        case .close:
            doorStatus = .close
        }
        
        return condition.statusDoor
    }
    
    mutating func windowAction(condition: DoorAction) -> String {
        
        switch condition {
        case .open:
            windowStatus = .open
        case .close:
            windowStatus = .close
        }
        
        return condition.statusWindow
    }
}

protocol CarProtocol {
    
    var brand: String { get }
    var model: String { get }
    var doors: [DoorProtocol] { get set }
    var engineType: EngineType { get set }
    var engineStatus: CarAction { get set }
    
    mutating func trunkAction(condition: CarAction, loaded: Int) -> String
    
    mutating func engineAction(condition: CarAction) -> String
    
}

extension CarProtocol {
    
    mutating func engineAction(condition: CarAction) -> String {
        switch condition {
        case .onEngine:
            engineStatus = .onEngine
        case .offEngine:
            engineStatus = .offEngine
        default:
            return "Нельзя выполнить данное действие"
        }
        
        return String()
    }
    
}

// MARK: Описание структуры двери
struct Door: DoorProtocol {
    var doorStatus: DoorAction
    var windowStatus: DoorAction
}

// MARK: Описание класса спортивная машина
final class SportCar{
    
    let brand: String
    let model: String
    var doors: [DoorProtocol] = []
    var engineType: EngineType
    var engineStatus: CarAction = .offEngine
    
    let trunkCapacity: Int
    var trunkLoaded: Int = 0
    private(set) var roofStatus: Action = .closeRoof
    
    enum Action {
        case openRoof
        case closeRoof
        
        var description: String {
            switch self {
            case .openRoof:
                return "Крыша убрана"
            case .closeRoof:
                return "Крыша установлена"
            }
        }
    }
    
    init(brand: String,
         model: String,
         trunkCapacity: Int,
         countDoor: Int,
         engineType: EngineType,
         roofStatus: SportCar.Action)
        {
            self.brand = brand
            self.model = model
            self.trunkCapacity = trunkCapacity
            self.engineType = engineType
            self.roofStatus = roofStatus
            
            for _ in 1...countDoor {
                doors.append(Door(doorStatus: .close, windowStatus: .close))
            }
        }
    
    func roofAction(condition: SportCar.Action) -> String {
        switch condition {
        case .openRoof:
            roofStatus = .openRoof
        case .closeRoof:
            roofStatus = .closeRoof
        }
        
        return roofStatus.description
    }
}

extension SportCar: CarProtocol {
    
    func trunkAction(condition: CarAction, loaded: Int) -> String {
        switch condition {
        case .loadTruck where trunkLoaded + loaded <= trunkCapacity:
            trunkLoaded += loaded
        case .unloadTruck where trunkLoaded >= loaded:
            trunkLoaded -= loaded
        default:
            return "Не возможно выполнить данную операцию"
        }
                
        return condition.description
    }
    
}

extension SportCar: CustomStringConvertible {
    var description: String {
        return """
               Спортивный автомобиль
               \(brand) \(model)
               Объем багажника: \(trunkCapacity)
               Тип двигателя: \(engineType)
               Количество дверей: \(doors.count)
               \(roofStatus.description)
               """
    }
}
// MARK: Описание протокола и класса Прицеп
protocol TrailerProtocol {
    var name: String { get }
    var trunkCapacity: Int { get }
    var trunkLoaded: Int { get set }
    
    mutating func trunkAction(condition: CarAction, loaded: Int) -> String
}

extension TrailerProtocol {
    mutating func trunkAction(condition: CarAction, loaded: Int) -> String {
        switch condition {
        case .loadTruck where trunkLoaded + loaded <= trunkCapacity:
            trunkLoaded += loaded
        case .unloadTruck where trunkLoaded >= loaded:
            trunkLoaded -= loaded
        default:
            return "Не возможно выполнить данную операцию"
        }
                
        return condition.description
    }
}

final class Trailer: TrailerProtocol {
    let name: String
    let trunkCapacity: Int
    var trunkLoaded: Int = 0
    
    
    init(name: String, trunkCapacity: Int) {
        self.name = name
        self.trunkCapacity = trunkCapacity
    }
    
}

extension Trailer: CustomStringConvertible {
    var description: String {
        return """
               Прицеп \(name)
               Объем: \(trunkCapacity)
               """
    }
}

// MARK: Описание класса Грузовая машина
final class TrunkCar {
    
    let brand: String
    let model: String
    var doors: [DoorProtocol] = []
    var engineType: EngineType
    var engineStatus: CarAction = .offEngine
    var trailer: Trailer?
    
    enum Action {
        case connectTrailer
        case unhookTrailer
         
        var description: String {
            switch self {
            case .connectTrailer:
                return "Прицеп прицеплен"
            case .unhookTrailer:
                return "Прицеп отцеплен"
            }
        }
    }
    
    init(brand: String,
         model: String,
         countDoor: Int,
         engineType: EngineType)
        {
            self.brand = brand
            self.model = model
            self.engineType = engineType
            
            for _ in 1...countDoor {
                doors.append(Door(doorStatus: .close, windowStatus: .close))
            }
        }
     
    func trailerAction(condition: TrunkCar.Action, trailer: Trailer) -> String {
        
        switch condition {
        case .connectTrailer:
            self.trailer = trailer
        case .unhookTrailer:
            self.trailer = nil
        }
        
        return condition.description
    }
    
}

extension TrunkCar: CarProtocol {
    func trunkAction(condition: CarAction, loaded: Int) -> String {
        if var trailer = trailer {
            return trailer.trunkAction(condition: condition, loaded: loaded)
        } else {
            return "У вас не прицеплен прицеп"
        }
    }
}

extension TrunkCar: CustomStringConvertible {
    var description: String {
        return """
               Грузовой автомобиль
               \(brand) \(model)
               Тип двигателя: \(engineType)
               Количество дверей: \(doors.count)
               -----
               \(trailer != nil ? String(describing: trailer!) : "Прицеп не прицеплен")
               -----
               """
    }
}

let porsche = SportCar(brand: "Porsche",
                       model: "911",
                       trunkCapacity: 80,
                       countDoor: 2,
                       engineType: .electric,
                       roofStatus: .closeRoof)

print(porsche.doors[0].doorAction(condition: .close))
print(porsche.trunkAction(condition: .loadTruck, loaded: 10))
print("---")
print(porsche)
print("---")

var trailer = Trailer(name: "Самосвальный", trunkCapacity: 20000)

var kamaz = TrunkCar(brand: "Камаз",
                     model: "45143-50",
                     countDoor: 2,
                     engineType: .combustion)

print(kamaz.trailerAction(condition: .connectTrailer, trailer: trailer))
print("---")
print(kamaz)
print("---")



