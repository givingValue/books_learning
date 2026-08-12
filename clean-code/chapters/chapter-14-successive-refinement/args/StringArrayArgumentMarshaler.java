package args;

import java.util.Iterator;
import java.util.NoSuchElementException;
import static args.ArgsException.ErrorCode.*;

public class StringArrayArgumentMarshaler implements ArgumentMarshaler {
    private String[] stringArrayValue = new String[0];

    public void set(Iterator<String> currentArgument) throws ArgsException {
        String parameter = null;
        try {
            parameter = currentArgument.next();
            stringArrayValue = parameter.split(",");
        } catch (NoSuchElementException e) {
            throw new ArgsException(MISSING_STRING_ARRAY);
        }
    }

    public static String[] getValue(ArgumentMarshaler am) {
        if (am != null && am instanceof StringArrayArgumentMarshaler) {
            return ((StringArrayArgumentMarshaler) am).stringArrayValue;
        } else {
            return new String[0];
        }
    }
}