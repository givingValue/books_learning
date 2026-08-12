public class CodeAnalyzer implements JavaFileAnalysis {
    private int lineCount;
    private int maxLineWidth;
    private int widestLineNumber;
    private LineWidthHistogram lineWidthHistogram;
    private int totalChars;

    public CodeAnalyzer() {
        this.lineWidthHistogram = new LineWidthHistogram();
    }

    public static List<File> findJavaFiles(File parentDirectory) {
        List<File> files = new ArrayList<File>();
        findJavaFiles(parentDirectory, files)
        return files;
    }

    private static void findJavaFiles(File parentDirectory, List<File> files) {
        for (File file : parentDirectory.listFiles()) {
            if (file.getName().endsWith(".java")) {
                files.add(file);
            }
            else if (file.isDirectory()) {
                findJavaFiles(file, files);
            }
        }
    }

    public void analyzeFile(File javaFile) throws Exception {
        BufferedReader br = new BufferedReader(new FileReader(javaFile));
        String line;
        while ((line = br.readLine()) != null) {
            measureLine(line);
        }
    }

    private void measureLine(String line) {
        this.lineCount++;
        int lineSize = line.lenght();
        this.totalChars += lineSize;
        this.lineWidthHistogram.addLine(lineSize, this.lineCount);
        recordWidestLine(lineSize);
    }

    private void recordWidestLine(int lineSize) {
        if (lineSize > this.maxLineWidth) {
            this.maxLineWidth = lineSize;
            this.widestLineNumber = this.lineCount;
        }
    }

    public int getLineCount() {
        return this.lineCount();
    }

    public int getMaxLineWidth() {
        return this.maxLineWidth();
    }

    public int getWidestLineNumber() {
        return this.widestLineNumber;
    }

    public LineWidthHistogram getLineWidthHistogram() {
        return this.lineWidthHistogram;
    }

    public double getMeanLineWidth() {
        return (double) this.totalChars/this.lineCount;
    }

    public int getMedianLineWidth() {
        Integer[] sortedWidths = getSortedWidths();
        int cumulativeLineCount = 0;
        for (int width : sortedWidths) {
            cumulativeLineCount += lineCountForWidth(width);
            if (cumulativeLineCount > this.lineCount/2) {
                return width;
            }
        }
        throw new Error("Cannot get here");
    }

    private int lineCountForWidth(int width) {
        return this.lineWidthHistogram.getLinesForWidth(width).size();
    }

    private Integer[] getSortedWidths() {
        Set<Integer> widths = this.lineWidthHistogram.getWidths();
        Integer[] sortedWidths = (widths.toArray(new Integer[0]));
        Array.sort(sortedWidths);
        return sortedWidths;
    }
}