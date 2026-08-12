class PrimeGenerator:

    def __init__(self):
        self.__primes = []
        self.__multiple_of_prime_factors = []
    
    def generate(self, number_of_primes):
        self.__number_of_primes = number_of_primes
        self.__set_2_as_first_prime()
        self.__check_odd_numbers_for_subsequent_primes()
        return self.__primes;

    def __set_2_as_first_prime(self):
        self.__primes.append(2);
        self.__multiple_of_prime_factors.append(2);

    def __check_odd_numbers_for_subsequent_primes(self):
        prime_index = 1
        candidate = 3
        while (prime_index < self.__number_of_primes):
            if (self.__is_prime(candidate)):
                self.__primes.append(candidate)
                prime_index += 1
            candidate += 2

    def __is_prime(self, candidate):
        if (self.__is_least_relevant_multiple_of_next_large_prime_factor(candidate)):
            self.__multiple_of_prime_factors.append(candidate)
            return False
        return self.__is_not_multiple_of_any_previous_prime_factor(candidate)

    def __is_least_relevant_multiple_of_next_large_prime_factor(self, candidate):
        if (len(self.__primes) != 1):
            next_larger_prime_factor = self.__primes[len(self.__multiple_of_prime_factors)]
            least_relevant_multiple = next_larger_prime_factor * next_larger_prime_factor
            return candidate == least_relevant_multiple
        return False

    def __is_not_multiple_of_any_previous_prime_factor(self, candidate):
        for n in range(1, len(self.__multiple_of_prime_factors)):
            if (self.__is_multiple_of_nth_prime_factor(candidate, n)):
                return False
        return True

    def __is_multiple_of_nth_prime_factor(self, candidate, n):
        return candidate == self.__smallest_odd_nth_multiple_not_less_than_candidate(candidate, n)

    def __smallest_odd_nth_multiple_not_less_than_candidate(self, candidate, n):
        multiple = self.__multiple_of_prime_factors[n]
        while (multiple < candidate):
            multiple += 2 * self.__primes[n]
        self.__multiple_of_prime_factors[n] = multiple
        return multiple