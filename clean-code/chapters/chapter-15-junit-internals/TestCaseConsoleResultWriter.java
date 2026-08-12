import java.util.ArrayList;

public class TestCaseConsoleResultWriter extends TestCaseResultWriter {
    
    public void writeResults(TestCase testCase) {
        writeResultsDelimiter(testCase);
        writeResultsDetails(testCase);
        writeResultsSummary(testCase);
        writeResultsDelimiter(testCase);
    }

    private void writeResultsDelimiter(TestCase testCase) {
        String testObjectClassName = testCase.getClass().getName();
        System.out.println();
        System.out.printf("#################### %s Suite Results ####################\n",
            testObjectClassName);
        System.out.println();
    }

    private void writeResultsDetails(TestCase testCase) {
        final ArrayList<Boolean> testMethodsResults = testCase.getTestMethodsResults();
        final ArrayList<String> testMethodsNames = testCase.getTestMethodsNames();
        int testNumber;
        successfulTests = 0;

        for (int index = 0; index < testMethodsResults.size(); index++) {
            testNumber = index + 1;
            if (isSuccessfulTest(testMethodsResults, index)) {
                successfulTests++;
                System.out.printf("[#%d] '%s' test was successful!\n", 
                    testNumber,
                    getTestMethodName(testMethodsNames, index));
            } else {
                System.out.printf("[#%d] '%s' test was not successful*\n", 
                    testNumber,
                    getTestMethodName(testMethodsNames, index));
            }
        }
    }

    private void writeResultsSummary(TestCase testCase) {
        final ArrayList<Boolean> testMethodsResults = testCase.getTestMethodsResults();
        
        System.out.println();
        System.out.println("Test suite Summary:");
        System.out.printf("* Number of tests: %d.\n", testMethodsResults.size());
        System.out.printf("* Number of successful tests: %d.\n", successfulTests);
        System.out.printf("* Success ratio: %.2f%%.\n", 
            (float)(successfulTests/testMethodsResults.size()*100));
    }

    private boolean isSuccessfulTest(ArrayList<Boolean> testMethodsResults, int index) {
        return testMethodsResults.get(index);
    }

    private String getTestMethodName(ArrayList<String> testMethodsNames, int index) {
        return testMethodsNames.get(index);
    }
}