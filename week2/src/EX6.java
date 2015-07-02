

// EX 6.1

// A LoPackage is either:
// -- MTLoPackage
// -- ConsLoPackage

// REPRESENTS: A list of package information
interface ILoPackage {
    
}

// REPRESENTS: A empty list of package information
class MTLoPackage implements ILoPackage{
    
}


// REPRESENTS: A non-empty list of package information
class ConsLoPackage implements ILoPackage {
    ILoPackage rst; // rest package information
    Package fst; // first package information
    
    ConsLoPackage(Package fst, ILoPackage rst) {
        this.rst = rst;
        this.fst = fst;
    }
}

// REPRESENTS: A package information
class Package {
    double size; // package size in m^3
    double weight; // package weight in kg
    String sender;
    String recipient;
    String url;  // url used to track package
    
    Package(double size, double weight, String sender, 
            String recipient, String url) {
        this.size = size;
        this.weight = weight;
        this.sender = sender;
        this.recipient = recipient;
        this.url = url;
    }
}

class LoPackageExamples {
    Package p1 = new Package(11.1, 12.1, "zgs", "sc", "sc.com");
    Package p2 = new Package(11.2, 20.3, "zgs", "wb", "wb.com");
    
    ILoPackage mtlop = new MTLoPackage();
    ILoPackage lop1 = new ConsLoPackage(p1, mtlop);
    ILoPackage lop2 = new ConsLoPackage(p2, lop1);
}

/******************************************************************************/
// EX 6.3
// REPRESENTS: A schedule
class Schedule {
    String departureStation;
    Time departureTime;
    String destinationStation;
    Time arrivalTime;
    ILoStop stops;  // stops between daparture station and destination station
    
    Schedule(String departureStation, Time departureTime, String destinationStation,
            Time arrivalTime, ILoStop stops) {
        this.departureStation = departureStation;
        this.departureTime = departureTime;
        this.destinationStation = destinationStation;
        this.arrivalTime = arrivalTime;
        this.stops = stops;
    }
}


interface ILoStop {
    
}

class MTLoStop implements ILoStop {
    
}

class ConsLoStop implements ILoStop {
    String fst;   // first stop name
    ILoStop rst; // rest stops
    
    ConsLoStop(String fst, ILoStop rst) {
        this.fst = fst;
        this.rst = rst;
    }
}

class Time {
    int day;
    int hour;
    int minute;
    
    Time(int day, int hour, int minute) {
        this.day = day;
        this.hour = hour;
        this.minute = minute;
    }
}

class ScheduleExamples{
    Time t1 = new Time(20, 9, 42);
    Time t2 = new Time(20, 14, 30);
    
    ILoStop mtLoS = new MTLoStop();
    ILoStop consLoS1 = new ConsLoStop("Hangzhou", mtLoS);
    ILoStop consLoS2 = new ConsLoStop("Jinhua", consLoS1);
    
    Schedule s1 = new Schedule("Shanghai", t1, "Wenzhou", t2, consLoS2);
}

/******************************************************************************/
// EX 6.4
// A House is one of:
// -- SingleFamilyHouse
// -- Condominium
// -- TownHouse

// REPRESENTS: A House
interface IHouse {
    
}

// REPRESENTS: single family house
class SingleFamilyHouse implements IHouse {
    Address address;
    double livingArea;
    int price;
    double landArea;
    int rooms; // number of rooms
    
    SingleFamilyHouse(Address address, double livingArea, int price, 
            double landArea, int rooms) {
        this.address = address;
        this.livingArea = livingArea;
        this.price = price;
        this.landArea = landArea;
        this.rooms = rooms;
    }
}

// REPRESENTS: condominium
class Condominium implements IHouse {
    Address address;
    double livingArea;
    int price;
    int rooms; 
    boolean accessible; // whether it is accessible without climbing stairs
    
    Condominium(Address address, double livingArea, int price, 
            int rooms, boolean accessible) {
        this.address = address;
        this.livingArea = livingArea;
        this.price = price;
        this.rooms = rooms;
        this.accessible = accessible;
    }
}

// REPRESENTS: town house
class TownHouse implements IHouse {
    Address address;
    double livingArea;
    int price;
    int rooms;
    double gardenArea;
    
    TownHouse(Address address, double livingArea, int price, 
            int rooms, double gardenArea) {
        this.address = address;
        this.livingArea = livingArea;
        this.price = price;
        this.rooms = rooms;
        this.gardenArea = gardenArea;
    }
}

class Address {
    int number; // street number
    String name; // street name
    String city;
    
    Address(int number, String name, String city) {
        this.number =  number;
        this.name =  name;
        this.city = city;
    }
}

class HouseExamples {
    Address ad1 = new Address(280, "Huatuo", "Shanghai");
    Address ad2 = new Address(1159, "Cailun", "Shanghai");
    Address ad3 = new Address(119, "Nanhui", "Shanghai");
    
    IHouse h1 = new SingleFamilyHouse(ad1, 200, 10000, 230, 8);
    IHouse h2 = new Condominium(ad2, 20, 1000, 1, true);
    IHouse h3 = new TownHouse(ad3, 100, 4000, 5, 50);
}

