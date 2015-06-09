
// EX 4.1
//IShape s1 = new Square(new CarPt(20, 50), 30);
//IShape c1 = new Circle(new CarPt(0,0), 20);
//IShape d1 = new Dot(new CarPt(100, 200));

/*****************************************************************************/

// EX 4.2
// REPRESENTS: A bank account
interface Account {
    
}

// REPRESENTS: A checking account
class CheckingAccount implements Account {
    int id;
    String name;
    int minBalance; // minimum balance
    int balance;
    
    public CheckingAccount(int id, String name, int minBalance, int balance) {
        this.id = id;
        this.name = name;
        this.minBalance = minBalance;
        this.balance = balance;
    }
}

// REPRESENTS: A savings account
class SavingsAccount implements Account {
    int id;
    String name;
    double rate; // interest rate;
    int balance;
    
    public SavingsAccount(int id, String name, double rate, int balance) {
        this.id = id;
        this.name = name;
        this.rate = rate;
        this.balance = balance;
    }
}

// REPRESENTS: A certificate of deposit
class CD implements Account {
    int id;
    String name;
    double rate; // interest rate
    Date d; // maturity date
    int balance;
    
    CD(int id, String name, double rate, Date d, int balance) {
        this.id = id;
        this.name = name;
        this.rate = rate;
        this.d = d;
        this.balance = balance;
    }
}

class Date {
    int year;
    int month;
    int day;
    int balance;
    
    Date(int year, int month, int day) {
        this.year = year;
        this.month = month;
        this.day = day;
    }
}

class AccountExamples {
    Date d1 = new Date(2005, 6, 1);
    
    Account a1 = new CheckingAccount(1729, "Earl Gray", 500, 1250);
    Account a2 = new CD(4104, "Ima Flatt", 0.04, d1, 10123);
    Account a3 = new SavingsAccount(2992, "Annie Proulx", 0.035, 800);
}


/*****************************************************************************/
// EX 4.6
interface ITaxiVehicle {
    
}

class Cab implements ITaxiVehicle {
    int idNum;
    int passengers;
    int pricePerMile;
    
    Cab(int idNum, int passengers, int pricePermile) {
        this.idNum = idNum;
        this.passengers = passengers;
        this.pricePerMile = pricePermile;
    }
}

class Limo implements ITaxiVehicle {
    int minRental;
    int idNum;
    int passengers;
    int pricePerMile;
    
    Limo(int minRental, int idNum, int passengers, int pricePerMile) {
        this.minRental = minRental;
        this.idNum = idNum;
        this.passengers = passengers;
        this.pricePerMile = pricePerMile;
    }
}

class Van implements ITaxiVehicle {
    boolean access;
    int idNum;
    int passengers;
    int pricePerMile;
    
    Van(boolean access, int passengers, int pricePerMile) {
        this.access = access;
        this.passengers = passengers;
        this.pricePerMile = pricePerMile;
    }
}


/*****************************************************************************/