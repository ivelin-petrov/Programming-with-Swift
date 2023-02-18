//task2

infix operator ^
func ^ (left: Double, right: Int) -> Double {
    if(right <= 0){
        return -1
    }

    var result = left
    for _ in 1..<right { // 1...right
        result *= left
    }

    return result
}

func apply(a: Double, op: Character, b: Double) -> Double {
    switch op {
        case "+": return a+b
        case "-": return a-b
        case "*": return a*b
        case "/": return a/b
        case "^": return a^Int(b)
        default: return 0
    }
}

func evaluate(e: inout String) -> Double {
    //base
    let index = e.firstIndex(where: {$0 == " " || $0 == ")"}) ?? e.endIndex
    let number : Double? = Double(e[..<index])

    if let number = number {
        e.removeSubrange(e.startIndex..<index)
        return number
    }

    //remove "("
    e.remove(at: e.startIndex)

    //left expression
    let left : Double = evaluate(e: &e)
    
    //remove " "
    e.remove(at: e.startIndex)

    //get operator
    let op = e[e.startIndex]
    //remove operator
    e.remove(at: e.startIndex)
    
    //remove " "
    e.remove(at: e.startIndex)

    //right expression
    let right : Double = evaluate(e: &e)
    
    //remove ")"
    e.remove(at: e.startIndex)
    
    return apply(a: left, op: op, b: right)
}

func evaluate(expression: String) -> Double {
    var exp = expression
 	return evaluate(e: &exp)
}

//print(evaluate(expression: "((50 + 3) / 2)"))
//print(evaluate(expression: "((23 + 6) * 2)"))