//
//  main.swift
//  homework
//
//  Created by Alex x on 26/2/22.
//

import Foundation


enum ErrorSimpleATM: Error {
    case noCurrency
    case noBillValue
    case noNumberOfBills
    case insufficientFunds
    case noSpace(Int)
}

extension ErrorSimpleATM: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noCurrency:
            return "Нет данной валюты"
        case .noBillValue:
            return "Кассеты с данными купюрами нет в банкомате"
        case .noNumberOfBills:
            return "В банкомате не достаточно купюр данного номинала"
        case .insufficientFunds:
            return "У вас недостаточно средств на счету"
        case .noSpace(let countBill):
            return "Недостаточно места в банкомате, вы можете положить \(countBill) купюр данного номинала"
        }
    }
}

struct Result {
    let bill: Bill?
    let count: Int?
    let error: ErrorSimpleATM?
}

struct Bill {
    let billValue: Int
    let currency: String
}

struct Cassette {
    let bill: Bill
    var count: Int
    let maxCount: Int
    
    var possibleNumber: Int {
        return maxCount - count
    }
}

// ATM - банкомат
class SimpleATM {
    var currencies: [String:[Int:Cassette]] = [
        "Руб": [100: Cassette(bill: Bill(billValue: 100, currency: "Руб"), count: 10, maxCount: 10),
                200: Cassette(bill: Bill(billValue: 200, currency: "Руб"), count: 10, maxCount: 10),
                1000:Cassette(bill: Bill(billValue: 1000, currency: "Руб"), count: 0, maxCount: 10),
                5000:Cassette(bill: Bill(billValue: 5000, currency: "Руб"), count: 35, maxCount: 35)]]
    
    private(set) var amountOfClientMoney = 25000
    
    
    func cashOut(currency: String, billValue: Int, count: Int) -> Result {
        
        guard let currentCurrency = currencies[currency] else {
            return Result(bill: nil,
                          count: nil,
                          error: ErrorSimpleATM.noCurrency)
        }
        guard let casette = currentCurrency[billValue] else {
            return Result(bill: nil,
                          count: nil,
                          error: ErrorSimpleATM.noBillValue)
        }
        guard count * billValue <= amountOfClientMoney else {
            return Result(bill: nil,
                          count: nil,
                          error: ErrorSimpleATM.insufficientFunds)
        }
        guard count <= casette.count else {
            return Result(bill: nil,
                          count: nil,
                          error: ErrorSimpleATM.noNumberOfBills)
        }
        
        amountOfClientMoney -= count * billValue
        currencies[currency]?[billValue]?.count -= count
        
        let bill = currencies[currency]?[billValue]?.bill
        
        return Result(bill: bill, count: count, error: nil)
    }
    
    func cashIn(currency: String, billValue: Int, count: Int) throws -> String {
        
        guard let currentCurrency = currencies[currency] else { throw ErrorSimpleATM.noCurrency }
        guard let casette = currentCurrency[billValue] else { throw ErrorSimpleATM.noBillValue }
        guard count <= casette.possibleNumber else { throw ErrorSimpleATM.noSpace(casette.possibleNumber) }
        
        currencies[currency]?[billValue]?.count += count
        amountOfClientMoney += count * billValue
        
        return "Средства успешно зачислены на Ваш счет"
    }
    
    
}

var atm = SimpleATM()

//Для первого задания
var result = atm.cashOut(currency: "$", billValue: 100, count: 10)
if let bill = result.bill,
   let count = result.count {
    print("Вы сняли \(count) купюр, номиналом \(bill.billValue)")
} else {
    print(result.error?.errorDescription ?? "Ошибка")
}

result = atm.cashOut(currency: "Руб", billValue: 100, count: 10)
if let bill = result.bill,
   let count = result.count {
    print("Вы сняли \(count) купюр, номиналом \(bill.billValue)")
} else {
    print(result.error?.errorDescription ?? "Ошибка")
}

result = atm.cashOut(currency: "Руб", billValue: 100, count: 10)
if let bill = result.bill,
   let count = result.count {
    print("Вы сняли \(count) купюр, номиналом \(bill.billValue)")
} else {
    print(result.error?.errorDescription ?? "Ошибка")
}

result = atm.cashOut(currency: "Руб", billValue: 500, count: 10)
if let bill = result.bill,
   let count = result.count {
    print("Вы сняли \(count) купюр, номиналом \(bill.billValue)")
} else {
    print(result.error?.errorDescription ?? "Ошибка")
}

print("\n-----------------------------------------------------\n")

//Для второго задания
do {
   try print(atm.cashIn(currency: "$", billValue: 100, count: 10))
} catch {
    print(error.localizedDescription)
}

do {
   try print(atm.cashIn(currency: "Руб", billValue: 100, count: 8))
} catch {
    print(error.localizedDescription)
}

do {
   try print(atm.cashIn(currency: "Руб", billValue: 100, count: 10))
} catch {
    print(error.localizedDescription)
}

do {
   try print(atm.cashIn(currency: "Руб", billValue: 500, count: 10))
} catch {
    print(error.localizedDescription)
}
