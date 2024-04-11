struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency.uppercased()
    }
    
    func convert(_ newCurrency: String) -> Money {
        let newCurrencyUp = newCurrency.uppercased()
        let conversionRates = ["USD": 1.0, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
        guard let original = conversionRates[currency], let new = conversionRates[newCurrency.uppercased()] else { return Money(amount: 0, currency: newCurrencyUp) }
        let usd = Double(amount) / original
        let convertedValue = usd * new
        return Money(amount: Int(convertedValue), currency: newCurrencyUp)
    }

    func add(_ other: Money) -> Money {
        if self.currency == other.currency {
            return Money(amount: self.amount + other.amount, currency: self.currency)
        } else {
            let convertedSelf = self.convert(other.currency)
            return Money(amount: convertedSelf.amount + other.amount, currency: other.currency)
        }
    }
    
    func subtract(_ other: Money) -> Money {
        if self.currency == other.currency {
            return Money(amount: self.amount - other.amount, currency: self.currency)
        } else {
            let convertedSelf = self.convert(other.currency)
            return Money(amount: convertedSelf.amount - other.amount, currency: other.currency)
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    
    var title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int = 2000) -> Int {
        switch self.type {
        case.Hourly(let wage):
            return Int(Double(hours) * wage)
        case.Salary(let salary):
            return Int(salary)
        }
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case.Hourly(let wage):
            self.type = .Hourly(wage + byAmount)
        case.Salary(let salary):
            self.type = .Salary(UInt(Double(salary) + byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case.Hourly(let wage):
            self.type = .Hourly(wage * (1 + byPercent))
        case.Salary(let salary):
            self.type = .Salary(UInt(Double(salary) * (1 + byPercent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    private var _job: Job?
    private var _spouse: Person?

    var job: Job? {
        get { return _job }
        set {
            if age >= 16 {
                _job = newValue
            } else {
                _job = nil
            }
        }
    }

    var spouse: Person? {
        get { return _spouse }
        set {
            if age >= 18 {
                _spouse = newValue
            } else {
                _spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title ?? "nil") spouse:\(spouse?.firstName ?? "nil")]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [spouse1, spouse2]
    }
    
    func haveChild(_ child: Person) -> Bool {
        if members.contains(where: { $0.age >= 21 }) {
            members.append(child)
            return true
        } else {
            return false
        }
    }
    
    func householdIncome() -> Int {
        return members.compactMap { $0.job?.calculateIncome() }.reduce(0, +)
    }
}
