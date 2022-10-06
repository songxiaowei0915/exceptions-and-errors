import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum CarError: Error {
    case outOfFuel
}

struct Car {
    var fuleInLitre: Double
    
    func start() throws -> String {
        guard fuleInLitre > 5 else {
            //return .failure(CarError.outOfFule)
            throw CarError.outOfFuel
        }
        
       // return .success("Ready to go")
        return "Ready to go"
    }
}

var vw = Car(fuleInLitre: 2)

//switch vw.start() {
//case let .success(message):
//    print(message)
//case let .failure(error):
//    if let carError = error as? CarError,
//       carError == .outOfFule {
//        print("Cannot start due to out of fuel")
//    }
//    else {
//        print(error.localizedDescription)
//    }
//}

do {
    let message = try vw.start()
    print(message)
} catch CarError.outOfFuel {
    print("Cannot start due to out of fuel")
} catch {
    print("we have something wrong")
}
 

