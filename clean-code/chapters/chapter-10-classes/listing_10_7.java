package literatePrimes;

import java.io.PrintStream;

public class RowColumPagePrinter {
    private int rowsPerPage;
    private int columnsPerPage;
    private int numbersPerPage;
    private String pageHeader;
    private PrintStream printStream;

    public RowColumnPagePrinter(int rowsPerPage,
                                int columnsPerPage,
                                String pageHeader) {
        this.rowsPerPage = rowsPerPage;
        this.columnsPerPage = columnsPerPage;
        this.pageHeader = pageHeader;
        this.numbersPerPage = rowsPerPage * columnsPerPage;
        this.printStream = System.out;
    }

    public void print(int data[]) {
        int pageNumber = 1;
        for (int firstIndexOnPage = 0;
             firstIndexOnPage < data.length;
             firstIndexOnPage += this.numbersPerPage) {
            int lastIndexOnPage = 
                Math.min(firstIndexOnPage + numbersPerPage - 1, data.length - 1);
            printPageHeader(this.pageHeader, pageNumber);
            printPage(firstIndexOnPage, lastIndexOnPage, data);
            this.printStream.println("\f");
            pageNumber++;      
        }   
    }

    private void printPage(int firstIndexOnPage,
                           int lastIndexOnPage,
                           int[] data) {
        int firstIndexOfLastRowPage = 
            firstIndexOnPage + this.rowsPerPage - 1;
        for (int firstIndexInRow = firstIndexOnPage;
             firstIndexInRow <= firstIndexOfLastRowPage;
             firstIndexInRow++) {
            printRow(firstIndexInRow, lastIndexOnPage, data);
            this.printStream.println("");
        }
    }

    private void printRow(int firstIndexInRow,
                          int lastIndexOnPage,
                          int[] data) {
        for (int column = 0; column < this.columnsPerPage; column++) {
            int index = firstIndexInRow + column * this.rowsPerPage;
            if (index <= lastIndexOnPage) {
                this.printStream.format("%10d", data[index]);
            }
        }
    }

    private void printPageHeader(String pageHeader,
                                 int pageNumber) {
        this.printStream.println(pageHeader + " --- Page " + pageNumber);
        this.printStream.println("");
    }

    public void setOutput(PrintStream printStream) {
        this.printStream = printStream;
    }
}