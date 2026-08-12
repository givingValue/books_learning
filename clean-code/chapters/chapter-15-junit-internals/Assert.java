public class Assert {
    public static String format(String message, String expected, String actual) {
        message = message != null ? message + " " : "";
        return String.format("%sexpected:<%s> but was:<%s>", message, expected, actual);
    }
}