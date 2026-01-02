public class TestSonar {

    // Code smell: unused variable
    private static int unusedValue = 10;

    public static void main(String[] args) {

        // Bug: possible NullPointerException
        String message = null;

        if (message.equals("Hello")) {
            System.out.println("Hello World");
        }

        // Code smell: duplicated logic
        printNumber(5);
        printNumber(5);

        // Security hotspot: hardcoded password
        String password = "admin123";
        System.out.println("Password is: " + password);
    }

    private static void printNumber(int number) {
        if (number > 0) {
            System.out.println("Positive number");
        } else {
            System.out.println("Non-positive number");
        }
    }
}
