public abstract class TestCaseResultWriter {
    protected int successfulTests;

    public abstract void writeResults(TestCase testCase);
}