public class Stack {
    private int topOfStack = 0;
    List<Integer> elements = new LinkedList<Integer>();

    public int size() {
        return this.topOfStack;
    }

    public void push(int elements) {
        this.topOfStack++;
        this.elements.add(elements);
    }

    public int pop() throws PoppedWhenEmpty {
        if (this.topOfStack == 0) {
            throw new PoppedWhenEmpty();
        }
        int element = this.elements.get(--this.topOfStack);
        this.elements.remove(this.topOfStack);
        return element;
    }
}