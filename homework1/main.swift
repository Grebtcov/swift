//
//  main.swift
//  homework1
//
//  Created by Alex x on 2/1/22.
//

import Foundation

func inputNumber(isTestPositive: Bool) -> Double{
    repeat{
        print("Введите число")
        let num = readLine()
        if let num = Double(num ?? ""){
            if isTestPositive{
                if num > 0{
                    return num
                }else{
                    print("Введите чило больше нуля")
                    print("------------------------------")
                }
            }else{
                return num
            }
        }else{
            print("Вы ввели не число")
            print("-----------------")
        }
    }while(true)
}

func quadraticEquation(){
    print("Для квадратичного уравнения введите a, b и с")
    print("Коэффицент а")
    let a = inputNumber(isTestPositive: false)
    print("Коэффицент b")
    let b = inputNumber(isTestPositive: false)
    print("Коэффицент c")
    let c = inputNumber(isTestPositive: false)
    let d = pow(b, 2) - (4 * a * c)
    if d < 0{
        print("корней нет")
    }else if d > 0{
        print("1 корень: \((-b + sqrt(d))/(2*a))" )
        print("2 корень: \((-b - sqrt(d))/(2*a))" )
    }else{
        let result: Double = (-b + sqrt(d))/(2*a)
        // При выводе на консоль 0 пишется как -nan
        if(result == 0){
            print("Корень: 0" )
        }else{
            print("Корень: \(result)" )
        }
    }
}

func triangle(){
    print("1 катет")
    let cathetusOne = inputNumber(isTestPositive: true)
    print("2 катет")
    let cathetusTwo = inputNumber(isTestPositive: true)
    print("Площадь прямоугольного треугольника: \((cathetusOne * cathetusTwo)/2)")
    let hypotenuse = sqrt(pow(cathetusOne, 2) + pow(cathetusTwo, 2))
    print("Периметр прямоугольного треугольника: \(cathetusOne + cathetusTwo + hypotenuse)")
    print("Гипотенуза треугольника: \(hypotenuse)")
}

func depositAmount(){
    print("Сумма вклада в банк")
    var depositAmount = inputNumber(isTestPositive: true)
    print("годовой процент")
    let annualInterest = inputNumber(isTestPositive: true)
    for _ in 1...5{
        depositAmount += (depositAmount / 100) * annualInterest
    }
    print(String(format: "Сумма вклада через 5 лет = %.2f", depositAmount))
}

menu: repeat{
    print("----Меню----")
    print("1. Решить квадратное уровнение")
    print("2. Прямоугольный треугольник")
    print("3. Рассчитать сумму вклада")
    print("4. Выйти из программы")
    print("------------------------------")
    switch inputNumber(isTestPositive: true){
    case 1:
        quadraticEquation()
    case 2:
        triangle()
    case 3:
        depositAmount()
    case 4:
        break menu
    default:
        print("Вы ввели число которого нет в меню, попробуйте еще раз!")
        print("-----------------------")
    }
}while(true)

print("До встречи!")

