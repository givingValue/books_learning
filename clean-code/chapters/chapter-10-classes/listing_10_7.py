class TablePrinter:

    def __init__(self, rows_per_page, columns_per_page, page_header):
        self.__rows_per_page = rows_per_page;
        self.__columns_per_page = columns_per_page;
        self.__page_header = page_header;
        self.__numbers_per_page = rows_per_page * columns_per_page;
    
    def print(self, data):
        page_number = 1
        first_index_on_page = 0
        while (first_index_on_page < len(data)):
            last_index_on_page = min(first_index_on_page + self.__numbers_per_page - 1, len(data) - 1)
            self.__print_page_header(page_number)
            self.__print_page(first_index_on_page, last_index_on_page, data)
            print("")
            page_number += 1
            first_index_on_page += self.__numbers_per_page


    def __print_page_header(self, page_number):
        print(f"{self.__page_header} --- Page {page_number}")
        print("")

    def __print_page(self, first_index_on_page, last_index_on_page, data):
        first_index_of_last_row_on_page = first_index_on_page + self.__rows_per_page - 1
        for first_index_in_row in range(first_index_on_page, first_index_of_last_row_on_page + 1):
            self.__print_row(first_index_in_row, last_index_on_page, data)
            print("")

    def __print_row(self, first_index_in_row, last_index_on_page, data):
        for column in range(self.__columns_per_page):
            index = first_index_in_row + (column * self.__rows_per_page)
            if (index <= last_index_on_page):
                print(f"{data[index]}", end = " ")
