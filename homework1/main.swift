//
//  main.swift
//  homework1
//
//  Created by Alex x on 2/1/22.
//

import Foundation

func dividesRemainderWhole(number: Int, divider: Int) -> Bool {
    number % divider == 0 ? true : false
}

//передаем весь массив чтобы вся логика выбора числа была в функции
func addАFibonacciNumbers(array: [Int]) -> Int {
    var value = 0
    let countArray = array.count
    switch countArray {
    case 1 : value = 1
    case _ where countArray > 1 : value = array[countArray-2] + array[countArray - 1]
    default:
        break
    }
    return value
}

//Исходя из алгоритма предложенного в задаче мы должны знать до какого n смотреть
//чтобы заполнить массив из 100 элементов n должно быть 542
func methodEratosthenes(n: Int) -> [Int] {
    if n > 2{
        var numbers = Array(2...n)
        for number in numbers {
            if number != 0 {
                for i in 2...n {
                    let notEasyNumber = number * i
                    if notEasyNumber <= n {
                        numbers[notEasyNumber-2] = 0
                    } else {
                        break
                    }
                }
            }
        }
        return numbers.filter {$0 != 0}
    } else {
        return [2]
    }
}

var growingArray: [Int] = []

for i in 1...100{
    growingArray.append(i)
}

//т.к. по заданию необходимо удалить из этого массива
growingArray = growingArray.filter {
    !dividesRemainderWhole(number: $0, divider: 2) &&
    dividesRemainderWhole(number: $0, divider: 3)
}

print("4 задание: \(growingArray)")

var numbersFibonacci: [Int] = []

for _ in 1...50{
    numbersFibonacci.append(addАFibonacciNumbers(array: numbersFibonacci))
}

print("Числа Фибоначчи: \(numbersFibonacci)")

let primeNumbers = methodEratosthenes(n: 542)

print("Массив размером \(primeNumbers.count) с простыми числами: \(primeNumbers)")

