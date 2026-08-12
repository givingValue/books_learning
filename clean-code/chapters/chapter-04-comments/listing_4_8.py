import math

"""
This class Generates prime numbers up to a user specified
maximum. The algorithm used is the Sieve of Eratosthenes.
Given an array of integers starting at 2:
Find the first incrossed integer, and cross out all its
multiples. Repeat untl there are no multiples in the array.
"""
class PrimeGenerator:

    def __init__(self):
        self.__crossed_out = []
        self.__result = []

    def generate_primes(self, max_value):
        if (max_value < 2):
            return self.__result;
        else:
            self.__uncross_integers_up_to(max_value)
            self.__cross_out_multiples()
            self.__put_uncrossed_integers_into_result()
            return self.__result

    def __uncross_integers_up_to(self, max_value):
        for number in range(max_value + 1):
            self.__crossed_out.append(False)

    def __cross_out_multiples(self):
        limit = self.__determine_iteration_limit()
        for number in range(2, limit + 1):
            if (self.__not_crossed(number)):
                self.__cross_out_multiples_of(number)

    def __determine_iteration_limit(self):
        # Every multiple in the array has a prime factor that
        # is less than or equal to the root of the array size,
        # so we don't hace to cross out multiples of numbers
        # larger than that root.
        iteration_limit = math.sqrt(len(self.__crossed_out))
        return int(iteration_limit)

    def __not_crossed(self, number):
        return not self.__crossed_out[number]

    def __cross_out_multiples_of(self, number):
        for multiple in range(2 * number, len(self.__crossed_out), number):
            self.__crossed_out[multiple] = True

    def __put_uncrossed_integers_into_result(self):
        for number in range(2, len(self.__crossed_out)):
            if (self.__not_crossed(number)):
                self.__result.append(number)


if __name__ == "__main__":
    prime_generator = PrimeGenerator()
    max_value = int(input("Introduce the limit number for finding primes:"))
    primes = prime_generator.generate_primes(max_value)
    print(primes)