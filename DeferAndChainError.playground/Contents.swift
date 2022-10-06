import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    func flatMap<U>(transform: (T) -> Result<U>) -> Result<U> {
        switch self {
        case let .success(v):
            return transform(v)
        case let .failure(e):
            return .failure(e)
        }
    }
}

enum CarError: Error {
    case outOfFuel(no: String, fuelInLitre: Double)
    case updateFailed
    case integrationError
}

struct Car {
    var fuelInLitre: Double
    var no: String
    
    static var startCounter = 0
    
    func downloadPackage() -> Result<String> {
        return .failure(CarError.updateFailed)
    }
    
    func checkIntegration(of path: String) -> Result<Int> {
        return .failure(CarError.integrationError)
    }
    
    init(fuelInLitre: Double, no: String) {
        self.fuelInLitre = fuelInLitre
        self.no = no
    }
    
    func start() throws -> String {
        guard fuelInLitre > 5 else {
            throw CarError.outOfFuel(no: no, fuelInLitre: fuelInLitre)
        }
        
        defer { Car.startCounter += 1}
        
        return "Ready to go"
    }
    
    func osUpdate(postUpdate: @escaping (Result<Int>) -> Void) {
        DispatchQueue.global().async {
            let result = self.downloadPackage().flatMap {
                self.checkIntegration(of: $0)
            }
            
            postUpdate(result)
        }
    }
    
    func selfCheck() throws -> Bool {
        _ = try start()
        
        return true
    }
}

Car(fuelInLitre: 10, no: "1").osUpdate {
    switch $0 {
    case let .success(checksum):
        print("Update sucess: \(checksum)")
    case let .failure(e):
        if e is CarError {
            print("checksum error")
        }
        
        print("update failed")
    }
}
