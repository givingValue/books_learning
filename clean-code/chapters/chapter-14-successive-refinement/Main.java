import args.*;

public class Main {
    public static void main(String[] args) {
        try {
            Args arg = new Args("l,p#,s##,d*,w[*]", args);
            boolean logging = arg.getBoolean('l');
            int port = arg.getInt('p');
            double size = arg.getDouble('s');
            String directory = arg.getString('d');
            String[] words = arg.getStringArray('w');
            System.out.printf("logging boolean parameter value: %b.\n", logging);
            System.out.printf("port int parameter value: %d.\n", port);
            System.out.printf("size double parameter value: %f.\n", size);
            System.out.printf("directory string parameter value: %s.\n", directory);
            System.out.printf("words string array parameter value: %s.\n", String.join(",", words));
        } catch (ArgsException e) {
            System.out.printf("Argument error: %s\n", e.errorMessage());
        }
    }
}