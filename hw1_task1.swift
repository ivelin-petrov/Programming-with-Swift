//task1

func countFolders(paths: [String]) -> Int {
    if paths.isEmpty {
        return -1
    }
 
    let sortedPaths : [String] = paths.sorted(){ $0 < $1 }
    var result : Int = 0

    for (index, item) in sortedPaths.enumerated() {
        if item.prefix(1) != "/"{
            continue
        }

        if !item.contains(".") {
            result += 1
            continue
        }

        let i = item.lastIndex(of: "/")
        if let i = i {
            var body : String = item
            body.removeSubrange(body.startIndex..<i)
            body.removeFirst() // removes the last "/"

            if body.isEmpty {
                result += 1
            } else {
                if !body.contains(".") {
                    result += 1
                } else {
                    let j = body.lastIndex(of: ".")
                    if let j = j {
                        var tail : String = body
                        tail.removeSubrange(tail.startIndex..<j)
                        tail.removeFirst()

                        if !tail.isEmpty{
                            for k in (index+1)..<sortedPaths.count {
                                if sortedPaths[k].prefix(item.count + 1) == item + "/" {
                                    result += 1
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return result
}

/*
print(countFolders(paths: ["/", "/games", "/games/socoban", "/games/socoban/socoban.app"]))
print(countFolders(paths: ["/", "/g.a.m.e.s/socoban.folder", "/g.a.m.e.s/"]))

print(countFolders(paths: ["/", "/C/games/gtaV/gtaV.exe", "/C/", "/C/games/gtaV", "/C/games/gtaV.rar", "/C/games/"]))
print(countFolders(paths: ["/", "/C/games/gtaV/gtaV.rar/gtaV.exe", "/C/", "/C/games/gtaV", "/C/games/gtaV/gtaV.rar", "/C/games/"]))

print(countFolders(paths: ["/C/games/gtaV/gtaV.exe", "/C/games/gtaV", "/C/games/gtaV.rar"]))
print(countFolders(paths: ["/C/games/gtaV/gtaV.rar/gtaV.exe", "/C/games/gtaV", "/C/games/gtaV/gtaV.rar", "/C/games/"]))

print(countFolders(paths: [""]))
print(countFolders(paths: []))

print(countFolders(paths: ["/.", "/./"]))
*/
