from listing_10_8 import PrimeGenerator
from listing_10_7 import TablePrinter

if __name__ == "__main__":
    number_of_primes = int(input("Introduce the number of primes to get: "))
    rows_per_page = int(input("Introduce the number of rows per page: "))
    columns_per_page = int(input("Introduce the number of columns per page: "))
    print("")

    prime_generator = PrimeGenerator()
    primes = prime_generator.generate(number_of_primes)

    table_printer = TablePrinter(rows_per_page,
                                 columns_per_page,
                                 f'The First {number_of_primes} Prime Numbers')
    table_printer.print(primes)