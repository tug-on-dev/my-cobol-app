# Data Mapping: COBOL to Java/JPA

This document provides detailed mapping of COBOL data structures to Java/JPA entities, including data type conversions, field mappings, and transformation rules.

## Data Type Mappings

### COBOL to Java Type Conversions

| COBOL Picture Clause | Java Type | JPA Annotation | Notes |
|---------------------|-----------|----------------|-------|
| `PIC X(n)` | `String` | `@Column(length=n)` | Fixed-length strings, trim spaces |
| `PIC 9(n)` | `Integer`, `Long` | `@Column` | Numeric, choose based on size |
| `PIC S9(n)` | `Integer`, `Long` | `@Column` | Signed numeric |
| `PIC S9(n)V99 COMP-3` | `BigDecimal` | `@Column(precision=n+2, scale=2)` | Packed decimal monetary |
| `PIC S9(n) COMP` | `Integer`, `Long` | `@Column` | Binary integers |
| `PIC S9(n) COMP-1` | `Float` | `@Column` | Single precision floating |
| `PIC S9(n) COMP-2` | `Double` | `@Column` | Double precision floating |

### Special Conversions

#### COMP-3 Packed Decimal Conversion
```java
// COBOL: PIC S9(7)V99 COMP-3
// Java: BigDecimal with specific precision and scale
@Column(precision = 9, scale = 2)
private BigDecimal amount;

// Conversion logic for COMP-3 to BigDecimal
public static BigDecimal convertComp3ToDecimal(byte[] comp3Bytes, int precision, int scale) {
    // Implementation for packed decimal conversion
    return new BigDecimal(unpackComp3(comp3Bytes)).setScale(scale);
}
```

#### Date/Time Conversions
```java
// COBOL date fields (various formats)
// PIC 9(8) YYYYMMDD format
@Column
private LocalDate dateField;

// PIC 9(14) YYYYMMDDHHMMSS format
@Column
private LocalDateTime timestampField;

// Conversion utility
public static LocalDate convertCobolDate(String cobolDate) {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
    return LocalDate.parse(cobolDate, formatter);
}
```

## Entity Mappings

### Account Entity Mapping

#### COBOL Account Record (CBL0001)
```cobol
01  ACCT-FIELDS.
    05  ACCT-NO            PIC X(8).
    05  ACCT-LIMIT         PIC S9(7)V99 COMP-3.
    05  ACCT-BALANCE       PIC S9(7)V99 COMP-3.
    05  LAST-NAME          PIC X(20).
    05  FIRST-NAME         PIC X(15).
    05  CLIENT-ADDR.
        10  STREET-ADDR    PIC X(25).
        10  CITY-COUNTY    PIC X(20).
        10  USA-STATE      PIC X(15).
    05  RESERVED           PIC X(7).
    05  COMMENTS           PIC X(50).
```

#### Java/JPA Account Entity
```java
@Entity
@Table(name = "accounts")
public class Account {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "account_number", unique = true, length = 8, nullable = false)
    private String accountNumber; // ACCT-NO
    
    @Column(name = "account_limit", precision = 9, scale = 2)
    private BigDecimal accountLimit; // ACCT-LIMIT
    
    @Column(name = "account_balance", precision = 9, scale = 2)
    private BigDecimal accountBalance; // ACCT-BALANCE
    
    @Column(name = "comments", length = 50)
    private String comments; // COMMENTS
    
    @Column(name = "reserved_field", length = 7)
    private String reservedField; // RESERVED
    
    @Column(name = "created_date")
    private LocalDateTime createdDate;
    
    @Column(name = "modified_date")
    private LocalDateTime modifiedDate;
    
    @OneToOne(mappedBy = "account", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Customer customer;
    
    @OneToMany(mappedBy = "account", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Transaction> transactions = new ArrayList<>();
    
    // Constructors, getters, setters, equals, hashCode
}
```

### Customer Entity Mapping

#### Java/JPA Customer Entity
```java
@Entity
@Table(name = "customers")
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "first_name", length = 15, nullable = false)
    private String firstName; // FIRST-NAME
    
    @Column(name = "last_name", length = 20, nullable = false)
    private String lastName; // LAST-NAME
    
    @Column(name = "email", length = 100)
    private String email; // New field for modern requirements
    
    @Column(name = "phone", length = 20)
    private String phone; // New field for modern requirements
    
    @OneToOne
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;
    
    @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Address> addresses = new ArrayList<>();
    
    // Helper method for full name (equivalent to COBOL concatenation)
    public String getFullName() {
        return firstName + " " + lastName;
    }
}
```

### Address Entity Mapping

#### Java/JPA Address Entity
```java
@Entity
@Table(name = "addresses")
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "street_address", length = 25)
    private String streetAddress; // STREET-ADDR
    
    @Column(name = "city_county", length = 20)
    private String cityCounty; // CITY-COUNTY
    
    @Column(name = "state", length = 15)
    private String state; // USA-STATE
    
    @Column(name = "zip_code", length = 10)
    private String zipCode; // New field
    
    @Column(name = "country", length = 50, nullable = false)
    private String country = "USA"; // Default value
    
    @Enumerated(EnumType.STRING)
    @Column(name = "address_type")
    private AddressType addressType = AddressType.PRIMARY;
    
    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;
}

enum AddressType {
    PRIMARY, BILLING, SHIPPING, MAILING
}
```

### Database Schema Mapping (DB2 to PostgreSQL)

#### DB2 Table Structure (CRETBL.jcl)
```sql
CREATE TABLE &SYSUID.T (
    ACCTNO    CHAR(8)        NOT NULL,
    LIMIT     DECIMAL(9,2)           ,
    BALANCE   DECIMAL(9,2)           ,
    SURNAME   CHAR(20)       NOT NULL,
    FIRSTN    CHAR(15)       NOT NULL,
    ADDRESS1  CHAR(25)               ,
    ADDRESS2  CHAR(20)               ,
    ADDRESS3  CHAR(15)               ,
    RESERVED  CHAR(7)                ,
    COMMENTS  CHAR(50)               ,
    PRIMARY KEY(ACCTNO)
)
```

#### PostgreSQL Schema
```sql
-- Accounts table
CREATE TABLE accounts (
    id BIGSERIAL PRIMARY KEY,
    account_number VARCHAR(8) UNIQUE NOT NULL,
    account_limit DECIMAL(9,2),
    account_balance DECIMAL(9,2),
    comments VARCHAR(50),
    reserved_field VARCHAR(7),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers table
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES accounts(id),
    first_name VARCHAR(15) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Addresses table
CREATE TABLE addresses (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    street_address VARCHAR(25),
    city_county VARCHAR(20),
    state VARCHAR(15),
    zip_code VARCHAR(10),
    country VARCHAR(50) DEFAULT 'USA',
    address_type VARCHAR(20) DEFAULT 'PRIMARY',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions table (new for modern requirements)
CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES accounts(id),
    transaction_date TIMESTAMP NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    description VARCHAR(100),
    reference_number VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Data Transformation Utilities

### EBCDIC to UTF-8 Conversion
```java
@Component
public class DataConversionUtil {
    
    private static final Charset EBCDIC = Charset.forName("Cp037");
    private static final Charset UTF8 = StandardCharsets.UTF_8;
    
    public String convertEbcdicToUtf8(byte[] ebcdicData) {
        return new String(ebcdicData, EBCDIC).trim();
    }
    
    public byte[] convertUtf8ToEbcdic(String utf8String) {
        return utf8String.getBytes(EBCDIC);
    }
}
```

### COMP-3 Packed Decimal Conversion
```java
@Component
public class PackedDecimalUtil {
    
    public BigDecimal convertComp3(byte[] packedBytes, int scale) {
        if (packedBytes == null || packedBytes.length == 0) {
            return BigDecimal.ZERO;
        }
        
        StringBuilder digits = new StringBuilder();
        boolean isNegative = false;
        
        for (int i = 0; i < packedBytes.length; i++) {
            int b = packedBytes[i] & 0xFF;
            
            if (i == packedBytes.length - 1) {
                // Last byte contains the sign
                digits.append((b >> 4) & 0x0F);
                int sign = b & 0x0F;
                isNegative = (sign == 0x0D || sign == 0x0B);
            } else {
                // Regular bytes contain two digits
                digits.append((b >> 4) & 0x0F);
                digits.append(b & 0x0F);
            }
        }
        
        BigDecimal result = new BigDecimal(digits.toString()).setScale(scale);
        return isNegative ? result.negate() : result;
    }
    
    public byte[] convertToComp3(BigDecimal decimal, int totalDigits) {
        // Implementation for converting BigDecimal to COMP-3 format
        // Useful for reverse migration or interfacing with legacy systems
        String digits = decimal.abs().setScale(0).toString();
        // ... pack digits into bytes with sign
        return new byte[0]; // Placeholder
    }
}
```

## Migration Data Mapping Rules

### Field-Level Mapping Rules

#### String Fields
```java
// Rule: Trim trailing spaces from COBOL fixed-length fields
public String mapCobolString(String cobolField) {
    return cobolField != null ? cobolField.trim() : null;
}
```

#### Numeric Fields
```java
// Rule: Convert COBOL display numeric to Java numeric types
public Integer mapCobolNumeric(String cobolNumeric) {
    return cobolNumeric != null && !cobolNumeric.trim().isEmpty() ? 
           Integer.valueOf(cobolNumeric.trim()) : null;
}
```

#### Date Fields
```java
// Rule: Convert COBOL date formats to Java LocalDate
public LocalDate mapCobolDate(String cobolDate) {
    if (cobolDate == null || cobolDate.trim().isEmpty() || "00000000".equals(cobolDate)) {
        return null;
    }
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
    return LocalDate.parse(cobolDate.trim(), formatter);
}
```

### Business Logic Mapping

#### Account Balance Calculations
```java
// COBOL equivalent logic for balance calculations
@Service
public class AccountCalculationService {
    
    // Equivalent to COBOL COMPUTE statements
    public BigDecimal calculateAvailableBalance(Account account) {
        BigDecimal balance = account.getAccountBalance();
        BigDecimal limit = account.getAccountLimit();
        
        if (balance.compareTo(BigDecimal.ZERO) >= 0) {
            return balance.add(limit);
        } else {
            return limit.add(balance); // balance is negative
        }
    }
    
    // Equivalent to COBOL conditional processing
    public String determineAccountStatus(Account account) {
        BigDecimal balance = account.getAccountBalance();
        BigDecimal limit = account.getAccountLimit();
        
        if (balance.compareTo(limit.negate()) < 0) {
            return "OVERLIMIT";
        } else if (balance.compareTo(BigDecimal.ZERO) < 0) {
            return "NEGATIVE";
        } else {
            return "POSITIVE";
        }
    }
}
```

## Validation and Data Quality

### Data Validation Rules
```java
@Component
public class DataValidator {
    
    // Validate account number format (8 alphanumeric characters)
    public boolean isValidAccountNumber(String accountNumber) {
        return accountNumber != null && 
               accountNumber.matches("[A-Z0-9]{8}");
    }
    
    // Validate monetary amounts (non-null, non-negative for limits)
    public boolean isValidAccountLimit(BigDecimal limit) {
        return limit != null && limit.compareTo(BigDecimal.ZERO) >= 0;
    }
    
    // Validate required customer fields
    public boolean isValidCustomer(Customer customer) {
        return customer != null &&
               StringUtils.hasText(customer.getFirstName()) &&
               StringUtils.hasText(customer.getLastName());
    }
}
```

### Data Migration Verification
```java
@Component
public class MigrationVerifier {
    
    public boolean verifyRecordCounts(String tableName, long expectedCount) {
        // Verify that migrated record counts match source
        long actualCount = entityManager
            .createQuery("SELECT COUNT(*) FROM " + tableName)
            .getSingleResult();
        return actualCount == expectedCount;
    }
    
    public boolean verifyDataIntegrity(Account account) {
        // Verify business rules are maintained
        return account.getAccountNumber() != null &&
               account.getCustomer() != null &&
               account.getAccountBalance() != null;
    }
}
```

## Performance Considerations

### Indexing Strategy
```sql
-- Performance indexes for migrated data
CREATE INDEX idx_account_number ON accounts(account_number);
CREATE INDEX idx_customer_name ON customers(last_name, first_name);
CREATE INDEX idx_account_balance ON accounts(account_balance);
CREATE INDEX idx_transaction_date ON transactions(transaction_date);
CREATE INDEX idx_transaction_account ON transactions(account_id);
```

### Batch Processing Optimization
```java
// Optimize batch operations for large data migrations
@Service
public class BatchMigrationService {
    
    @Transactional
    public void migrateBatch(List<CobolRecord> cobolRecords) {
        List<Account> accounts = new ArrayList<>();
        
        for (CobolRecord record : cobolRecords) {
            Account account = convertToAccount(record);
            accounts.add(account);
            
            // Batch insert every 1000 records
            if (accounts.size() >= 1000) {
                accountRepository.saveAll(accounts);
                entityManager.flush();
                entityManager.clear();
                accounts.clear();
            }
        }
        
        // Save remaining records
        if (!accounts.isEmpty()) {
            accountRepository.saveAll(accounts);
        }
    }
}
```

This data mapping strategy ensures accurate transformation of COBOL data structures to modern Java/JPA entities while maintaining data integrity and business logic consistency.