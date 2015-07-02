// EX 11.2
import tester.Tester;

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
    
    // RETURNS: true iff today's high and low were within the normal range
    public boolean withinRange() {
        return this.today.withinRange(this.normal);
    }
    
    // RETURNS: true iff this day's temperature broke either the high or the
    // low record
    public boolean recordDay() {
        return this.today.breakRecord(this.record);        
    }
}

// REPRESENTS: A date
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

// REPRESENTS: A temperature range
class TemperatureRange {
    int high;
    int low;
    
    public TemperatureRange(int low, int high) {
        this.high = high;
        this.low = low;
    }
    
    // RETURNS: true iff this TemperatureRange is within the given range
    public boolean withinRange(TemperatureRange that) {
        return that.low <= this.low && this.low <= this.high && 
                this.high <= that.high;
    }
    
    // RETURNS: true iff this temperature range broke either the high or the
    // low record of the given range 
    public boolean breakRecord(TemperatureRange that) {
        return this.low < that.low || this.high > that.high;
    }    
}

// tests for WeatherRecord
class WeatherRecordExamples {
    Date d1 = new Date(11, 6, 2015);
    
    TemperatureRange t1 = new TemperatureRange(20, 30);
    TemperatureRange t2 = new TemperatureRange(21, 31);
    TemperatureRange t3 = new TemperatureRange(18, 31);
    
    WeatherRecord wr1 = new WeatherRecord(d1, t1, t2, t3);
    WeatherRecord wr2 = new WeatherRecord(d1, t2, t1, t3);
    WeatherRecord wr3 = new WeatherRecord(d1, t1, t3, t2);
    
    // tests for method withinRange()
    boolean testWithinRange(Tester t) {
        return
        // for TemperatureRange class
        t.checkExpect(t1.withinRange(t2),false) &&
        t.checkExpect(t1.withinRange(t1), true) &&
        t.checkExpect(t1.withinRange(t3)) &&
        // for WeatherRecord class
        t.checkExpect(wr1.withinRange(), false) &&
        t.checkExpect(wr2.withinRange(), false) &&
        t.checkExpect(wr3.withinRange(), true);
    }
    
    // tests for method recordDay()
    boolean testRecordDay(Tester t) {
        return t.checkExpect(wr1.recordDay(), false) && 
               t.checkExpect(wr3.recordDay(), true);
       
    }
    
}