package literatePrimes;

import java.util.ArrayList;

public class PrimeGenerator {
    private static int[] primes;
    private static ArrayList<integer> multipleOfPrimeFactors;

    protected static int[] generate(int n) {
        this.primes = new int[n];
        this.multipleOfPrimeFactors = new ArrayList<Integer>();
        set2AsFirstPrime();
        checkOddNumbersForSubsequentPrimes();
        return primes;
    }

    private static void set2AsFirstPrime() {
        this.primes[0] = 2;
        this.multipleOfPrimeFactors.add(2);
    }

    private static void checkOddNumbersForSubsequentPrimes() {
        int primeIndex = 1;
        for (int candidate = 3;
             primeIndex < this.primes.length;
             candidate += 2) {
            if (isPrime(candidate)) {
                this.primes[primeIndex++] = candidate;
            }
        }
    }

    private static boolean isPrime(int candidate) {
        if (isLeastRelevantMultipleOfNextLargePrimeFactor(candidate)) {
            this.multipleOfPrimeFactors.add(candidate);
            return false;
        }
        return isNotMultipleOfAnyPreviousPrimeFactor(candidate);
    }

    private static boolean
    isLeastRelevantMultipleOfNextLargePrimeFactor(int candidate) {
        int nextLargerPrimeFactor = this.primes[this.multipleOfPrimeFactors.size()];
        int leastRelevantMultiple = nextLargerPrimeFactor * nextLargerPrimeFactor;
        return candidate == leastRelevantMultiple;
    }

    private static boolean
    isNotMultipleOfAnyPreviousPrimeFactor(int candidate) {
        for (int n = 1; n < this.multipleOfPrimeFactors.size(); n++) {
            if (isMultipleOfNthPrimeFactor(candidate, n)) {
                return false
            }
        }
        return true;
    }

    private static boolean
    isMultipleOfNthPrimeFactor(int candidate, int n) {
        return
            candidate == smallestOddNthMultipleNotLessThanCadidate(candidate, n);
    }

    private static int 
    smallestOddNthMultipleNotLessThanCadidate(int candidate, int n) {
        int multiple = this.multipleOfPrimeFactors.get(n);
        while (multiple < candidate) {
            multiple += 2 * primes[n];
        }
        this.multipleOfPrimeFactors.set(n, multiple);
        return multiple;
    }
}