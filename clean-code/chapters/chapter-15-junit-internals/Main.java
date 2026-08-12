public class Main {
    public static void main(String[] args) {
        TestCaseResultWriter testCaseResultWriter = new TestCaseConsoleResultWriter();
        
        TestCase comparisonCompactorTest = new ComparisonCompactorTest();
        comparisonCompactorTest.execute();
        testCaseResultWriter.writeResults(comparisonCompactorTest);

        TestCase comparisonCompactorDefactoredTest = new ComparisonCompactorDefactoredTest();
        comparisonCompactorDefactoredTest.execute();
        testCaseResultWriter.writeResults(comparisonCompactorDefactoredTest);

        TestCase comparisonCompactorRefactoredTest = new ComparisonCompactorRefactoredTest();
        comparisonCompactorRefactoredTest.execute();
        testCaseResultWriter.writeResults(comparisonCompactorRefactoredTest);
    }
}