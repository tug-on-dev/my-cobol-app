---
author: Documentation Specialist Agent
description: Complete mapping of COBOL data structures to Java equivalents
last_changed: 2025-11-14
---

# COBOL to Java Data Structure Mapping

## Table of Contents

- [Overview](#overview)
- [Numeric Data Types](#numeric-data-types)
- [Character Data Types](#character-data-types)
- [Date and Time](#date-and-time)
- [Complex Structures](#complex-structures)
- [File Layouts](#file-layouts)
- [Best Practices](#best-practices)

## Overview

This guide provides comprehensive mappings between COBOL data types and their Java equivalents, including rationale and gotchas.

### Key Differences

| Aspect | COBOL | Java |
|--------|-------|------|
| Type System | Fixed-length, position-based | Object-oriented, strongly typed |
| Memory | Explicit control (COMP-3, COMP) | Automatic management |
| Precision | Exact decimal (DECIMAL) | Approximate (float/double) or exact (BigDecimal) |
| Strings | Fixed-length (PIC X) | Variable-length (String) |
| Arrays | OCCURS clause | Arrays or Collections |
| Null values | No concept (use HIGH-VALUES, SPACES) | Native null support |

## Numeric Data Types

### Display Numeric (Zoned Decimal)

**COBOL:**
```cobol
05  EMPLOYEE-ID         PIC 9(6).          * 6-digit number
05  TRANSACTION-COUNT   PIC 999.           * 0-999
05  AMOUNT              PIC 9(5)V99.       * Up to 99999.99
05  SIGNED-AMOUNT       PIC S9(5)V99.      * Signed decimal
```

**Java:**
```java
private int employeeId;              // Or Long for >9 digits
private int transactionCount;
private BigDecimal amount;           // Use BigDecimal for money!
private BigDecimal signedAmount;
```

**Storage:**
- COBOL: 1 byte per digit (zone format)
- Java: 4 bytes (int), 8 bytes (long), variable (BigDecimal)

> [!WARNING]
> Never use float or double for monetary amounts! Always use BigDecimal to avoid rounding errors.

### Packed Decimal (COMP-3)

**COBOL:**
```cobol
05  ACCT-BALANCE    PIC S9(7)V99 COMP-3.   * Packed decimal
05  CREDIT-LIMIT    PIC S9(9)V99 COMP-3.   * Signed, 2 decimals
05  QUANTITY        PIC 9(5) COMP-3.       * Unsigned
```

**Java:**
```java
private BigDecimal accountBalance;    // precision=9, scale=2
private BigDecimal creditLimit;       // precision=11, scale=2
private int quantity;                 // Or Integer for null support
```

**Characteristics:**
- COBOL COMP-3: 2 digits per byte + sign nibble
- Java BigDecimal: Arbitrary precision, immutable
- PIC S9(7)V99 COMP-3 = 5 bytes in COBOL
- BigDecimal in Java = Variable size (typically 16-32 bytes)

### Binary (COMP / COMP-4)

**COBOL:**
```cobol
05  RECORD-COUNT       PIC S9(4) COMP.     * 16-bit signed
05  FILE-SIZE          PIC S9(9) COMP.     * 32-bit signed
05  BIG-NUMBER         PIC S9(18) COMP.    * 64-bit signed
```

**Java:**
```java
private short recordCount;      // -32,768 to 32,767
private int fileSize;           // -2B to 2B
private long bigNumber;         // -9 quintillion to 9 quintillion
```

**Size Mapping:**

| COBOL COMP | Max Digits | Java Type | Size |
|------------|------------|-----------|------|
| S9(1-4) COMP | 4 | short | 2 bytes |
| S9(5-9) COMP | 9 | int | 4 bytes |
| S9(10-18) COMP | 18 | long | 8 bytes |
| S9(19+) COMP | 19+ | BigInteger | Variable |

### Floating Point (COMP-1 / COMP-2)

**COBOL:**
```cobol
05  TEMPERATURE    COMP-1.                 * Single precision
05  PRECISE-VALUE  COMP-2.                 * Double precision
```

**Java:**
```java
private float temperature;          // 32-bit IEEE 754
private double preciseValue;        // 64-bit IEEE 754
```

> [!CAUTION]
> COMP-1 and COMP-2 are rarely used in business applications. Prefer COMP-3 with BigDecimal for financial data.

### Edited Numeric (Display Format)

**COBOL:**
```cobol
05  FORMATTED-AMOUNT   PIC $$,$$$,$$9.99.  * Edited for display
05  ZERO-SUPPRESS      PIC Z,ZZZ,ZZ9.      * Leading zeros suppressed
05  CHECK-PROTECT      PIC ***,**9.99.     * Check protection
```

**Java:**
```java
// Don't store as formatted! Store as BigDecimal, format on output
private BigDecimal amount;

// Format when displaying
NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.US);
String formatted = currencyFormat.format(amount); // "$1,234.56"

// Or use DecimalFormat
DecimalFormat df = new DecimalFormat("$#,##0.00");
String formatted = df.format(amount);
```

## Character Data Types

### Alphanumeric (PIC X)

**COBOL:**
```cobol
05  CUSTOMER-NAME      PIC X(30).          * Fixed 30 chars
05  ADDRESS-LINE1      PIC X(25).          * Fixed 25 chars
05  STATE-CODE         PIC XX.             * Fixed 2 chars
05  DESCRIPTION        PIC X(100).         * Fixed 100 chars
```

**Java:**
```java
@Column(length = 30)
private String customerName;        // Variable length, max 30

@Column(length = 25)
private String addressLine1;

@Column(length = 2)
private String stateCode;

@Column(length = 100)
private String description;
```

**Key Differences:**

| Aspect | COBOL PIC X | Java String |
|--------|-------------|-------------|
| Length | Fixed | Variable |
| Padding | Space-padded | No padding |
| Storage | Exactly N bytes | 2N bytes (UTF-16) |
| Trimming | Manual (TRIM function) | Automatic or .trim() |

**Migration Pattern:**
```java
// Reading COBOL fixed-length field
String cobolName = "Smith               "; // 20 chars, space-padded
String javaName = cobolName.trim();         // "Smith"

// Writing to COBOL-format file
String name = "Smith";
String padded = String.format("%-20s", name); // Left-align, pad to 20
```

### Alphabetic (PIC A)

**COBOL:**
```cobol
05  INITIAL            PIC A.              * Single letter
05  NAME               PIC A(20).          * Letters only
```

**Java:**
```java
private String initial;             // No built-in constraint
private String name;

// Validate with regex if needed
if (!name.matches("[A-Za-z]+")) {
    throw new ValidationException("Name must contain only letters");
}

// Or use Bean Validation
@Pattern(regexp = "[A-Za-z]+", message = "Must contain only letters")
private String name;
```

### Alphanumeric Edited

**COBOL:**
```cobol
05  PHONE-NUMBER       PIC (999) 999-9999. * Formatted phone
05  SSN                PIC 999-99-9999.    * Social security
05  DATE-FORMATTED     PIC 99/99/9999.     * Date display
```

**Java:**
```java
// Store unformatted, format on output
private String phoneNumber;     // "5551234567"
private String ssn;             // "123456789"
private LocalDate date;         // Use proper date type

// Format when displaying
String formattedPhone = phoneNumber.replaceFirst(
    "(\\d{3})(\\d{3})(\\d{4})", "($1) $2-$3");
```

## Date and Time

### COBOL Date Formats

**COBOL:**
```cobol
05  DATE-YYMMDD        PIC 9(6).           * YYMMDD format
05  DATE-YYYYMMDD      PIC 9(8).           * YYYYMMDD format
05  DATE-MMDDYY        PIC 9(6).           * MMDDYY format
05  TIMESTAMP          PIC 9(14).          * YYYYMMDDHHmmSS
```

**Java:**
```java
// Use proper date/time types, not integers!
private LocalDate date;                    // Year-month-day
private LocalDateTime timestamp;            // Date + time
private Instant instant;                   // UTC timestamp

// Converting from COBOL integer format
int cobolDate = 20251114;  // YYYYMMDD
String dateStr = String.valueOf(cobolDate);
LocalDate date = LocalDate.parse(dateStr, 
    DateTimeFormatter.BASIC_ISO_DATE);

// Converting to COBOL format
LocalDate date = LocalDate.now();
int cobolDate = Integer.parseInt(
    date.format(DateTimeFormatter.BASIC_ISO_DATE));
```

### CURRENT-DATE Function

**COBOL:**
```cobol
01 WS-CURRENT-DATE-DATA.
    05  WS-CURRENT-DATE.
        10  WS-CURRENT-YEAR         PIC 9(04).
        10  WS-CURRENT-MONTH        PIC 9(02).
        10  WS-CURRENT-DAY          PIC 9(02).
    05  WS-CURRENT-TIME.
        10  WS-CURRENT-HOURS        PIC 9(02).
        10  WS-CURRENT-MINUTE       PIC 9(02).
        10  WS-CURRENT-SECOND       PIC 9(02).
        10  WS-CURRENT-MILLISECONDS PIC 9(02).

MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA.
```

**Java:**
```java
public class CurrentDateTime {
    private int year;
    private int month;
    private int day;
    private int hours;
    private int minutes;
    private int seconds;
    private int milliseconds;
    
    public static CurrentDateTime now() {
        CurrentDateTime dt = new CurrentDateTime();
        LocalDateTime now = LocalDateTime.now();
        dt.year = now.getYear();
        dt.month = now.getMonthValue();
        dt.day = now.getDayOfMonth();
        dt.hours = now.getHour();
        dt.minutes = now.getMinute();
        dt.seconds = now.getSecond();
        dt.milliseconds = now.getNano() / 1_000_000;
        return dt;
    }
}

// Or just use LocalDateTime directly
LocalDateTime now = LocalDateTime.now();
int year = now.getYear();
int month = now.getMonthValue();
// etc.
```

## Complex Structures

### Group Items (Nested Structures)

**COBOL:**
```cobol
01  CUSTOMER-RECORD.
    05  CUSTOMER-ID           PIC 9(8).
    05  CUSTOMER-NAME.
        10  FIRST-NAME        PIC X(15).
        10  LAST-NAME         PIC X(20).
    05  CUSTOMER-ADDRESS.
        10  STREET            PIC X(25).
        10  CITY              PIC X(20).
        10  STATE             PIC XX.
        10  ZIP               PIC 9(5).
    05  ACCOUNT-INFO.
        10  BALANCE           PIC S9(7)V99 COMP-3.
        10  CREDIT-LIMIT      PIC S9(7)V99 COMP-3.
```

**Java:**
```java
@Entity
@Table(name = "customers")
public class Customer {
    
    @Id
    private Long customerId;
    
    @Embedded
    private CustomerName name;
    
    @Embedded
    private Address address;
    
    @Embedded
    private AccountInfo accountInfo;
}

@Embeddable
public class CustomerName {
    @Column(length = 15)
    private String firstName;
    
    @Column(length = 20)
    private String lastName;
}

@Embeddable
public class Address {
    @Column(length = 25)
    private String street;
    
    @Column(length = 20)
    private String city;
    
    @Column(length = 2)
    private String state;
    
    @Column(length = 5)
    private String zip;
}

@Embeddable
public class AccountInfo {
    @Column(precision = 9, scale = 2)
    private BigDecimal balance;
    
    @Column(precision = 9, scale = 2)
    private BigDecimal creditLimit;
}
```

### Arrays (OCCURS Clause)

**COBOL:**
```cobol
01  MONTHLY-SALES.
    05  MONTH-AMOUNT       PIC S9(7)V99 COMP-3 OCCURS 12 TIMES.

01  EMPLOYEE-TABLE.
    05  EMPLOYEE-ENTRY     OCCURS 100 TIMES.
        10  EMP-ID         PIC 9(6).
        10  EMP-NAME       PIC X(30).
        10  EMP-SALARY     PIC S9(7)V99 COMP-3.
```

**Java:**
```java
// Option 1: Arrays (fixed size)
private BigDecimal[] monthlySales = new BigDecimal[12];

// Option 2: List (dynamic size) - RECOMMENDED
private List<BigDecimal> monthlySales = new ArrayList<>();

// For complex structures, use List of objects
@Entity
public class Department {
    @OneToMany(mappedBy = "department")
    private List<Employee> employees = new ArrayList<>();
}

@Entity
public class Employee {
    @Id
    private Long empId;
    
    @Column(length = 30)
    private String empName;
    
    @Column(precision = 9, scale = 2)
    private BigDecimal empSalary;
    
    @ManyToOne
    private Department department;
}
```

### REDEFINES Clause

**COBOL:**
```cobol
01  INPUT-RECORD.
    05  RECORD-TYPE        PIC X.
        88  TYPE-CUSTOMER  VALUE 'C'.
        88  TYPE-ORDER     VALUE 'O'.
    05  RECORD-DATA        PIC X(99).
    05  CUSTOMER-DATA      REDEFINES RECORD-DATA.
        10  CUST-NAME      PIC X(30).
        10  CUST-ADDR      PIC X(69).
    05  ORDER-DATA         REDEFINES RECORD-DATA.
        10  ORDER-NUM      PIC 9(8).
        10  ORDER-DATE     PIC 9(8).
        10  FILLER         PIC X(83).
```

**Java:**
```java
// Use inheritance or polymorphism
public abstract class Record {
    protected char recordType;
    
    public abstract void process();
}

public class CustomerRecord extends Record {
    private String custName;
    private String custAddr;
}

public class OrderRecord extends Record {
    private int orderNum;
    private LocalDate orderDate;
}

// Or use discriminator in JPA
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "record_type", length = 1)
public abstract class Record {
    @Id
    private Long id;
    
    @Column(name = "record_type", insertable = false, updatable = false)
    private char recordType;
}

@Entity
@DiscriminatorValue("C")
public class CustomerRecord extends Record {
    private String custName;
    private String custAddr;
}

@Entity
@DiscriminatorValue("O")
public class OrderRecord extends Record {
    private int orderNum;
    private LocalDate orderDate;
}
```

### Condition Names (88-level)

**COBOL:**
```cobol
05  ACCOUNT-STATUS     PIC X.
    88  ACTIVE         VALUE 'A'.
    88  SUSPENDED      VALUE 'S'.
    88  CLOSED         VALUE 'C'.
    88  VALID-STATUS   VALUES 'A' 'S' 'C'.

* Usage
IF ACTIVE
   PERFORM PROCESS-ACTIVE-ACCOUNT
END-IF

SET SUSPENDED TO TRUE.
```

**Java:**
```java
public enum AccountStatus {
    ACTIVE('A'),
    SUSPENDED('S'),
    CLOSED('C');
    
    private final char code;
    
    AccountStatus(char code) {
        this.code = code;
    }
    
    public char getCode() {
        return code;
    }
    
    public static AccountStatus fromCode(char code) {
        for (AccountStatus status : values()) {
            if (status.code == code) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid status code: " + code);
    }
    
    public boolean isValid() {
        return true; // All enum values are valid
    }
}

// Usage
if (account.getStatus() == AccountStatus.ACTIVE) {
    processActiveAccount();
}

account.setStatus(AccountStatus.SUSPENDED);
```

## File Layouts

### Fixed-Length Record

**COBOL:**
```cobol
FD  ACCOUNT-FILE
    RECORD CONTAINS 161 CHARACTERS
    RECORDING MODE F.

01  ACCOUNT-RECORD.
    05  ACCT-NO            PIC X(8).
    05  ACCT-LIMIT         PIC S9(7)V99 COMP-3.
    05  ACCT-BALANCE       PIC S9(7)V99 COMP-3.
    05  LAST-NAME          PIC X(20).
    05  FIRST-NAME         PIC X(15).
    05  STREET-ADDR        PIC X(25).
    05  CITY-COUNTY        PIC X(20).
    05  USA-STATE          PIC X(15).
    05  RESERVED           PIC X(7).
    05  COMMENTS           PIC X(50).
```

**Java Parser:**
```java
public class FixedLengthRecordParser {
    
    private static final int RECORD_LENGTH = 161;
    
    public AccountRecord parseRecord(String line) {
        if (line.length() < RECORD_LENGTH) {
            throw new IllegalArgumentException(
                "Record too short: " + line.length());
        }
        
        AccountRecord record = new AccountRecord();
        
        int pos = 0;
        record.setAccountNo(line.substring(pos, pos + 8).trim());
        pos += 8;
        
        // COMP-3 fields would be binary in actual file
        // For text representation, use appropriate parsing
        record.setCreditLimit(parsePackedDecimal(line, pos, 5));
        pos += 5;
        
        record.setBalance(parsePackedDecimal(line, pos, 5));
        pos += 5;
        
        record.setLastName(line.substring(pos, pos + 20).trim());
        pos += 20;
        
        record.setFirstName(line.substring(pos, pos + 15).trim());
        pos += 15;
        
        record.setStreetAddr(line.substring(pos, pos + 25).trim());
        pos += 25;
        
        record.setCityCounty(line.substring(pos, pos + 20).trim());
        pos += 20;
        
        record.setState(line.substring(pos, pos + 15).trim());
        pos += 15;
        
        record.setReserved(line.substring(pos, pos + 7).trim());
        pos += 7;
        
        record.setComments(line.substring(pos, pos + 50).trim());
        
        return record;
    }
    
    private BigDecimal parsePackedDecimal(String data, int offset, int length) {
        // Implementation depends on whether data is binary or text
        // For binary COMP-3, use DataInputStream and bit manipulation
        // For text representation, use appropriate conversion
        throw new UnsupportedOperationException(
            "COMP-3 parsing requires binary data handling");
    }
}
```

### Variable-Length Record

**COBOL:**
```cobol
FD  VARIABLE-FILE
    RECORD IS VARYING IN SIZE FROM 10 TO 200
    DEPENDING ON RECORD-LENGTH.
```

**Java:**
```java
// Variable-length records are natural in Java
public class VariableLengthRecord {
    private String field1;  // Variable length
    private String field2;  // Variable length
    private List<String> repeatingField;  // Variable count
    
    // No fixed size constraints
}
```

## Best Practices

### 1. Always Use BigDecimal for Money

**❌ Wrong:**
```java
double balance = 1234.56;
double interest = balance * 0.05; // Rounding errors!
```

**✅ Correct:**
```java
BigDecimal balance = new BigDecimal("1234.56");
BigDecimal rate = new BigDecimal("0.05");
BigDecimal interest = balance.multiply(rate);
```

### 2. Trim COBOL Strings

**❌ Wrong:**
```java
String name = cobolRecord.substring(0, 20); // Includes spaces!
customer.setName(name); // "Smith               "
```

**✅ Correct:**
```java
String name = cobolRecord.substring(0, 20).trim();
customer.setName(name); // "Smith"
```

### 3. Use Proper Date Types

**❌ Wrong:**
```java
int date = 20251114; // What format? What timezone?
```

**✅ Correct:**
```java
LocalDate date = LocalDate.of(2025, 11, 14);
// Or parse from string
LocalDate date = LocalDate.parse("20251114", 
    DateTimeFormatter.BASIC_ISO_DATE);
```

### 4. Handle Null Values

**COBOL doesn't have null:**
```cobol
05  MIDDLE-INITIAL     PIC X.
* Space means "not provided"
IF MIDDLE-INITIAL = SPACE
   * No middle initial
END-IF
```

**Java has null:**
```java
private String middleInitial; // Can be null

// When reading from COBOL
String mi = cobolData.substring(pos, pos + 1).trim();
customer.setMiddleInitial(mi.isEmpty() ? null : mi);

// When writing to COBOL
String mi = customer.getMiddleInitial();
String cobolMI = (mi == null) ? " " : mi;
```

### 5. Use Enums for Coded Values

**COBOL:**
```cobol
05  TRANSACTION-TYPE   PIC X.
    88  DEPOSIT        VALUE 'D'.
    88  WITHDRAWAL     VALUE 'W'.
    88  TRANSFER       VALUE 'T'.
```

**Java:**
```java
public enum TransactionType {
    DEPOSIT('D'),
    WITHDRAWAL('W'),
    TRANSFER('T');
    
    private final char code;
    
    // Constructor, getters, fromCode() method
}
```

### 6. Validate Data

**COBOL has implicit validation:**
```cobol
05  QUANTITY    PIC 9(5).  * Compiler enforces numeric
```

**Java needs explicit validation:**
```java
@Entity
public class OrderItem {
    
    @Min(0)
    @Max(99999)
    @Column(nullable = false)
    private Integer quantity;
    
    public void setQuantity(Integer quantity) {
        if (quantity == null || quantity < 0 || quantity > 99999) {
            throw new IllegalArgumentException(
                "Quantity must be between 0 and 99999");
        }
        this.quantity = quantity;
    }
}
```

## Summary

### Quick Reference Table

| COBOL | Java | Notes |
|-------|------|-------|
| `PIC 9(n)` | `int`, `long`, `BigInteger` | Choose by size |
| `PIC S9(n)V99 COMP-3` | `BigDecimal` | Always for money |
| `PIC X(n)` | `String` | Remember to trim |
| `PIC A(n)` | `String` + validation | Add regex check |
| `COMP` / `COMP-4` | `short`, `int`, `long` | By digit count |
| `COMP-1` | `float` | Avoid for business |
| `COMP-2` | `double` | Avoid for business |
| `OCCURS n TIMES` | `List<T>` or array | Prefer List |
| `88-level` | `enum` | Type-safe |
| Date fields | `LocalDate`, `LocalDateTime` | Not int! |
| `REDEFINES` | Inheritance/polymorphism | Use OOP |

> [!TIP]
> When in doubt, use `String` and `BigDecimal`. They're flexible and safe. Optimize later if needed.

> [!NOTE]
> This guide covers common scenarios. For complex COMP-3 parsing or specialized formats, additional libraries or custom code may be needed.
