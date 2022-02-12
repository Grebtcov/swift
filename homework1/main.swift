//
//  main.swift
//  homework1
//
//  Created by Alex x on 2/1/22.
//

import Foundation

// MARK: Описание enum
enum EngineCondition{
    case on
    case off
    
    var description: String {
        switch self {
        case .on:
            return "Двигатель включен"
        case .off:
            return "Двигатель выключен"
        }
    }
}

enum WindowsCondition{
    case open
    case close
    
    var description: String {
        switch self {
        case .open:
            return "Окно открыто"
        case .close:
            return "Окно закрыто"
        }
    }
}

enum DoorCondition{
    case open
    case close
    
    var description: String {
        switch self {
        case .open:
            return "Дверь открыта"
        case .close:
            return "Дверь закрыта"
        }
    }
}

enum SignalingCondition{
    case on
    case off
    case alarm 
    
    var description: String{
        switch self {
        case .on:
            return "Сигнализация включена"
        case .off:
            return "Сигнализация выключена"
        case .alarm:
            return "Сигнализация заработала: виу виу виу виу"
        }
    }
}

enum CargoHandling{
    case load
    case unload
    
    var trueDescription: String {
        switch self {
        case .load:
            return "Багаж успешно загружен"
        case .unload:
            return "Багаж успешно выгружен"
        }
    }
    
    var falseDescription: String {
        switch self {
        case .load:
           return "Ошибка! \nНе удалось загрузить багаж! \nНедостаточно места"
        case .unload:
            return "Ошибка! \nНельзя выгрузить багаж"
        }
        
    }
}



//MARK: Описание Двери
struct Door {
    var windowStatus: WindowsCondition
    var doorStatus: DoorCondition
}

//MARK: Описание Сигнализации
struct Signaling {
    private(set) var condition: SignalingCondition = .off
    
    mutating func onSignaling(doors: [Door]) -> String {
        
        guard condition == .off else {
            return condition.description
        }
        
        var result = ""
        
        for (index,door) in doors.enumerated() {
            result += door.doorStatus == .open ? "Закрыть \(index)ую дверь. " : ""
            result += door.windowStatus == .open ? "Закрыть окно на \(index) двери. " : ""
        }
        
        if result == "" {
            condition = .on
            result = condition.description
        } else {
            result = "Ошибка! \nДля включения сигнализации Вам необходимо: \n\(result)"
        }
        
        return result
    }
    
    mutating func offSignaling() -> String {
        
        if condition == .on || condition == .alarm {
            condition = .off
        }
        
        return condition.description
    }
    
    mutating func onAlarmSignaling() -> String {
        condition = .alarm
        return condition.description
    }
    
    mutating func checkSignaling(message: String) -> (isFlag: Bool,message: String) {
        if condition == .on || condition == .alarm {
            return (isFlag: false, message: "\(message) \n\(onAlarmSignaling())")
        } else {
            return (isFlag: true,message: "")
        }
    }
}

// MARK: Описание машины
struct SportCar {
    let brand: String
    let model: String
    let yearOfIssue: Int
    let maximumSpeed: Int
    let trunkCapasity: Int
    var engine: EngineCondition = .off
    private(set) var doors: [Door]
    private(set) var trunkBaggage: Int = 0
    private(set) var signaling = Signaling(condition: .off)
    
    var numberDoors: Int {
        return doors.count
    }
    
    init?(brand: String, model: String, yearOfIssue: Int, trunkCapasity: Int, numberDoors: Int, maximumSpeed: Int) {
        
        guard trunkCapasity <= 100,
              maximumSpeed >= 100,
              numberDoors <= 4 else {
                  return nil
              }
        
        self.brand = brand
        self.model = model
        self.yearOfIssue = yearOfIssue
        self.trunkCapasity = trunkCapasity
        self.maximumSpeed = maximumSpeed
        
        var initDoor: [Door] = []
        for _ in 0...numberDoors{
            let door = Door(windowStatus: .close, doorStatus: .close)
            initDoor.append(door)
        }
        self.doors = initDoor
        
        
    }
    
    func desription() -> String {
        // А что лучше \n или вот так вот выводить текстовые данные в те же модальные окна?
        return """
        ---Машина---
        \(brand) \(model)
        Год выпуска: \(yearOfIssue)
        Количество дверей: \(numberDoors)
        Максимальная скорость: \(maximumSpeed)
        Максимальная вместимость багажника: \(trunkCapasity)
        ----------------------------------
        """
            
    }
    
    mutating func signalingAction(condition: SignalingCondition) -> String {
        
        switch condition {
        case .on:
            return signaling.onSignaling(doors: self.doors)
        case .off:
            return signaling.offSignaling()
        case .alarm:
            return signaling.onAlarmSignaling()
        }
        
    }
    
    mutating func trunkAction(condition: CargoHandling, baggage: Int) -> String {
        
        let check = signaling.checkSignaling(message: "Попытка взаимодействия с багажником")
        guard check.isFlag else {
            return check.message
        }
        
        var result = ""
        
        switch condition {
        case .load where trunkBaggage + baggage < trunkCapasity:
            trunkBaggage += baggage
            result = condition.trueDescription
        case .unload where trunkBaggage - baggage >= 0:
            trunkBaggage -= baggage
            result = condition.trueDescription
        default:
            result = condition.falseDescription
        }
        
        return result
    }
    
    mutating func doorAction(number: Int, condition: DoorCondition) -> String {
        
        let check = signaling.checkSignaling(message: "Попытка взаимодействия с \(number)ой дверью")
        guard check.isFlag else {
            return check.message
        }
        
        switch condition {
        case .open:
            doors[number].doorStatus = .open
        case .close:
            doors[number].doorStatus = .close
        }
        
        return doors[number].doorStatus.description
    }
    
    mutating func windowsAction(number: Int, condition: WindowsCondition) -> String {
        
        let check = signaling.checkSignaling(message: "Попытка взаимодействия с окном на \(number) двери")
        guard check.isFlag else {
            return check.message
        }
        
        switch condition {
        case .open:
            doors[number].windowStatus = .open
        case .close:
            doors[number].windowStatus = .close
        }
        
        return doors[number].windowStatus.description
    }
    
}

//MARK: Описание прицепа

enum CargoTrailerAction {
    case attach
    case unhook
    
    var description: String {
        switch self {
        case .attach:
            return "Прицеп прицеплен"
        case .unhook:
            return "Прицеп отцеплен"
        }
    }
}

struct CargoTrailer {
    let trunkCapasity: Int
    private(set) var trunkBaggage: Int = 0
    
    mutating func cargoHandling(condition: CargoHandling, baggage: Int) -> String {
        
        var result = ""
        
        switch condition {
        case .load where trunkBaggage + baggage < trunkCapasity:
            trunkBaggage += baggage
            result = condition.trueDescription
        case .unload where trunkBaggage - baggage >= 0:
            trunkBaggage -= baggage
            result = condition.trueDescription
        default:
            result = condition.falseDescription
        }
        
        return result
    }
}



// MARK: Описание грузовика
struct TrunkCar {
    let brand: String
    let model: String
    let yearOfIssue: Int
    let maximumSpeed: Int
    private var cargoTrailer: CargoTrailer?
    var engine: EngineCondition = .off
    private(set) var doors: [Door]
    
    private(set) var signaling = Signaling(condition: .off)
    
    var numberDoors: Int {
        return doors.count
    }
    
    init?(brand: String, model: String, yearOfIssue: Int, trunkCapasity: Int, numberDoors: Int, maximumSpeed: Int) {
        
        guard trunkCapasity > 100,
              maximumSpeed <= 200,
              numberDoors == 2 else {
                  return nil
              }
        
        self.brand = brand
        self.model = model
        self.yearOfIssue = yearOfIssue
        self.maximumSpeed = maximumSpeed
        
        var initDoor: [Door] = []
        for _ in 0...numberDoors{
            let door = Door(windowStatus: .close, doorStatus: .close)
            initDoor.append(door)
        }
        self.doors = initDoor

    }
    
    func desription() -> String {
        // А что лучше \n или вот так вот выводить текстовые данные в те же модальные окна?
        return """
        ---Машина---
        \(brand) \(model)
        Год выпуска: \(yearOfIssue)
        Количество дверей: \(numberDoors)
        Максимальная скорость: \(maximumSpeed)
        ----------------------------------
        """
            
    }
    
    mutating func signalingAction(condition: SignalingCondition) -> String {
        
        switch condition {
        case .on:
            return signaling.onSignaling(doors: self.doors)
        case .off:
            return signaling.offSignaling()
        case .alarm:
            return signaling.onAlarmSignaling()
        }
        
    }
    
    mutating func doorAction(number: Int, condition: DoorCondition) -> String {
        
        let check = signaling.checkSignaling(message: "Попытка взаимодействия с \(number)ой дверью")
        guard check.isFlag else {
            return check.message
        }
        
        switch condition {
        case .open:
            doors[number].doorStatus = .open
        case .close:
            doors[number].doorStatus = .close
        }
        
        return doors[number].doorStatus.description
    }
    
    mutating func windowsAction(number: Int, condition: WindowsCondition) -> String {
        
        let check = signaling.checkSignaling(message: "Попытка взаимодействия с окном на \(number) двери")
        guard check.isFlag else {
            return check.message
        }
        
        switch condition {
        case .open:
            doors[number].windowStatus = .open
        case .close:
            doors[number].windowStatus = .close
        }
        
        return doors[number].windowStatus.description
    }
    
    func informationСargoTrailer() -> String {
        if let trailer = cargoTrailer {
            return "Прицеплен прицеп на \(trailer.trunkCapasity) кг. Загружен на \(trailer.trunkBaggage) кг "
        } else {
            return "К грузовику не прицеплен прицеп"
        }
    }
    
    mutating func cargoTrailerAction(condition: CargoTrailerAction) -> String{
        
        if cargoTrailer == nil, condition == .unhook {
            return "Ошибка! \nУ вас не прикреплен прицеп"
        } else if cargoTrailer != nil, condition == .attach {
            return "Ошибка! \nДля прикрепления нового прицепа, отцепите старый"
        }
        
        switch condition {
        case .attach:
            cargoTrailer = CargoTrailer(trunkCapasity: 1500)
        case .unhook:
            cargoTrailer = nil
        }
        
        return condition.description
    }
    
    mutating func cargoHandling(condition: CargoHandling, baggage: Int) -> String {
        
        let check = signaling.checkSignaling(message: "Попытка взаимодействия с багажником")
        guard check.isFlag else {
            return check.message
        }
        
        guard var trailer = cargoTrailer else {
            return "Ошибка! \nВы не можете загрузить багаж пока не прицепете прицеп"
        }
        
        let result = trailer.cargoHandling(condition: condition, baggage: baggage)
        cargoTrailer = trailer
        return result
    }

}

if var car = SportCar(brand: "Tesla", model: "X", yearOfIssue: 2020, trunkCapasity: 50, numberDoors: 2, maximumSpeed: 200) {
    //Подумал что уж совсем плохо принты вызывать внутри метода, метод должен что то отдавать
    print(car.desription())
    print(car.signaling.condition.description)
    print(car.doorAction(number: 0, condition: .open))
    print(car.signalingAction(condition: .on))
    print(car.doorAction(number: 0, condition: .close))
    print(car.signalingAction(condition: .on))
    print(car.doorAction(number: 0, condition: .open))
    print(car.signalingAction(condition: .off))
    print(car.windowsAction(number: 1, condition: .open))
    print(car.trunkAction(condition: .unload, baggage: 30))
    print(car.trunkAction(condition: .load, baggage: 25))
    print(car.trunkBaggage)
} else {
    print("Вы не можете создать спортивную машину с такими характеристиками")
}

print()

if var trunkCar = TrunkCar(brand: "Hyundai", model: "Mighty", yearOfIssue: 2021, trunkCapasity: 2500, numberDoors: 2, maximumSpeed: 150) {
    //Подумал что уж совсем плохо принты вызывать внутри метода, метод должен что то отдавать
    print(trunkCar.desription())
    print(trunkCar.signaling.condition.description)
    print(trunkCar.doorAction(number: 0, condition: .open))
    print(trunkCar.signalingAction(condition: .on))
    print(trunkCar.doorAction(number: 0, condition: .close))
    print(trunkCar.signalingAction(condition: .on))
    print(trunkCar.doorAction(number: 0, condition: .open))
    print(trunkCar.signalingAction(condition: .off))
    print(trunkCar.windowsAction(number: 1, condition: .open))
    print(trunkCar.cargoHandling(condition: .load, baggage: 500))
    print(trunkCar.cargoTrailerAction(condition: .attach))
    print(trunkCar.informationСargoTrailer())
    print(trunkCar.cargoHandling(condition: .load, baggage: 500))
    print(trunkCar.informationСargoTrailer())
} else {
    print("Вы не можете создать спортивную машину с такими характеристиками")
}

