protocol Fillable {
    var color: String { set get }
}

protocol VisualComponent: Fillable {
    //минимално покриващ правоъгълник
    var boundingBox: Rect { get }
    var parent: VisualComponent? { get }
    func draw()
}

protocol VisualGroup: VisualComponent {
    //броят деца
    var numChildren: Int { get }
    //списък от всички деца
    var children: [VisualComponent] { get }
    //добавяне на дете
    mutating func add(child: VisualComponent)
    //премахване на дете
    mutating func remove(child: VisualComponent)
    //премахване на дете от съответния индекс - 0 базиран
    mutating func removeChild(at: Int)
}

struct Point {
    var x: Double
    var y: Double
}

infix operator ==
func == (left: Point, right: Point) -> Bool {
    return (left.x.isEqual(to: right.x)) && (left.y.isEqual(to: right.y))
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

extension Double {    
    func isGreater(than: Double) -> Bool {
        return !self.isLessThanOrEqualTo(than)
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
        let maxX = Double.maximum(Double.maximum(a.x,b.x),c.x)
        let minX = Double.minimum(Double.minimum(a.x,b.x),c.x)
        let maxY = Double.maximum(Double.maximum(a.y,b.y),c.y)
        let minY = Double.minimum(Double.minimum(a.y,b.y),c.y)
        return Rect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
    }

    var parent: VisualComponent? = nil

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

    var parent: VisualComponent? = nil

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

    var parent: VisualComponent? = nil

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
            if elem.x.isGreater(than: maxX) { maxX = elem.x }
            if elem.x.isLess(than: minX) { minX = elem.x }
            if elem.y.isGreater(than: maxY) { maxY = elem.y }
            if elem.y.isLess(than: minY) { minY = elem.y }
        }

        return Rect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
    }

    var parent: VisualComponent? = nil

    init(points: [Point], color: String) {
        self.points = points
        self.color = color
    }

    func draw(){
        print("Path")
    }
}

struct HStack: VisualGroup {
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
            
            if child.boundingBox.height.isGreater(than: maxH) {
                maxH = child.boundingBox.height
            }
        }

        return Rect(x: children[0].boundingBox.top.x, y: children[0].boundingBox.top.y, width: w, height: maxH)
    }

    var parent: VisualComponent? = nil

    init() {}

    //добавяне на дете
    mutating func add(child: VisualComponent) {
        self.children.append(child)
        numChildren = numChildren + 1
    }

    //премахване на дете
    mutating func remove(child: VisualComponent) {
        for (i, c) in self.children.enumerated() {
            if (c.boundingBox.top == child.boundingBox.top) && 
               (c.boundingBox.width.isEqual(to: child.boundingBox.width)) && 
               (c.boundingBox.height.isEqual(to: child.boundingBox.height)) &&
               (c.color == child.color){
                self.children.remove(at: i)
                numChildren = numChildren - 1
                break
            }
        }
    }

    //премахване на дете от съответния индекс - 0 базиран
    mutating func removeChild(at: Int) {
        if(at >= 0 && at < numChildren){
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

struct VStack: VisualGroup {
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
            
            if child.boundingBox.width.isGreater(than: maxW) {
                maxW = child.boundingBox.width
            }
        }

        return Rect(x: children[0].boundingBox.top.x, y: children[0].boundingBox.top.y, width: maxW, height: h)
    }

    var parent: VisualComponent? = nil
    
    init() {}

    //добавяне на дете
    mutating func add(child: VisualComponent) {
        self.children.append(child)
        numChildren = numChildren + 1
    }

    //премахване на дете
    mutating func remove(child: VisualComponent) {
        for (i, c) in self.children.enumerated() {
            if (c.boundingBox.top == child.boundingBox.top) && 
               (c.boundingBox.width.isEqual(to: child.boundingBox.width)) && 
               (c.boundingBox.height.isEqual(to: child.boundingBox.height)) &&
               (c.color == child.color){
                self.children.remove(at: i)
                numChildren = numChildren - 1
                break
            }
        }
    }

    //премахване на дете от съответния индекс - 0 базиран
    mutating func removeChild(at: Int) {
        if(at >= 0 && at < numChildren){
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

struct ZStack: VisualGroup {
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

            if topX.isGreater(than: crrX) {
                w = w + abs(topX - crrX)
                topX = crrX
            }
            if bottomX.isLess(than: crrBottomX) {
                w = w + abs(crrBottomX - bottomX)
                bottomX = crrBottomX
            }
            if topY.isGreater(than: crrY) {
                h = h + abs(crrY - topY)
                topY = crrY
            }
            if bottomY.isLess(than: crrBottomY) {
                h = h + abs(bottomY - crrBottomY)
                bottomY = crrBottomY
            }
        }

        return Rect(x: topX, y: topY, width: bottomX - topX, height: bottomY - topY)
    }

    var parent: VisualComponent? = nil

    init() {}

    //добавяне на дете
    mutating func add(child: VisualComponent) {
        self.children.append(child)
        numChildren = numChildren + 1
    }

    //премахване на дете
    mutating func remove(child: VisualComponent) {
        for (i, c) in self.children.enumerated() {
            if (c.boundingBox.top == child.boundingBox.top) && 
               (c.boundingBox.width.isEqual(to: child.boundingBox.width)) && 
               (c.boundingBox.height.isEqual(to: child.boundingBox.height)) &&
               (c.color == child.color){
                self.children.remove(at: i)
                numChildren = numChildren - 1
                break
            }
        }
    }

    //премахване на дете от съответния индекс - 0 базиран
    mutating func removeChild(at: Int) {
        if(at >= 0 && at < numChildren){
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

// task4

func cover(root: VisualComponent?) -> Rect {
    if let root = root {
        return root.boundingBox
    }

    return Rect(x:0,y:0,width:0,height:0)
}

// Example: 
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