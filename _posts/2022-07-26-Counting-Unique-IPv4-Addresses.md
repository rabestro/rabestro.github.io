---
title: "Counting Unique IPv4 Addresses"
date: 2022-07-26 19:50:00 +0300
categories: [Java]
tags: [java, stream-api]
mermaid: false
---

This task was proposed to me in one of the Java courses. In this article, I present my solution and analyze its efficiency. IP address processing is necessary for many projects, and I hope that the algorithms described in this article can be useful.

## The Task

A text file contains a list of IPv4 addresses in decimal notation. Each line contains exactly one address, as in the example below:

```
145.67.23.4
8.34.5.23
89.54.3.124
89.54.3.124
3.45.71.5
...
```

The task is to write a program to count the number of unique addresses in this file. The addresses are correct, so they don't need to be additionally checked. However, the number of addresses can be quite large, up to several billion. We need to write a program that uses a minimum of memory and processor resources.

For example, consider the text file: https://ecwid-vgv-storage.s3.eu-central-1.amazonaws.com/ip_addresses.zip. In its unpacked form, this file takes up almost 120 Gb, it contains 8 billion addresses, of which one billion are unique.

## Command Line

In the case of small text files, it is not necessary to write a separate program - we can use the operating system commands to perform this task. For example, in the Linux system, the command will look like this:

```bash
sort -u ips.txt | wc -l
```

But on large files, the execution time will be very significant. In the end, instead of the result, we get an error message:

```
sort: write failed: /tmp/sortcQjXmj: No space left on device 
0
```

## Writing the Program

So, let's start writing a program to solve this task. We will use the capabilities of the modern version of Java, such as the Stream API.

To read the file, we use the static method `lines(Path path)` of the `Files` class, which returns a stream of lines. Each line is a textual representation of the address in decimal notation. Our task is to count the number of unique addresses.

The program scheme will look something like this:

```java
class IPCounter {
    public static void main(String[] args) {
        var path = Path.of("ips.txt");
        try (var lines = Files.lines(path)) {

            // count the number of unique addresses
            var unique = ... 

            System.out.println(unique);
        } catch (IOException e) {
            System.err.println(e.getMessage());
        }
    }
}
```

Here we assume that the text file is called "ips.txt" and is located in the working directory of the program. For brevity, we directly use the file name in the program code. Also, we omit import lines.

We just need to add code to count unique addresses, and below we will consider possible options.

## Naive Way

Our first attempt to solve this task will look like this:

```java
var unique = lines.distinct().count();    
```

Just like in the case with the command line, this solution will work only on small data volumes. On our test file of 120 Gb, the program, launched on a personal computer with 8 Gb RAM, ended with an error:

```log
Exception in thread "main" java.lang.OutOfMemoryError: Java heap space
...
```

Indeed, for the program to work, it needs to save a billion unique string objects. On a 64-bit JVM, the minimum object size is 16 bytes, and to store a billion objects, you need at least 16 Gb of memory. If we talk about specific strings representing addresses, their length varies from 7 to 15 characters, and such objects will take up 24 or 32 bytes in memory. It is clear that if this solution works, it will only work on a very powerful computer with a large amount of memory.

## Converting Strings to Numbers

The first thing we can do to reduce the amount of data is to convert the address representation from text to binary format. The Internet Protocol version 4 (IPv4) uses 32-bit (4-byte) addresses.

![Converting Strings to Numbers](https://habrastorage.org/r/w1560/getpro/habr/upload_files/e3c/9a6/404/e3c9a64046ea4b076ac9537f05210a4f.png)

In our text file, addresses are written as four decimal numbers from 0 to 255, separated by dots. We will convert each of these numbers into a byte and combine them into an integer of type `int`. Thus, each address will take exactly 4 bytes.

Let's try to google and use a ready-made algorithm. For example, one of the algorithms on the Mkyong site. For convenience, let's create a separate class, this will allow us to easily replace the converter with an optimal one in the future.

```java
public class MkyongConverter implements ToIntFunction<String> {

    @Override
    public int applyAsInt(String ipAddress) {
        var ipAddressInArray = ipAddress.split("\\.");
        long result = 0;
        for (int i = 0; i < ipAddressInArray.length; i++) {
            int power = 3 - i;
            int ip = Integer.parseInt(ipAddressInArray[i]);
            result += ip * Math.pow(256, power);
        }
        return (int) result;
    }
}
```

Now let's rewrite our program using the converter:

```java
var converter = new MkyongConverter();

var unique = lines
				.mapToInt(converter)
				.distinct()
				.count();
```

Unfortunately, when we run the program, we get the same error message as before: `OutOfMemoryError`. This happens because the `distinct()` method does not have a specialized implementation for integers. If you look at the source code of the implementation, you will see that there is a "boxing" of numbers with conversion to a regular stream of objects, and then a call to the `distinct()` method for a regular stream. If an integer takes up 4 bytes in memory, the wrapper is four times larger - 16 bytes.

To solve this problem, we need to create and use our own, optimized, container for representing a set of integers.

## Container for Numbers

First, let's define what interface our container should have. We will add the minimum number of methods necessary to solve our task.

We will use the `collect` method of the integer stream, so let's look at the signature of this method:

```java
<R> R collect(Supplier<R> supplier,
              ObjIntConsumer<R> accumulator,
              BiConsumer<R,R> combiner)
```

Here `R` is the type of the mutable result container. The `supplier` parameter creates (supplies) our container, `accumulator` takes a container and an integer as input, and `combiner` takes two containers as input and combines them. The latter is used when it is necessary to combine parallel streams.

Since we will only use a sequential stream, we can omit the implementation of the `addAll` method. Also, the container will need a method that will return the number of collected unique addresses. Based on all of the above, we define the interface for our container:

```java
public interface IntContainer {
    // accumulator
    void add(int number); 

    // combiner
    default void addAll(IntContainer other) {
        throw new UnsupportedOperationException();
    }

    long countUnique();
}
```

The next question we need to solve is how exactly to store information.

If we have about a billion numbers, each of which takes 4 bytes, then we need 4Gb of information to store them. But we can store not the numbers themselves, but only information about whether such a number exists or not. And for this, we need only one bit. For integers of type `int`, we need 232 bits, which is equal to 512Mb. This value is fixed and does not depend on the total number of numbers that need to be processed.

In Java, there is a `BitSet` class for working with a set of bits, which is quite suitable for our purposes.

Let's take into account that the bit index can be from 0 to `Integer.MAX_VALUE`, and we need to store information not only about positive numbers, but also about negative ones. Therefore, we create two sets, one for positive numbers, the second - for negative ones. Here is a simple implementation of the interface for a container in which we define two bit sets:

```java
public class DualBitSetContainer implements IntContainer {
    private final BitSet positive = new BitSet(Integer.MAX_VALUE);
    private final BitSet negative = new BitSet(Integer.MAX_VALUE);

    @Override
    public void add(int i) {
        if (i >= 0) {
            positive.set(i);
        } else {
            negative.set(~i);
        }
    }

    @Override
    public long countUnique() {
        return (long) positive.cardinality() + negative.cardinality();
    }
}
```

Now the count of unique addresses will look like this:

```java
var unique = lines
        .mapToInt(converter)
        .collect(DualBitSetContainer::new, IntContainer::add, IntContainer::addAll)
        .countUnique();
```

When we run our application, the program, albeit not quickly, but successfully reads and processes the test file and gives the correct result: 1,000,000,000 unique addresses.

## Optimizing the Converter

Let's return to the algorithm for converting an address from a textual representation to a number. We took a ready-made algorithm from the internet. But how good is it? Unfortunately, like many ready-made solutions from the internet, this code is far from optimal.

Consider this line:

```java
var ipAddressInArray = ipAddress.split("\\.");
```

The main performance issue here is that five new objects are created - four strings and an array. These new objects are used only within the method and after its completion should be collected by the garbage collector. Creating an object is a costly operation. The virtual machine must allocate and initialize memory for these objects, and after the method's work, these objects remain in memory until they are processed by the garbage collector.

The second line to pay attention to is the conversion of strings to numbers:

```java
int ip = Integer.parseInt(ipAddressInArray[i]);
```

Here, the Integer::parseInt method checks the input data and can throw a NumberFormatException exception.

Unfortunately, this cannot be considered a check for the correctness of the address, as the method passes all numbers beyond the permissible range from 0 to 255. If we have a task to check IP addresses, we can use the InetAddress class. For example, we can convert the address using this code:

```java
String ipAddress = "172.16.254.1";

int ip = ByteBuffer.allocate(Integer.BYTES)
            .put(InetAddress.getByName(ipAddress).getAddress())
            .getInt(0);
```

In case of an incorrect address, the InetAddress::getByName method throws a checked UnknownHostException exception, which we must catch and handle.

However, according to the task, all addresses are correct. We do not need to perform additional checks for their correctness.

What do we need to write an optimal method? First, we should avoid creating unnecessary temporary objects. Second, we don't need to use complex built-in methods for parsing numbers if we can write our own simple algorithm. Let's try to write a converter that meets these conditions:

```java
public class OptimizedConverter implements ToIntFunction<CharSequence> {
    private static final int DECIMAL_BASE = 10;

    @Override
    public int applyAsInt(CharSequence ipAddress) {
        int base = 0;
        int part = 0;

        for (int i = 0, n = ipAddress.length(); i < n; ++i) {
            char symbol = ipAddress.charAt(i);
            if (symbol == '.') {
                base = (base << Byte.SIZE) | part;
                part = 0;
            } else {
                part = part * DECIMAL_BASE + symbol - '0';
            }
        }
        return  (base << Byte.SIZE) | part;
    }
}
```

In this algorithm, we avoid creating objects and do not use "heavy" methods for converting text to a number. Note that we do not call special methods of the String class and therefore can use a more general CharSequence interface. This allows us to pass not only objects of the String class as a method parameter but also objects of other classes that support this interface, for example, StringBuilder.

## Comparing Converters

Let's see how much we managed to improve the performance of the algorithm. For this, we will use the JMH framework. We measure the speed of the converters for three addresses of different lengths. Below are the measurement results:

![Measurement results](https://habrastorage.org/r/w1560/getpro/habr/upload_files/b19/267/773/b192677738500eabfeb70a306c6d8e7a.png)

As you can see, for all types of addresses, our own implementation works an order of magnitude faster than the ready-made solution copied from the internet.

## Optimizing the Container

The implementation of the container using two bitsets is simple and quite efficient. However, we can slightly improve this implementation. The universal BitSet class contains various checks that we can exclude in our own implementation.

As the basis of the implementation, we use an array of integers of type long. Since this type takes up 8 bytes or 64 bits in memory, we can use one such number as a set for 64 numbers. The input parameter representing the IPv4 address takes up 32 bits in memory. We split it into two parts. The first part, 6 bits, will be the value (a number from 0 to 63). The second part of size 24 bits will represent the array index where this value is stored.

## Implementing a Container Based on an Array

Below is an example of a container implementation based on an array:

```java
public class LongArrayContainer implements IntContainer {
    private static final int VALUE_SIZE = 6;
    private static final int VALUE_MASK = 077;
    private static final int STORAGE_SIZE = 1 << (Integer.SIZE - VALUE_SIZE + 1);

    private final long[] storage = new long[STORAGE_SIZE];

    @Override
    public void add(final int number) {
        final int index = number >>> VALUE_SIZE;
        final int value = number & VALUE_MASK;
        
        storage[index] |= 1L << value;
    }

    @Override
    public long countUnique() {
        return Arrays.stream(storage).map(Long::bitCount).sum();
    }
}
```

This implementation is well suited for the case when we have a large number of IPv4 addresses, randomly distributed over the entire possible range. The disadvantage of this implementation is that we immediately allocate 512Mb of memory.

In practice, we may need to process addresses of only certain segments, for example, a separate country. In this case, many segments may not be present at all. In this case, we can optimize our implementation in memory, losing a little in performance.

For this implementation, we will create an array of BitSet, where each array index represents a certain network segment, while we do not allocate memory when initializing BitSet. Memory will be allocated dynamically, as needed. When creating a container, we can set the segment size.

Below is an example of implementation. Here the level parameter in the constructor determines the number of bits for the array index, and can be from 1 to 16. At level 1 we get an analogue of DualBitSetContainer with dynamic memory allocation. The most optimal seems to be level 8, when an array of 256 cells is created. In this case, for addresses of the form 192.xxx.xxx.xxx, only 2Mb of memory will be allocated for each segment.

```java
public class BitSetContainer implements IntContainer {
    private final BitSet[] storage;
    private final int mask;
    private final int shift;

    public BitSetContainer(int level) {
        Objects.checkIndex(level - 1, Byte.SIZE * 2);
        mask = 0xFFFF_FFFF >>> level;
        shift = Integer.SIZE - level;
        storage = Stream.generate(BitSet::new).limit(1L << level).toArray(BitSet[]::new);
    }

    @Override
    public void add(int ip) {
        storage[ip >>> shift].set(ip & mask);
    }

    @Override
    public long countUnique() {
        return Arrays.stream(storage).mapToLong(BitSet::cardinality).sum();
    }
}
```

Let's rewrite our program using the latest container:

```java
ToIntFunction<CharSequence> converter = new OptimizedConverter();
Supplier<IntContainer> supplier = () -> new BitSetContainer(Byte.SIZE);

var unique = lines
        .mapToInt(converter)
        .collect(supplier, IntContainer::add, IntContainer::addAll)
        .countUnique();
```

We got a simple and flexible code where, by changing the container implementation, we can optimize the program for different input data variants. And although compared to the very first "naive" approach the code has become more complex, we have reduced the memory and processor resource requirements by more than ten times.

The full code is available in the repository at:
https://github.com/rabestro/unique-ip-addresses
