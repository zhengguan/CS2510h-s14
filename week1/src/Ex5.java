// EX 5.2
//Date d1 = new Date(15, 6, 2004);
//Date d2 = new Date(16, 6, 2004);
//Date d3 = new Date(23, 6, 2004);
//Date d4 = new Date(28, 6, 2004);
//
//Entry e1 = new Entry(d1, 15.3, 87, "feeling great");
//Entry e2 = new Entry(d2, 12,8, 84, "feeling good");
//Entry e3 = new Entry(d3, 26.2, 250, "feeling dead");
//Entry e4 = new Entry(d4, 26.2, 150, "good recovery");
//
//ILog l0 = new MTLog();
//ILog l1 = new ConsLog(e1, l0);
//ILog l2 = new ConsLog(e2, l1);
//ILog l3 = new ConsLog(e3, l2);
//ILog l4 = new ConsLog(e4, l3);

/*****************************************************************************/
// EX 5.3

interface ILoHouse {
    
}

class MTLoHouse implements ILoHouse{
    
}

class ConsLoHouse implements ILoHouse{
    House fst;
    ILoHouse rest;
    
    ConsLoHouse(House fst, ILoHouse rest) {
        this.fst = fst;
        this.rest = rest;
    }
}

class ILoHouseExamples {
    Address ad1 = new Address(23, "Maple Street", "BrookLine");
    Address ad2 = new Address(5, "Joye Road", "Newton");
    Address ad3 = new Address(83, "Winslow Road", "Waltham");
    
    House h1 = new House("Ranch", 7, 274000, ad1);
    House h2 = new House("Colonial", 9, 450000, ad2);
    House h3 = new House("Cape", 6, 235000, ad3);
    
}

/*****************************************************************************/
// EX 5.5
// REPRESENTS: weather record
interface IWR {

}

class MTWR implements IWR {
    
}

class ConsWR implements IWR {
    IWR rst;
    WeatherRecord fst;
    
    ConsWR(IWR rst, WeatherRecord fst) {
        this.rst = rst;
        this.fst = fst;
    }
}

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

class TemperatureRange {
    int high;
    int low;
    
    
    TemperatureRange(int high, int low) {
        this.high = high;
        this.low = low;
    }
}

class Date {
    int day;
    int month;
    int year;
    
    Date(int day, int month, int year) {
        this.day = day;
        this.month = month;
        this.year = year;
    }
}

class IWRExamples {
    Date d = new Date(8, 6, 2015);
    
    TemperatureRange shanghaiNormal = new TemperatureRange(25, 21);
    TemperatureRange shanghaiToday = new TemperatureRange(24, 21);
    TemperatureRange shanghaiRecord = new TemperatureRange(24, 22);
    
    TemperatureRange wenzhouNormal = new TemperatureRange(31, 24);
    TemperatureRange wenzhouToday = new TemperatureRange(31, 26);
    TemperatureRange wenzhouRecord = new TemperatureRange(31, 24);
    
    WeatherRecord shanghai = new WeatherRecord(d, shanghaiToday, 
            shanghaiNormal, shanghaiRecord);
    WeatherRecord wenzhou = new WeatherRecord(d, wenzhouToday, 
            wenzhouNormal, wenzhouRecord);
    
    
    IWR weatherList = new ConsWR(new ConsWR(new MTWR(), shanghai), wenzhou); 
}