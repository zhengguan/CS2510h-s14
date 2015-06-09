
// EX 3.1
// REPRESENTS: An available house
class House{
    String kind;
    int rooms; // number of rooms
    int price; // the asking price in dollar
    Address addr;
    
    House(String kind, int rooms, int price, Address addr) {
        this.kind = kind;
        this.rooms = rooms;
        this.price = price;
        this.addr = addr;
    }
    
}

// REPRESENTS: An address
class Address {
    int num; // street number
    String name; // street name
    String city; 
    
    Address(int num, String name, String city) {
        this.num = num;
        this.name = name;
        this.city = city;
    }
}

// EX 3.2
// REPRESENTS: A weather record
class WeatherRecord {
    Date d;
    TemperatureRange today;
    TemperatureRange normal;
    TemperatureRange record;
    
    WeatherRecord(Date d, TemperatureRange today, 
            TemperatureRange normal, TemperatureRange record) {
        this.d = d;
        this.today = today;
        this.normal = normal;
        this.record = record;
    }
}

// REPRESENTS: A temperature range
class TemperatureRange {
    int high;
    int low;
    
    public TemperatureRange(int high, int low) {
        this.high = high;
        this.low = low;
    }
}