# Chapter 15

The java code of the listings:
* **listing_15_1**
* **listing_15_2**
* **listing_15_3**
* **listing_15_5**

was modified and other classes were added to make the example executable. To see the test suite in action you first have to compile the code:

```
$ javac Main.java
```

And run the compiled:

```
$ java Main
```

After that, you should receive the following output:

```
#################### ComparisonCompactorTest Suite Results ####################

[#1] 'testMessage' test was successful!
[#2] 'testStartSame' test was successful!
[#3] 'testEndSame' test was successful!
[#4] 'testSame' test was successful!
[#5] 'testNoContextStartAndEndSame' test was successful!
[#6] 'testStartAndEndContext' test was successful!
[#7] 'testBug609972' test was successful!
[#8] 'testStartAndEndContextWithEllipses' test was successful!
[#9] 'testComparisonErrorStartSameComplete' test was successful!
[#10] 'testComparisonErrorEndSameComplete' test was successful!
[#11] 'testComparisonErrorOverlapingMatches' test was successful!
[#12] 'testComparisonErrorOverlapingMatchesContext' test was successful!
[#13] 'testComparisonErrorOverlapingMatches2' test was successful!
[#14] 'testComparisonErrorOverlapingMatches2Context' test was successful!
[#15] 'testComparisonErrorWithActualNull' test was successful!
[#16] 'testComparisonErrorWithActualNullContext' test was successful!
[#17] 'testComparisonErrorWithExpectedNull' test was successful!
[#18] 'testComparisonErrorWithExpectedNullContext' test was successful!

Test suite Summary:
* Number of tests: 18.
* Number of successful tests: 18.
* Success ratio: 100.00%.

#################### ComparisonCompactorTest Suite Results ####################


#################### ComparisonCompactorDefactoredTest Suite Results ####################

[#1] 'testMessage' test was successful!
[#2] 'testStartSame' test was successful!
[#3] 'testEndSame' test was successful!
[#4] 'testSame' test was successful!
[#5] 'testNoContextStartAndEndSame' test was successful!
[#6] 'testStartAndEndContext' test was successful!
[#7] 'testBug609972' test was successful!
[#8] 'testStartAndEndContextWithEllipses' test was successful!
[#9] 'testComparisonErrorStartSameComplete' test was successful!
[#10] 'testComparisonErrorEndSameComplete' test was successful!
[#11] 'testComparisonErrorOverlapingMatches' test was successful!
[#12] 'testComparisonErrorOverlapingMatchesContext' test was successful!
[#13] 'testComparisonErrorOverlapingMatches2' test was successful!
[#14] 'testComparisonErrorOverlapingMatches2Context' test was successful!
[#15] 'testComparisonErrorWithActualNull' test was successful!
[#16] 'testComparisonErrorWithActualNullContext' test was successful!
[#17] 'testComparisonErrorWithExpectedNull' test was successful!
[#18] 'testComparisonErrorWithExpectedNullContext' test was successful!

Test suite Summary:
* Number of tests: 18.
* Number of successful tests: 18.
* Success ratio: 100.00%.

#################### ComparisonCompactorDefactoredTest Suite Results ####################


#################### ComparisonCompactorRefactoredTest Suite Results ####################

[#1] 'testMessage' test was successful!
[#2] 'testStartSame' test was successful!
[#3] 'testEndSame' test was successful!
[#4] 'testSame' test was successful!
[#5] 'testNoContextStartAndEndSame' test was successful!
[#6] 'testStartAndEndContext' test was successful!
[#7] 'testBug609972' test was successful!
[#8] 'testStartAndEndContextWithEllipses' test was successful!
[#9] 'testComparisonErrorStartSameComplete' test was successful!
[#10] 'testComparisonErrorEndSameComplete' test was successful!
[#11] 'testComparisonErrorOverlapingMatches' test was successful!
[#12] 'testComparisonErrorOverlapingMatchesContext' test was successful!
[#13] 'testComparisonErrorOverlapingMatches2' test was successful!
[#14] 'testComparisonErrorOverlapingMatches2Context' test was successful!
[#15] 'testComparisonErrorWithActualNull' test was successful!
[#16] 'testComparisonErrorWithActualNullContext' test was successful!
[#17] 'testComparisonErrorWithExpectedNull' test was successful!
[#18] 'testComparisonErrorWithExpectedNullContext' test was successful!

Test suite Summary:
* Number of tests: 18.
* Number of successful tests: 18.
* Success ratio: 100.00%.

#################### ComparisonCompactorRefactoredTest Suite Results ####################
```