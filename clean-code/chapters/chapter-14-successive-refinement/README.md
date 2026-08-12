# Chapter 14

The java code of the listings:
* **listing_14_2**
* **listing_14_3**
* **listing_14_4**
* **listing_14_5**
* **listing_14_6**
* **listing_14_7**

was modified in some areas to be executable. To see the Args Class in action you first have to compile the code:

```
$ javac Main.java
```

And run the compiled:

```
Template
# $ java Main -l -p <port value> -s <size value> -d <directory value> -w <words array value>

$ java Main -l -p 5 -s 2.58 -d ./etc -w hello,hi,hola
```

After that, you should receive the following output:

```
logging boolean parameter value: true.
port int parameter value: 5.
size double parameter value: 2.580000.
directory string parameter value: ./etc.
words string array parameter value: hello,hi,hola.
```