//1.Да се имплементира шаблонен свързан списък със съответния интерфейс.

class List<T> {
    var value: T
    var next: List<T>?

    init(_ items: Any...) {
        if items.isEmpty { // empty
            self.value = Int.min as! T
            self.next = nil
        } else {
            var result: [T] = []

            for v in items[0...] {
                if (type(of: v) == T.self) || (type(of: v) == Int.self) {
                    let v = v as! T
                    result.append(v)
                } else if (type(of: v) == List<Int>.self) {
                    let v = v as! List<Int>
                    var c: List<Int>? = v

                    while c != nil {
                        let temp: T = c!.value as! T
                        result.append(temp)
                        c = c!.next
                    }
                } else if (type(of: v) == List<Any>.self) {
                    
                }
            }
            
            self.value = result[0]

            for elem in result[1...] {
                self.insert(elem)
            }
        }
    }

    func insert(_ item: T) {
        let temp = List<T>()
        temp.value = item

        if self.next != nil {
            var curr = self
            while curr.next != nil {
                curr = curr.next!
            }
            curr.next = temp 
        } else {
            self.next = temp
        }
    }

    func content() {
        var s = "["
        var curr: List<T>? = self

        while curr != nil {
            s += "\(curr!.value)"
            curr = curr!.next
            if curr != nil { s += ", " }
        }

        print("\(s)]")
    }
}

extension List {
    subscript(index: Int) -> T? {
        if index < 0 || index >= length {
            return nil
        }

        if index != 0 {
            if let next = next {
                return next[index - 1]
            }
        } else {
            return self.value
        }

        return nil
    }
}

extension List {
    var length: Int {
        if let next = next {
            return 1 + next.length
        }

        return 1
    }
}

extension List {
    func reverse() {
        var curr: List<T>? = self
        var result: [T] = []

        while curr != nil {
            result.append(curr!.value)
            curr = curr!.next
        }

        curr = self
        result.reverse()

        for elem in result {
            curr!.value = elem
            curr = curr!.next
        }
        
        /*
        var curr: List<T>? = self
        var prev: List<T>? = nil
        var next: List<T>? = nil

        while curr != nil {
            next = curr!.next
            curr!.next = prev

            prev = curr
            curr = next
        }
        */
    }
}

//2.Да се имплемeнтира следната функция, която премахва еднаквите елементи от списък. Т.е. списъка съдържа само различни елементи.

extension List where T: Hashable {
    func toSet() {
        var curr: List<T>? = self
        var result: [T] = []

        while curr != nil {
            let elem = curr!.value

            if !result.contains(elem) {
                result.append(elem)
            }
            curr = curr!.next
        }
        
        curr = self

        for (index, elem) in result.enumerated() {
            curr!.value = elem
            if index == result.count - 1 {
                curr!.next = nil
            } else {
                curr = curr!.next
            }
        }
    }
}

//3.Да се имплемeнтира функция, която от списък от вложени списъци (може да решите задачата и за произволно ниво на влагане) генерира списък с всички елементи.

extension List {
    func flatten() -> List {
        return self
    }
}

/*
Пример:
List<Any>(List<Int>(2, 2), 21, List<Any>(3, List<Int>(5, 8))).flatten()
List<Int>(2, 2, 21, 3, 5, 8)
*/

/*
var l = List<Int>(2, 2, 21, 3, 5, 8)
l.content()
print(l.length)
if let elem = l[5] { print(elem) }
l.reverse()
l.content()

var l2 = List<Int>(1, 4, 2, 2, 6, 24, 15, 2, 60, 15, 6)
l2.content()
l2.toSet()
l2.content()

var l3 = List<Any>(List<Int>(2, 3), 21, List<Int>(6, 7, 9))
l3.content()

var l4 = List<Any>(List<Int>(2, 2), 21, List<Any>(3, List<Int>(5, 8))).flatten()
l4.content()
*/