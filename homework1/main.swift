//
//  main.swift
//  homework1
//
//  Created by Alex x on 2/1/22.
//

import Foundation

class Car {
    
    enum EngineType {
        case combustion
        case electric
        
        var description: String {
            switch self {
            case .combustion:
                return "Двигатель внутреннего сгорания"
            case .electric:
                return "Электродвигатель"
            }
        }
    }
    
    enum Action {
        case onEngine
        case offEngine
        case loadTruck
        case unloadTruck
        
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
    
    struct Door {
        
        enum Action {
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
        
        var doorStatus: Action
        var windowStatus: Action
    }
    
    
    // let нельзя менять, нет смысла оборачивать в private
    let brand: String
    let model: String
    let trunkCapacity : Int
    // Сделал не privat т.к. меняю эту переменную из дочерних классов
    var trunkLoaded: Int = 0
    private(set) var doors: [Door] = []
    private(set) var engineType: EngineType
    private(set) var engineStatus: Action = .offEngine
    
    
    init(brand: String,
         model: String,
         trunkCapacity: Int,
         countDoor: Int,
         engineType: Car.EngineType)
    {
        self.brand = brand
        self.model = model
        self.trunkCapacity = trunkCapacity
        self.engineType = engineType
        
        for _ in 1...countDoor {
            self.doors.append(Door(doorStatus: .close, windowStatus: .close))
        }
    }
    
    //Пустой метод который переопределяем
    func trunkAction(condition: Car.Action, loaded: Int) -> String {
       return String()
    }
    
    //Метод к которому добавляем реализацию в дочерних
    func description() -> String {
        return """
               \(brand) \(model)
               Объем багажника: \(trunkCapacity)
               Тип двигателя: \(engineType.description)
               Количество дверей: \(doors.count)
               """
    }
    
    
    func engineAction(condition: Car.Action) -> String {
        switch condition {
        case .onEngine:
            engineStatus = .onEngine
        case .offEngine:
            engineStatus = .offEngine
        default:
            return "Нельзя выполнить данное действие"
        }
        
        return ""
    }
    
    func doorAction(condition: Door.Action, numberDoor: Int) -> String {
        switch condition {
        case .open:
            doors[numberDoor].doorStatus = .open
        case .close:
            doors[numberDoor].doorStatus = .close
        }
        
        return condition.statusDoor
    }
    
    func windowAction(condition: Door.Action, numberDoor: Int) -> String {
        
        switch condition {
        case .open:
            doors[numberDoor].windowStatus = .open
        case .close:
            doors[numberDoor].windowStatus = .close
        }
        
        return condition.statusWindow
    }
    
}

final class SportCar: Car {
    
   // Понял третье задание так, что просто пересоздаем enum и добавляем особые действия
   // extension нельзя применять к enum
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
    
    private(set) var roofStatus: Action = .closeRoof
    
    
    init(brand: String,
                  model: String,
                  trunkCapacity: Int,
                  countDoor: Int,
                  engineType: Car.EngineType,
                  roofStatus: SportCar.Action
                  )
    {
        super.init(brand: brand,
                   model: model,
                   trunkCapacity: trunkCapacity,
                   countDoor: countDoor,
                   engineType: engineType)
        self.roofStatus = roofStatus
    }
    
    override func trunkAction(condition: Car.Action, loaded: Int) -> String {
        
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
    
    override func description() -> String {
        return """
               Спортивная машина
               \(super.description())
               \(roofStatus.description)
               """
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

final class Trailer {
    let name: String
    private(set) weak var trunkCar: TrunkCar?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Экземпляр класса прицеп уничтожен")
    }
    
    func connectToTrunk(trunk: TrunkCar) {
        trunkCar = trunk
    }
    
    func unhook() {
        trunkCar = nil
    }
    
    
}

//Грузовик к которому можно подсоединить дополнительный прицеп
final class TrunkCar: Car {
    
    // Понял третье задание так, что просто пересоздаем enum и добавляем особые действия
    // extension нельзя применять к enum
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
     
    private(set) var trailer: Trailer?
    
    deinit {
        print("Экзепляр класса грузовик уничтожен")
    }
    
    override func description() -> String {
        
        return """
               Грузовая машина
               \(super.description())
               Прицеп: \(trailer != nil ? trailer!.name : "не прицеплен")
               """
    }
    
    override func trunkAction(condition: Car.Action, loaded: Int) -> String {
        
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
    
    func trailerAction(condition: TrunkCar.Action, trailer: Trailer) -> String {
        
        switch condition {
        case .connectTrailer:
            self.trailer = trailer
            trailer.connectToTrunk(trunk: self)
        case .unhookTrailer:
            self.trailer = nil
            //trailer.unhook()
        }
        
        return condition.description
    }
    
}

let porsche = SportCar(brand: "Porsche",
                       model: "911",
                       trunkCapacity: 80,
                       countDoor: 2,
                       engineType: .electric,
                       roofStatus: .closeRoof)

print(porsche.doorAction(condition: .close, numberDoor: 0))
print(porsche.trunkAction(condition: .loadTruck, loaded: 10))
print("---")
print(porsche.description())
print("---")

var trailer: Trailer? = Trailer(name: "Самосвальный")

var kamaz: TrunkCar? = TrunkCar(brand: "Камаз",
                     model: "45143-50",
                     trunkCapacity: 20000,
                     countDoor: 2,
                     engineType: .combustion)

if let kamaz = kamaz,
   let trailer = trailer{
    print(kamaz.trailerAction(condition: .connectTrailer, trailer: trailer))
    print("---")
    print(kamaz.description())
    print("---")
    print(trailer.name)
}


kamaz = nil
trailer = nil
