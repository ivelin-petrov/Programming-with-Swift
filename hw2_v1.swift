protocol Fillable {
    var color: String { set get }
}

protocol VisualComponent: Fillable {
    //минимално покриващ правоъгълник
    var boundingBox: Rect { get }
    var parent: VisualComponent? { set get }
    func draw()
}

protocol VisualGroup: VisualComponent {
    //броят деца
    var numChildren: Int { get }
    //списък от всички деца
    var children: [VisualComponent] { get }
    //добавяне на дете
    func add(child: VisualComponent)
    //премахване на дете
    func remove(child: VisualComponent)
    //премахване на дете от съответния индекс - 0 базиран
    func removeChild(at: Int)
}

struct Point {
    var x: Double
    var y: Double
}

infix operator ==
func == (left: Point, right: Point) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}
    
struct Rect {
    //top-left
    var top: Point
    var width: Double
    var height: Double
        
    init(x: Double, y: Double, width: Double, height: Double) {
        top = Point(x: x, y: y)
        self.width = width
        self.height = height
    }
}

//task1

struct Triangle: VisualComponent {
    var a: Point
    var b: Point
    var c: Point

    var _color: String = "black"
    var color: String {
        set (newColor) {
            if newColor.count <= 2 {
                self._color = "white"
            } else {
                self._color = newColor
            }
        }
        
        get {
            return self._color
        }
    }

    var boundingBox: Rect {
        let maxX = max(a.x,b.x,c.x)
        let minX = min(a.x,b.x,c.x)
        let maxY = max(a.y,b.y,c.y)
        let minY = min(a.y,b.y,c.y)
        return Rect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
    }

    var _parent: VisualComponent? = nil
    var parent: VisualComponent? {
        set (newVC) {
            self._parent = newVC
        }

        get {
            return self._parent
        }
    }

    init(a: Point, b: Point, c: Point, color: String) {
        self.a = a
        self.b = b
        self.c = c
        self.color = color
    }

    func draw(){
        print("Triangle")
    }
}

struct Rectangle: VisualComponent {
    var x: Int
    var y: Int
    var width: Int
    var height: Int

    var _color: String = "black" 
    var color: String {
        set (newColor) {
            if newColor.count <= 2 {
                self._color = "white"
            } else {
                self._color = newColor
            }
        }

        get {
            return self._color
        }
    }

    var boundingBox: Rect {
        return Rect(x: Double(x), y: Double(y), width: Double(width), height: Double(height))
    }

    var _parent: VisualComponent? = nil
    var parent: VisualComponent? {
        set (newVC) {
            self._parent = newVC
        }

        get {
            return self._parent
        }
    }

    init(x: Int, y: Int, width: Int, height: Int, color: String) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.color = color
    }

    func draw(){
        print("Rectangle")
    }
}

struct Circle: VisualComponent {
    var x: Int
    var y: Int
    var r: Double

    var _color: String = "black" 
    var color: String {
        set (newColor) {
            if newColor.count <= 2 {
                self._color = "white"
            } else {
                self._color = newColor
            }
        }

        get {
            return self._color
        }
    }

    var boundingBox: Rect {
        return Rect(x: Double(x), y: Double(y), width: 2*r, height: 2*r)
    }

    var _parent: VisualComponent? = nil
    var parent: VisualComponent? {
        set (newVC) {
            self._parent = newVC
        }

        get {
            return self._parent
        }
    }

    init(x: Int, y: Int, r: Double, color: String) {
        self.x = x
        self.y = y
        self.r = r
        self.color = color
    }

    func draw(){
        print("Circle")
    }
}

struct Path: VisualComponent {
    var points: [Point]

    var _color: String = "black" 
    var color: String {
        set (newColor) {
            if newColor.count <= 2 {
                self._color = "white"
            } else {
                self._color = newColor
            }
        }

        get {
            return self._color
        }
    }

    var boundingBox: Rect {
        var maxX = points[0].x
        var minX = points[0].x
        var maxY = points[0].y
        var minY = points[0].y

        for elem in points {
            if elem.x > maxX { maxX = elem.x }
            if elem.x < minX { minX = elem.x }
            if elem.y > maxY { maxY = elem.y }
            if elem.y < minY { minY = elem.y }
        }

        return Rect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
    }

    var _parent: VisualComponent? = nil
    var parent: VisualComponent? {
        set (newVC) {
            self._parent = newVC
        }

        get {
            return self._parent
        }
    }

    init(points: [Point], color: String) {
        self.points = points
        self.color = color
    }

    func draw(){
        print("Path")
    }
}

class HStack: VisualGroup {
    //броят деца
    var numChildren: Int = 0
    //списък от всички деца
    var children: [VisualComponent] = []

    var _color: String = "transparent" 
    var color: String {
        set (newColor) {
            if newColor.count <= 2 {
                self._color = "transparent"
            } else {
                self._color = newColor
            }
        }

        get {
            return self._color
        }
    }

    var boundingBox: Rect {
        if numChildren == 0 {
            return Rect(x: 0, y: 0, width: 0, height: 0)
        }

        var w : Double = 0
        var maxH : Double = children[0].boundingBox.height

        for child in children {
            w = w + child.boundingBox.width
            
            if child.boundingBox.height > maxH {
                maxH = child.boundingBox.height
            }
        }

        return Rect(x: children[0].boundingBox.top.x, y: children[0].boundingBox.top.y, width: w, height: maxH)
    }

    var _parent: VisualComponent? = nil
    var parent: VisualComponent? {
        set (newVC) {
            self._parent = newVC
        }

        get {
            return self._parent
        }
    }

    init() {}

    //добавяне на дете
    func add(child: VisualComponent) {
        self.children.append(child)

        if numChildren > 0 {
            let tmp = self.children[numChildren]
            self.children[numChildren - 1].parent = tmp
        }

        numChildren = numChildren + 1
    }

    //премахване на дете
    func remove(child: VisualComponent) {
        for (i, c) in self.children.enumerated() {
            if (c.boundingBox.top == child.boundingBox.top) && 
               (c.boundingBox.width == child.boundingBox.width) && 
               (c.boundingBox.height == child.boundingBox.height) &&
               (c.color == child.color){
                if i == (numChildren - 1) {
                    self.children[i - 1].parent = nil
                } else if i != 0 {
                    let tmp = self.children[i].parent
                    self.children[i-1].parent = tmp
                }

                self.children.remove(at: i)
                numChildren = numChildren - 1
                break
            }
        }
    }

    //премахване на дете от съответния индекс - 0 базиран
    func removeChild(at: Int) {
        if(at >= 0 && at < numChildren){
            if at == (numChildren - 1) {
                self.children[at-1].parent = nil
            } else if at != 0 {
                let tmp = self.children[at].parent
                self.children[at-1].parent = tmp
            }

            self.children.remove(at: at)
            numChildren = numChildren - 1
        }
    }

    func draw(){
        for child in children {
            child.draw()
        }
    }
}

class VStack: VisualGroup {
    //броят деца
    var numChildren: Int = 0
    //списък от всички деца
    var children: [VisualComponent] = []

    var _color: String = "transparent" 
    var color: String {
        set (newColor) {
            if newColor.count <= 2 {
                self._color = "transparent"
            } else {
                self._color = newColor
            }
        }

        get {
            return self._color
        }
    }

    var boundingBox: Rect {
        if numChildren == 0 {
            return Rect(x: 0, y: 0, width: 0, height: 0)
        }

        var maxW : Double = children[0].boundingBox.width
        var h : Double = 0

        for child in children {
            h = h + child.boundingBox.height
            
            if child.boundingBox.width > maxW {
                maxW = child.boundingBox.width
            }
        }

        return Rect(x: children[0].boundingBox.top.x, y: children[0].boundingBox.top.y, width: maxW, height: h)
    }

    var _parent: VisualComponent? = nil
    var parent: VisualComponent? {
        set (newVC) {
            self._parent = newVC
        }

        get {
            return self._parent
        }
    }

    init() {}

    //добавяне на дете
    func add(child: VisualComponent) {
        self.children.append(child)

        if numChildren > 0 {
            let tmp = self.children[numChildren]
            self.children[numChildren - 1].parent = tmp
        }
        
        numChildren = numChildren + 1
    }

    //премахване на дете
    func remove(child: VisualComponent) {
        for (i, c) in self.children.enumerated() {
            if (c.boundingBox.top == child.boundingBox.top) && 
               (c.boundingBox.width == child.boundingBox.width) && 
               (c.boundingBox.height == child.boundingBox.height) &&
               (c.color == child.color){
                if i == (numChildren - 1) {
                    self.children[i - 1].parent = nil
                } else if i != 0 {
                    let tmp = self.children[i].parent
                    self.children[i-1].parent = tmp
                }

                self.children.remove(at: i)
                numChildren = numChildren - 1
                break
            }
        }
    }

    //премахване на дете от съответния индекс - 0 базиран
    func removeChild(at: Int) {
        if(at >= 0 && at < numChildren){
            if at == (numChildren - 1) {
                self.children[at-1].parent = nil
            } else if at != 0 {
                let tmp = self.children[at].parent
                self.children[at-1].parent = tmp
            }

            self.children.remove(at: at)
            numChildren = numChildren - 1
        }
    }

    func draw(){
        for child in children {
            child.draw()
        }
    }
}

class ZStack: VisualGroup {
    //броят деца
    var numChildren: Int = 0
    //списък от всички деца
    var children: [VisualComponent] = []

    var _color: String = "transparent" 
    var color: String {
        set (newColor) {
            if newColor.count <= 2 {
                self._color = "transparent"
            } else {
                self._color = newColor
            }
        }

        get {
            return self._color
        }
    }

    var boundingBox: Rect {
        if numChildren == 0 {
            return Rect(x: 0, y: 0, width: 0, height: 0)
        }

        var w : Double = 0
        var h : Double = 0

        var topX : Double = children[0].boundingBox.top.x
        var topY : Double = children[0].boundingBox.top.y
        var bottomX : Double = children[0].boundingBox.top.x + children[0].boundingBox.width 
        var bottomY : Double = children[0].boundingBox.top.y + children[0].boundingBox.height 

        for c in children {
            let crrX = c.boundingBox.top.x
            let crrY = c.boundingBox.top.y
            let crrBottomX = c.boundingBox.top.x + c.boundingBox.width
            let crrBottomY = c.boundingBox.top.y + c.boundingBox.height

            if topX > crrX {
                w = w + abs(topX - crrX)
                topX = crrX
            }
            if bottomX < crrBottomX {
                w = w + abs(crrBottomX - bottomX)
                bottomX = crrBottomX
            }
            if topY > crrY {
                h = h + abs(crrY - topY)
                topY = crrY
            }
            if bottomY < crrBottomY {
                h = h + abs(bottomY - crrBottomY)
                bottomY = crrBottomY
            }
        }

        return Rect(x: topX, y: topY, width: bottomX - topX, height: bottomY - topY)
    }

    var _parent: VisualComponent? = nil
    var parent: VisualComponent? {
        set (newVC) {
            self._parent = newVC
        }

        get {
            return self._parent
        }
    }

    init() {}

    //добавяне на дете
    func add(child: VisualComponent) {
        self.children.append(child)

        if numChildren > 0 {
            let tmp = self.children[numChildren]
            self.children[numChildren - 1].parent = tmp
        }
        
        numChildren = numChildren + 1
    }

    //премахване на дете
    func remove(child: VisualComponent) {
        for (i, c) in self.children.enumerated() {
            if (c.boundingBox.top == child.boundingBox.top) && 
               (c.boundingBox.width == child.boundingBox.width) && 
               (c.boundingBox.height == child.boundingBox.height) &&
               (c.color == child.color){
                if i == (numChildren - 1) {
                    self.children[i - 1].parent = nil
                } else if i != 0 {
                    let tmp = self.children[i].parent
                    self.children[i-1].parent = tmp
                }

                self.children.remove(at: i)
                numChildren = numChildren - 1
                break
            }
        }
    }

    //премахване на дете от съответния индекс - 0 базиран
    func removeChild(at: Int) {
        if(at >= 0 && at < numChildren){
            if at == (numChildren - 1) {
                self.children[at-1].parent = nil
            } else if at != 0 {
                let tmp = self.children[at].parent
                self.children[at-1].parent = tmp
            }

            self.children.remove(at: at)
            numChildren = numChildren - 1
        }
    }

    func draw(){
        for child in children {
            child.draw()
        }
    }
}

//task2

func typeStack(of: VisualComponent) -> Bool {
    return (type(of: of) == HStack.self) ||
           (type(of: of) == VStack.self) || 
           (type(of: of) == ZStack.self)
}

func depth(root: VisualComponent?, num: inout Int) {
    if let root = root {
        if typeStack(of: root) {
            if let rootVG : VisualGroup = root as? VisualGroup {
                var count : Int = 0

                for c in rootVG.children {
                    if typeStack(of: c) {
                        count = count + 1
                    }
                }
                
                count == 0 ? (num = num + 1) : (num = num + 1 - (count - 1))

                for c in rootVG.children {
                    depth(root: c, num: &num)
                }
            }
        } else {
            depth(root: root.parent, num: &num)
        }
    }
}


func depth(root: VisualComponent?) -> Int {
    var num = 0
    
    depth(root: root, num: &num)

    return num
}

//task3

func count(root: VisualComponent?, color: String, num: inout Int) {
    if let root = root {
        if (type(of: root) == HStack.self) ||
           (type(of: root) == VStack.self) || 
           (type(of: root) == ZStack.self) {
            if let rootVG : VisualGroup = root as? VisualGroup {
                if rootVG.color == color {
                    num = num + 1
                }

                for c in rootVG.children {
                    count(root: c, color: color, num: &num)
                }
            }    
        } else {
            if root.color == color {
                num = num + 1
            }

            return count(root: root.parent, color: color, num: &num)
        }
    }
}

func count(root: VisualComponent?, color: String) -> Int {
    var num = 0
    
    count(root: root, color: color, num: &num)

    return num
}

//task4

func cover(root: VisualComponent?) -> Rect {
    if let root = root {
        return root.boundingBox
    }

    return Rect(x:0,y:0,width:0,height:0)
}

// Examples:

//task1
/*
let t = Triangle(a: Point(x:1, y:4), b: Point(x:3, y:2), c: Point(x:5, y:5), color: "red")
let r = Rectangle(x: 0, y: 0, width: 3, height: 5, color: "yellow")
let c = Circle(x: 1, y: 1, r: 3, color: "green")
let p = Path(points: [Point(x:1,y:2), Point(x:0,y:2), Point(x:3,y:5), Point(x:4,y:4)], color: "blue")

var h = HStack()
h.add(child: r)
h.add(child: c)

var v = VStack()
v.add(child: c)

let c1 = Circle(x: 1, y: 1, r: 1, color: "yellow")
let r1 = Rectangle(x: 0, y: 0, width: 1, height: 1, color: "grey")
let r2 = Rectangle(x: 1, y: 1, width: 1, height: 1, color: "red")
let r3 = Rectangle(x: 2, y: 1, width: 1, height: 1, color: "blue")

var z = ZStack()
z.add(child: c1)
z.add(child: r1)
z.add(child: r2)
z.add(child: r3)
print(z.boundingBox)
*/

//task2
/*
var h = HStack()
var v = VStack()
var z = ZStack()

let c1 = Circle(x:1,y:1,r:1,color:"white")
let c2 = Circle(x:2,y:2,r:2,color:"green")
let c3 = Circle(x:3,y:3,r:3,color:"red")
let c4 = Circle(x:4,y:4,r:4,color:"blue")
let r1 = Rectangle(x:0,y:0,width:5,height:5,color:"yellow")

v.add(child:r1)
v.add(child:c4)

z.add(child:c3)
z.add(child:v)

h.add(child:z)
h.add(child:c1)
h.add(child:c2)

print(depth(root:h))
*/

//task3
/*
var h = HStack()
h.color = "red"
var v = VStack()
var z = ZStack()

let c1 = Circle(x:1,y:1,r:1,color:"red")
let c2 = Circle(x:2,y:2,r:2,color:"red")
let c3 = Circle(x:3,y:3,r:3,color:"green")
let c4 = Circle(x:4,y:4,r:4,color:"blue")
let r1 = Rectangle(x:0,y:0,width:5,height:5,color:"yellow")

v.add(child:c1)

z.add(child:c2)
z.add(child:c3)
z.add(child:c4)
z.add(child:r1)

h.add(child:v)
h.add(child:z)

print(count(root:h,color:"red"))
*/

//task4
/*
var h = HStack()
var v = VStack()

let c1 = Circle(x:0,y:0,r:1,color:"yellow")
let c2 = Circle(x:0,y:0,r:1,color:"orange")

v.add(child:c1)
v.add(child:c2)

h.add(child:v)

print(cover(root:h))
*/
