// How to Design Class 
// CHAPTER 12
// Exercise

import tester.Tester;
// EX 12.1

interface IShape {
    // to compute the area of this shape
    double area();

    // to compute the distance of
    // this shape to the origin
    double distTo0();

    // is the given point within?
    // the bounds of this shape
    boolean in(CartPt p);

    // compute the bounding box
    // for this shape
    Square bb();
    
    // RETURNS: the perimeter of this shape
    double perimeter();
}


class Dot implements IShape {
    CartPt loc;
    
    Dot(CartPt loc) {
        this.loc = loc;
    }
    
    // to compute the area of this shape
    public double area() {
        return 0;
    }

    // to compute the distance of
    // this shape to the origin
    public double distTo0() {
        return this.loc.distTo0();
    }

    // is the given point within?
    // the bounds of this shape
    public boolean in(CartPt p) {
        return this.loc.same(p);
    }

    // compute the bounding box
    // for this shape
    public Square bb() {
        return new Square(this.loc, 1);
    }
    
    // RETURNS: the perimeter of this shape
    public double perimeter() {
        return 0.0;
    }
}

class Square implements IShape {
    int size;
    CartPt loc;
    
    Square(CartPt loc, int size) {
        this.loc = loc;
        this.size = size;

    }
    
    public double area() {
        return this.size * this.size;
    }
    
    public double distTo0() {
        return this.loc.distTo0();
    }
    
    public boolean in(CartPt p) {
        return
        this.between(this.loc.x, p.x, this.size)
        &&
        this.between(this.loc.y, p.y, this.size);
    }
    
    public Square bb() {
        return this;
    }
    
    // is x in the interval [lft,lft+wdth]?
    boolean between(int lft, int x, int wdth) {
        return lft <= x && x <= lft + wdth;
    }
    
    // RETURNS: the perimeter of this shape
    public double perimeter() {
        return this.size * 4;
    }
}

class Circle implements IShape {
    CartPt loc;
    int radius;
    
    Circle(CartPt loc, int radius) {
        this.loc = loc;
        this.radius = radius;
    }
    
    // to compute the area of this shape
    public double area() {
        return Math.PI * this.radius * this.radius;
    }

    // to compute the distance of
    // this shape to the origin
    public double distTo0() {
        return this.loc.distTo0() - this.radius;
    }

    // is the given point within?
    // the bounds of this shape
    public boolean in(CartPt p) {
        return this.loc.distanceTo(p) <= this.radius;
    }

    // compute the bounding box
    // for this shape
    public Square bb() {
        return new Square(this.loc.translate(this.radius), this.radius * 2);
    }
    
    // RETURNS: the perimeter of this shape
    public double perimeter() {
        return 2 * Math.PI * this.radius;
    }
}


class CartPt {
    int x;
    int y;
    CartPt(int x, int y) { 
        this.x = x;
        this.y = y;
    }

    // to compute the distance of this point to the origin
    double distTo0(){
        return Math.sqrt((this.x * this.x) + (this.y * this.y));
    }

    // are this CartPt and p the same?
    boolean same(CartPt p){
        return (this.x == p.x) && (this.y == p.y);
    }

    // compute the distance between this CartPt and p
    double distanceTo(CartPt p){
        return
                Math.sqrt((this.x - p.x) * (this.x - p.x) + (this.y - p.y) * (this.y - p.y));
    }

    // create a point that is delta pixels (up,left) from this
    CartPt translate(int delta) {
        return new CartPt(this.x - delta, this.y - delta);
    }
}

class ShapeExamples {
    CartPt cp1 = new CartPt(100, 100);
    CartPt cp2 = new CartPt(150, 150);
    
    Dot d1 = new Dot(cp1);
    Square s1 = new Square(cp1, 10);
    Circle c1 = new Circle(cp1, 10);
    
    // tests for methods area()
    boolean testArea(Tester t) {
        return
        // Dot class
        t.checkInexact(d1.area(), 0.0, 0.01) &&
        // Square class
        t.checkInexact(s1.area(), 100.0, 0.01) &&
        // Circle class
        t.checkInexact(c1.area(), Math.PI * 10 * 10, 0.01);
    }
    
    // tests for methods distTo0()
    boolean testDistTo0(Tester t) {
        return
        // Dot class
        t.checkInexact(d1.distTo0(), 100 * Math.sqrt(2.0), 0.01) &&
        // Square class
        t.checkInexact(s1.distTo0(), 100 * Math.sqrt(2.0), 0.01) &&
        // Circle class
        t.checkInexact(c1.distTo0(), 100 * Math.sqrt(2.0) - 10, 0.01);
    }
    
    // tests for method in()
    boolean testIn(Tester t) {
        return
        // Dot class
        t.checkExpect(d1.in(cp1), true) &&
        t.checkExpect(d1.in(cp2), false) &&
        // Square class
        t.checkExpect(s1.in(cp1), true) &&
        t.checkExpect(s1.in(cp2), false) &&
        // Circle class
        t.checkExpect(c1.in(cp1), true) &&
        t.checkExpect(c1.in(cp2), false);
    }
    
    // tests for method bb()
    boolean testBb(Tester t) {
        return
        // Dot class
        t.checkExpect(d1.bb(), new Square(cp1, 1)) &&
        // Square class
        t.checkExpect(s1.bb(), s1) &&
        // Circle class
        t.checkExpect(c1.bb(), new Square(new CartPt(90, 90), 20));
    }
    
    // tests for method perimeter()
    boolean testPerimeter(Tester t) {
        return
        // Dot class
        t.checkInexact(d1.perimeter(), 0.0, 0.01) &&
        // Square class
        t.checkInexact(s1.perimeter(), 40.0, 0.01) &&
        // Circle class
        t.checkInexact(c1.perimeter(), 2 * Math.PI * 10, 0.01);
    }
}