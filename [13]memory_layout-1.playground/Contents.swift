import UIKit
/*:
 ### alignment/size/stride
 * alignment:字节对齐属性，它要求当前数据类型相对于起始位置的偏移必须是alignment的整数倍。
 * size: 一个 T 数据类型实例占用连续内存字节的大小
 * stride: 在一个 T 类型的数组中，其中任意一个元素从开始地址到结束地址所占用的连续内存字节的大小就是 stride。
 ![20170720094004549.jpg](20170720094004549.jpg)
 
 Swift提供了MemoryLayout类静态测量对象大小， 注意是在编译时确定的，不是运行时哦！
 */

class Person {}

//值类型
MemoryLayout<Bool>.size
MemoryLayout<Bool>.alignment
MemoryLayout<Bool>.stride

MemoryLayout<Int>.size
MemoryLayout<Int>.alignment
MemoryLayout<Int>.stride

MemoryLayout<Int?>.size
MemoryLayout<Int?>.alignment
MemoryLayout<Int?>.stride

MemoryLayout<Double>.size
MemoryLayout<Double>.alignment
MemoryLayout<Double>.stride

MemoryLayout<String>.size
MemoryLayout<String>.alignment
MemoryLayout<String>.stride

//引用类型 T
MemoryLayout<Person>.size
MemoryLayout<Person>.alignment
MemoryLayout<Person>.stride

// withUnsafeBytes(of: &t)   { print($0) } 与下面相同
func printAddress<T>(varible: String = "", of pointer: UnsafePointer<T>) {
    // 打印十六进制和十进制
    print("\(pointer) \(Int(bitPattern: pointer)) \(MemoryLayout<T>.stride) \(MemoryLayout<T>.size) \(pointer.pointee) <-- \(varible) ")
}

struct Me {
    let age: Int = 22            // 8
    let height: Double = 180.0   // 8
    let name: String = "XiangHui"// 16
    var hasGirlFriend: Bool?     // 1
}

func test() {
    var a = 134
    var cpa = a
    printAddress(varible: "a", of: &a)
    printAddress(varible: "cpa", of: &cpa)
    
    var b = "JoJoJoJoJoJoJoJoJoJoJoJoJoJoJoJoJoJoJoJo"
    var cpb = b
    print("b.count \(b.utf8.count)")
    printAddress(varible: "b", of: &b)
    printAddress(varible: "cpb", of: &cpb)
    
    var me = Me()
    var secondMe = me
    printAddress(varible: "me", of: &me)
    printAddress(varible: "secondMe", of: &secondMe)
    
    var likes = ["comdy", "animation", "movies"]
    var cpLikes = likes
    printAddress(varible: "likes", of: &likes)
    printAddress(varible: "cpLikes", of: &cpLikes)
}
test()



struct S {
    var x:Int64
    var flag: Bool
    var y:Int32
}
struct SReverse {
    var y:Int32
    var flag = false
    var x:Int64
}

var s = S(x: 23, flag: false, y: 23)
var sr = SReverse(y: 23, flag: false, x: 43)
printAddress(varible: "s", of: &s)
printAddress(varible: "sr", of: &sr)


MemoryLayout<S>.size
MemoryLayout<S>.stride
MemoryLayout<S>.alignment
MemoryLayout<SReverse>.size
MemoryLayout<SReverse>.stride
MemoryLayout<SReverse>.alignment

MemoryLayout.size(ofValue: s)
MemoryLayout.stride(ofValue: s)


/*
func address(_ o: UnsafeRawPointer) -> Int {
    return Int(bitPattern: o)
}

func addressHeap<T: AnyObject>(_ o: T) -> Int {
    return unsafeBitCast(o, to: Int.self)
}


struct myStruct {
    var a: Int
}

class myClas {
    
}
//struct
var struct1 = myStruct(a: 5)
var struct2 = struct1
print(NSString(format: "%p", address(&struct1))) // -> "0x10f1fd430\n"
print(NSString(format: "%p", address(&struct2))) // -> "0x10f1fd438\n"

//String
var s = "A String"
var aa = s
print(NSString(format: "%p", address(&s))) // -> "0x10f43a430\n"
print(NSString(format: "%p", address(&aa))) // -> "0x10f43a448\n"

//Class
var class1 = myClas()
var class2 = class1
print("class")
//print(NSString(format: "%p", addressHeap(class1)))
//print(NSString(format: "%p", addressHeap(class2)))

print(NSString(format: "%p", address(&class1)))
print(NSString(format: "%p", address(&class2)))

withUnsafePointer(to: class1) { print("\($0)") }
withUnsafePointer(to: class2) { print("\($0)") }

print("\(Unmanaged.passUnretained(class1).toOpaque())")
print("\(Unmanaged.passUnretained(class2).toOpaque())")

//Int
var num1 = 55
var num2 = num1
print("Int")
print(NSString(format: "%p", address(&num1))) // -> "0x10f1fd480\n"
print(NSString(format: "%p", address(&num2))) // -> "0x10f1fd488\n"
withUnsafePointer(to: num1) { print("\($0)") }
withUnsafePointer(to: num2) { print("\($0)") }


do {
    struct myNewStruct {
        
    }
    
    var struct1 = myNewStruct()
    var struct2 = struct1
    print(NSString(format: "%p", address(&struct1)))
    print(NSString(format: "%p", address(&struct2)))
}

do {
    var ary1 = [1, 3]
    var ary2 = ary1
    ary1.append(4)
    print(NSString(format: "%p", address(&ary1)))
    print(NSString(format: "%p", address(&ary2)))
}
 */

