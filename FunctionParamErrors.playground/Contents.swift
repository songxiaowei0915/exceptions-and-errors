import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum CarError: Error {
    case outOfFuel(no: String, fuelInLitre: Double)
    case updateFailed
}

struct Car {
    var fuelInLitre: Double
    var no: String
    
    init(fuelInLitre: Double, no: String) {
        self.fuelInLitre = fuelInLitre
        self.no = no
    }
    
    func osUpdate(postUpdate: @escaping (Result<Int>) -> Void) {
        DispatchQueue.global().async {
            let checksum = 200
            
            if checksum != 200 {
                postUpdate(.failure(CarError.updateFailed))
            }else{
                postUpdate(.success(checksum))
            }
        }
    }
    
    func selfCheck() throws -> Bool {
        _ = try start()
        
        return true
    }
    
    func start() throws -> String {
        guard fuelInLitre > 5 else {
            throw CarError.outOfFuel(no: no, fuelInLitre: fuelInLitre)
        }
        
        return "Ready to go"
    }
}

var vwGroup: [Car] = []

(1 ... 1000).forEach {
    let amount = Double(arc4random_uniform(70))
    vwGroup.append(Car(fuelInLitre: amount, no: "Car-\($0)"))
}

extension Sequence {
    func checkAll(by rule: (Iterator.Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            guard try rule(element) else {
                return false
            }
        }
        
        return true
    }
}

do {
    _ = try vwGroup.checkAll(by: { try $0.selfCheck()})
} catch let CarError.outOfFuel(no: no, fuelInLitre: fuelInLitre) {
    print("\(no) is out of fuel \(fuelInLitre)")
}

vwGroup[0].osUpdate(postUpdate: {
    switch $0 {
    case let .success(message):
        print(message)
    case let .failure(error):
        print(error.localizedDescription)
    }
})

sleep(1)

