public class Square implements Shape {
    private Point topLeft;
    private double side;

    public double area() {
        return this.side * this.side;
    }
}

public class Rectangle implements Shape {
    private Point topLeft;
    private double height;
    private double width;

    public double area() {
        return this.height * this.width;
    }
}

public class Circle implements Shape {
    private Point center;
    private double radius;
    public final double PI = 3.141592653589793;

    public double area() {
        return this.PI * this.radius * this.radius;
    }
}