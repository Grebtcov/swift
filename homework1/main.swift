//
//  main.swift
//  homework1
//
//  Created by Alex x on 2/1/22.
//

import Foundation

struct SimpleQueue<T> where T: Comparable {
    private var items: [T] = []
    
    /// добавить новый элемент в конец очереди
    mutating func push(_ newItem: T) {
        items.append(newItem)
    }
    
    /// вернуть первый элемент из очереди
    mutating func pop() -> T? {
        return !items.isEmpty ? items.removeFirst() : nil
    }
    
    subscript(index: Int) -> T? {
        get {
            return index < items.count ? items[index] : nil
        }
        //Отошел от стандартной функциональности Очереди для эксперемента
        set(newItem) {
            assert(index < items.count ? true : false, "Index out of range")
            guard let newItem = newItem else {
                items.remove(at: index)
                return
            }
            items[index] = newItem
        }
    }

}

extension SimpleQueue {
    
    func filter(_ clouser: (T) -> Bool) -> SimpleQueue<T> {
        var simpleQueue = SimpleQueue<T>()
        
        for value in items {
            if clouser(value) {
                simpleQueue.push(value)
            }
        }
        
        return simpleQueue
    }
    
    func reduce<Result> (_ start: Result, _ clouser: (Result,T) -> Result) -> Result {
        var result = start
        for value in items {
            result = clouser(result, value)
        }

        return result
    }
    
    func map<Result>(_ clouser: (T) -> Result ) -> SimpleQueue<Result> {
        var resultQueue = SimpleQueue<Result>()
        
        for value in items {
            resultQueue.push(clouser(value))
        }
        
        return resultQueue
    }
    
    func sorted(by clouser: (T,T) -> Bool) -> SimpleQueue<T> {
        
        var resultQueue = SimpleQueue<T>()
        var resultItems = items
        for i in 0..<resultItems.count {
            for j in i..<resultItems.count {
                if clouser(resultItems[j], resultItems[i]) {
                    let bubble = resultItems[i]
                    resultItems[i] = resultItems[j]
                    resultItems[j] = bubble
                }
            }
        }
        
        for value in resultItems {
            resultQueue.push(value)
        }
        
        return resultQueue
    }
    
}

//MARK: Реализация CustomStringConvertible
extension SimpleQueue: CustomStringConvertible {
    var description: String {
        var result = "[ "
        for value in self.items {
            result += "\(value)"
            result += value != items.last ? ", " : String()
        }
        result += " ]"
        return result
    }
}

// MARK: Реализация Comparable
extension SimpleQueue: Comparable {
    
    static func < (lhs: SimpleQueue<T>, rhs: SimpleQueue<T>) -> Bool {
        
        if lhs.items.count < rhs.items.count {
            return true
        } else if lhs.items.count == rhs.items.count {
            for i in 0..<lhs.items.count where lhs.items[i] >= rhs.items[i] {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    static func == (lhs: SimpleQueue<T>, rhs: SimpleQueue<T>) -> Bool {
        
        if lhs.items.count == rhs.items.count {
            for i in 0..<lhs.items.count where lhs[i] != rhs[i] {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
}

var queueOne = SimpleQueue<Int>()
queueOne.push(1)
queueOne.push(2)
queueOne.push(3)
queueOne.push(4)

print(queueOne)
print(queueOne[5])
print("------")
print(queueOne.filter() { $0 > 2})
print(queueOne.reduce(0, +))
print(queueOne.sorted(by: >))
print(queueOne.map { Float($0) * 10 })

var queueEqualsOne = SimpleQueue<Int>()
queueEqualsOne.push(1)
queueEqualsOne.push(2)
queueEqualsOne.push(3)
queueEqualsOne.push(4)
print("------")

print(queueOne == queueEqualsOne)
print(queueOne != queueEqualsOne)
print(queueOne >= queueEqualsOne)
print(queueOne <= queueEqualsOne)

var queueTwo = SimpleQueue<Int>()
queueEqualsOne.push(0)
queueEqualsOne.push(2)
queueEqualsOne.push(3)
queueEqualsOne.push(4)
print("------")
print(queueOne > queueTwo)
print(queueTwo < queueOne)




