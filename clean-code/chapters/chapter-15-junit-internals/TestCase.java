import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

public class TestCase {
    
    private ArrayList<Boolean> testMethodsResults;
    private ArrayList<String> testMethodsNames;

    public TestCase() {
        testMethodsResults = new ArrayList<Boolean>();
        testMethodsNames = new ArrayList<String>();
    }

    public ArrayList<Boolean> getTestMethodsResults() {
        return testMethodsResults;
    }

    public ArrayList<String> getTestMethodsNames() {
        return testMethodsNames;
    }

    public void assertTrue(boolean bValue) {
        testMethodsResults.add(bValue);
    }

    public void assertEquals(String expected, String actual) {
        boolean bValue = expected.equals(actual);
        testMethodsResults.add(bValue);
    }

    public void execute() {
        Class testObjectClass = this.getClass();
        Method[] testObjectMethods = testObjectClass.getDeclaredMethods();
        for (Method method: testObjectMethods) {
            if (isTestMethod(method)) {
                testMethodsNames.add(method.getName());
                invokeTestMethod(method);
            }
        }
    }

    private boolean isTestMethod(Method method) {
        String methodName = method.getName();
        if (methodName.startsWith("test")) {
            return true;
        }
        return false;
    }

    private void invokeTestMethod(Method testMethod) {
        try {
            testMethod.invoke(this);
        }  catch (InvocationTargetException e) {
            Throwable errorCause = e.getCause();
            System.out.printf("Invocation of %s failed: %s./n",
                testMethod.getName(), 
                errorCause.getMessage());
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }
}