//task3

func find(matrix: [[String]], symbol: String) -> [Int] {
    for (i, row) in matrix.enumerated() {
        for (j, item) in row.enumerated() {
            if item == symbol {
                return [i, j] 
            }
        }
    }

    return [-1, -1]
}

func isValid(point: [Int], width: Int, height: Int) -> Bool {
    return !(point[0] < 0 || point[1] < 0 || point[0] >= width || point[1] >= height)
}

func isPassable(maze: [[String]], point: [Int]) -> Bool {
    return maze[point[0]][point[1]] != "1" && maze[point[0]][point[1]] != "#"
}

func findPaths(maze: [[String]], visited: inout [[Bool]], x: Int, y: Int, end: [Int], count: inout Int) -> () {
    if x == end[0] && y == end[1] {
        count += 1
        return
    }

    //mark current point as visited
    visited[x][y] = true

    let width : Int = maze.count
    let height : Int = maze[0].count

    if isValid(point: [x, y], width: width, height: height) && isPassable(maze: maze, point: [x, y]) {
        // go down
        if x + 1 < width && !visited[x + 1][y] {
            findPaths(maze: maze, visited: &visited, x: x + 1, y: y, end: end, count: &count)
        }

        // go up
        if x - 1 >= 0 && !visited[x - 1][y] {
            findPaths(maze: maze, visited: &visited, x: x - 1, y: y, end: end, count: &count)
        }

        // go right
        if y + 1 < height && !visited[x][y + 1] {
            findPaths(maze: maze, visited: &visited, x: x, y: y + 1, end: end, count: &count)
        }

        // go left
        if y - 1 >= 0 && !visited[x][y - 1] {
            findPaths(maze: maze, visited: &visited, x: x, y: y - 1, end: end, count: &count)
        }
    }

    // backtrack
    visited[x][y] = false
}

func findPaths(maze: [[String]]) -> Int {
    let width : Int = maze.count
    let height : Int = maze[0].count

    let start : [Int] = find(matrix: maze, symbol: "^")
    let end : [Int] = find(matrix: maze, symbol: "*")

    if height == 0 || width == 0 ||
       !isPassable(maze: maze, point: start) ||
       !isPassable(maze: maze, point: end) {
        return 0
    }

    var row : [Bool] = []
    for _ in 0..<height {
        row.append(false)
    }

    // track the visited path
    var visited : [[Bool]] = []
    for _ in 0..<width {
        visited.append(row)
    }

    var count = 0

    findPaths(maze: maze, visited: &visited, x: start[0], y: start[1], end: end, count: &count)

    return count
}

/*
var testMaze = [
        ["^", "0", "0", "0", "0", "0", "0", "1"],
		["0", "1", "1", "1", "1", "1", "0", "0"],
		["0", "0", "0", "0", "0", "1", "#", "1"],
		["0", "1", "1", "1", "0", "1", "0", "0"],
		["0", "1", "0", "1", "0", "0", "0", "1"],
		["0", "0", "0", "1", "0", "1", "0", "*"]]

var testMaze2 = [
        ["^", "0", "0", "0"],
	    ["0", "0", "1", "0"],
	    ["1", "0", "1", "0"],
	    ["0", "0", "0", "*"]]
*/

//print(findPaths(maze: testMaze))
//print(findPaths(maze: testMaze2))
