# Database Integration Analysis

## DB2 Integration Overview

The current system uses DB2 for z/OS with embedded SQL in COBOL programs for database operations. This section analyzes the database integration patterns and migration requirements.

## Current DB2 Architecture

```mermaid
graph TB
    subgraph "DB2 for z/OS Environment"
        DB2SYS[DB2 System]
        DBRMLIB[DBRM Library]
        PLANS[DB2 Plans]
        PACKAGES[DB2 Packages]
    end
    
    subgraph "COBOL Programs"
        CBLDB21[CBLDB21 - Query]
        CBLDB22[CBLDB22 - Update]  
        CBLDB23[CBLDB23 - Reports]
    end
    
    subgraph "Database Objects"
        TABLES[DB2 Tables]
        INDEXES[DB2 Indexes]
        VIEWS[DB2 Views]
        PROCS[Stored Procedures]
    end
    
    CBLDB21 --> DBRMLIB
    CBLDB22 --> DBRMLIB
    CBLDB23 --> DBRMLIB
    
    DBRMLIB --> PLANS
    PLANS --> PACKAGES
    
    PACKAGES --> TABLES
    PACKAGES --> INDEXES
    PACKAGES --> VIEWS
    PACKAGES --> PROCS
```

## SQL Integration Patterns

### 1. CBLDB21 - Database Query Operations

```mermaid
sequenceDiagram
    participant COBOL as CBLDB21 Program
    participant SQLCA as SQL Communication Area
    participant DB2 as DB2 Database
    participant CURSOR as Result Cursor
    
    COBOL->>DB2: EXEC SQL CONNECT
    DB2-->>SQLCA: Connection Status
    
    COBOL->>DB2: EXEC SQL DECLARE CURSOR
    COBOL->>DB2: EXEC SQL OPEN CURSOR
    
    loop Process Results
        COBOL->>CURSOR: EXEC SQL FETCH
        CURSOR-->>COBOL: Row Data
        COBOL->>COBOL: Process Row
        COBOL->>SQLCA: Check SQLCODE
    end
    
    COBOL->>CURSOR: EXEC SQL CLOSE
    COBOL->>DB2: EXEC SQL COMMIT
```

#### Sample SQL Operations:
```cobol
EXEC SQL
    SELECT ACCT_NO, ACCT_LIMIT, ACCT_BALANCE, LAST_NAME
    FROM ACCOUNT_TABLE
    WHERE ACCT_BALANCE > :WS-BALANCE-THRESHOLD
END-EXEC.

EXEC SQL
    DECLARE ACCT_CURSOR CURSOR FOR
    SELECT * FROM ACCOUNT_TABLE
    WHERE ACCT_STATUS = 'A'
    ORDER BY ACCT_NO
END-EXEC.
```

### 2. CBLDB22 - Database Update Operations

```mermaid
flowchart TD
    START([Start Transaction])
    CONNECT[Connect to DB2]
    BEGIN[Begin Transaction]
    
    VALIDATE[Validate Input Data]
    INSERT[Execute INSERT]
    UPDATE[Execute UPDATE]
    DELETE[Execute DELETE]
    
    CHECK{SQL Success?}
    COMMIT[Commit Transaction]
    ROLLBACK[Rollback Transaction]
    ERROR[Handle Error]
    END([End Transaction])
    
    START --> CONNECT
    CONNECT --> BEGIN
    BEGIN --> VALIDATE
    
    VALIDATE --> INSERT
    INSERT --> CHECK
    
    VALIDATE --> UPDATE  
    UPDATE --> CHECK
    
    VALIDATE --> DELETE
    DELETE --> CHECK
    
    CHECK -->|Success| COMMIT
    CHECK -->|Error| ROLLBACK
    
    COMMIT --> END
    ROLLBACK --> ERROR
    ERROR --> END
```

#### Sample Update Operations:
```cobol
EXEC SQL
    INSERT INTO ACCOUNT_TABLE
    (ACCT_NO, ACCT_LIMIT, ACCT_BALANCE, LAST_NAME, FIRST_NAME)
    VALUES (:WS-ACCT-NO, :WS-ACCT-LIMIT, :WS-ACCT-BALANCE,
            :WS-LAST-NAME, :WS-FIRST-NAME)
END-EXEC.

EXEC SQL
    UPDATE ACCOUNT_TABLE
    SET ACCT_BALANCE = :WS-NEW-BALANCE,
        LAST_UPDATE_DATE = CURRENT_DATE
    WHERE ACCT_NO = :WS-ACCT-NO
END-EXEC.
```

### 3. CBLDB23 - Report Generation

```mermaid
graph TB
    subgraph "Report Generation Process"
        QUERY[Complex Query Execution]
        AGGREGATE[Data Aggregation]
        FORMAT[Report Formatting]
        OUTPUT[Output Generation]
    end
    
    subgraph "Data Sources"
        ACCOUNT[Account Table]
        TRANS[Transaction Table]
        HISTORY[History Table]
    end
    
    ACCOUNT --> QUERY
    TRANS --> QUERY
    HISTORY --> QUERY
    
    QUERY --> AGGREGATE
    AGGREGATE --> FORMAT
    FORMAT --> OUTPUT
```

## Database Schema Analysis

### Current DB2 Table Structures

```mermaid
erDiagram
    ACCOUNT_TABLE ||--o{ TRANSACTION_TABLE : has
    ACCOUNT_TABLE ||--o{ ACCOUNT_HISTORY : tracks
    CUSTOMER_TABLE ||--|| ACCOUNT_TABLE : owns
    
    ACCOUNT_TABLE {
        char ACCT_NO "VARCHAR(8) PRIMARY KEY"
        decimal ACCT_LIMIT "DECIMAL(9,2)"
        decimal ACCT_BALANCE "DECIMAL(9,2)"
        char LAST_NAME "VARCHAR(20)"
        char FIRST_NAME "VARCHAR(15)"
        char STREET_ADDR "VARCHAR(25)"
        char CITY_COUNTY "VARCHAR(20)"
        char USA_STATE "VARCHAR(15)"
        char STATUS_CODE "CHAR(1)"
        date CREATED_DATE "DATE"
        timestamp LAST_UPDATE "TIMESTAMP"
    }
    
    TRANSACTION_TABLE {
        int TRANS_ID "INTEGER PRIMARY KEY"
        char ACCT_NO "VARCHAR(8) FOREIGN KEY"
        decimal TRANS_AMOUNT "DECIMAL(9,2)"
        char TRANS_TYPE "CHAR(1)"
        date TRANS_DATE "DATE"
        timestamp TRANS_TIME "TIMESTAMP"
        char DESCRIPTION "VARCHAR(100)"
        char PROCESSED_BY "VARCHAR(8)"
    }
    
    ACCOUNT_HISTORY {
        char ACCT_NO "VARCHAR(8)"
        date SNAPSHOT_DATE "DATE"
        decimal BALANCE_AMOUNT "DECIMAL(9,2)"
        decimal CREDIT_LIMIT "DECIMAL(9,2)"
        char STATUS "CHAR(1)"
        timestamp CREATED_TIME "TIMESTAMP"
    }
    
    CUSTOMER_TABLE {
        char CUST_ID "VARCHAR(8) PRIMARY KEY"
        char FIRST_NAME "VARCHAR(20)"
        char LAST_NAME "VARCHAR(30)"
        char EMAIL "VARCHAR(50)"
        char PHONE "VARCHAR(15)"
        date BIRTH_DATE "DATE"
        char STATUS "CHAR(1)"
    }
```

## Error Handling Patterns

### SQLCA (SQL Communication Area) Analysis

```mermaid
flowchart TD
    EXECUTE[Execute SQL Statement]
    SQLCODE{Check SQLCODE}
    SUCCESS[SQLCODE = 0]
    WARNING[SQLCODE > 0]
    ERROR[SQLCODE < 0]
    
    HANDLE_SUCCESS[Continue Processing]
    HANDLE_WARNING[Log Warning & Continue]
    HANDLE_ERROR[Error Recovery Logic]
    
    EXECUTE --> SQLCODE
    SQLCODE -->|0| SUCCESS
    SQLCODE -->|Positive| WARNING  
    SQLCODE -->|Negative| ERROR
    
    SUCCESS --> HANDLE_SUCCESS
    WARNING --> HANDLE_WARNING
    ERROR --> HANDLE_ERROR
```

### Common Error Handling Pattern:
```cobol
EXEC SQL
    SELECT COUNT(*) INTO :WS-COUNT
    FROM ACCOUNT_TABLE
    WHERE ACCT_NO = :WS-ACCOUNT-NUMBER
END-EXEC.

EVALUATE SQLCODE
    WHEN 0
        CONTINUE
    WHEN 100
        MOVE 'RECORD NOT FOUND' TO ERROR-MESSAGE
        PERFORM ERROR-ROUTINE
    WHEN OTHER
        MOVE 'DATABASE ERROR' TO ERROR-MESSAGE
        PERFORM FATAL-ERROR-ROUTINE
END-EVALUATE.
```

## Transaction Management

### Transaction Boundaries

```mermaid
sequenceDiagram
    participant App as Application
    participant TM as Transaction Manager
    participant DB2 as Database
    participant Log as Transaction Log
    
    App->>TM: Begin Transaction
    TM->>DB2: START TRANSACTION
    TM->>Log: Log Transaction Start
    
    loop Business Operations
        App->>DB2: SQL Operations
        DB2->>Log: Log Changes
        DB2-->>App: Operation Result
    end
    
    alt Commit Path
        App->>TM: Commit
        TM->>DB2: COMMIT
        DB2->>Log: Log Commit
        TM-->>App: Success
    else Rollback Path
        App->>TM: Rollback
        TM->>DB2: ROLLBACK
        DB2->>Log: Log Rollback
        TM-->>App: Rolled Back
    end
```

## Performance Considerations

### Current Optimization Strategies

1. **Cursor Processing**: Used for large result sets
2. **Index Usage**: Strategic indexing on frequently queried columns
3. **Lock Management**: Appropriate isolation levels
4. **Buffer Pool Management**: Optimized for workload patterns

### Sample Performance Pattern:
```cobol
EXEC SQL
    DECLARE ACCT_CURSOR CURSOR WITH HOLD FOR
    SELECT ACCT_NO, ACCT_BALANCE
    FROM ACCOUNT_TABLE
    WHERE STATUS = 'A'
    ORDER BY ACCT_NO
    OPTIMIZE FOR 1000 ROWS
END-EXEC.
```

## Migration Requirements to Modern Database

### DB2 to PostgreSQL/MySQL Migration

| DB2 Feature | Modern Equivalent | Implementation |
|-------------|------------------|----------------|
| COMP-3 Data | DECIMAL/NUMERIC | BigDecimal in Java |
| EBCDIC Strings | UTF-8 Strings | String conversion |
| Date/Time Functions | SQL Standard Functions | Database-specific functions |
| Stored Procedures | JPA/Hibernate Queries | Repository methods |
| Cursors | Result Set Processing | Stream processing |
| SQLCA Error Handling | Exception Handling | Try-catch blocks |

### Data Type Mapping

| DB2 Type | PostgreSQL | MySQL | Java Type |
|----------|------------|-------|-----------|
| CHAR(n) | CHAR(n) | CHAR(n) | String |
| VARCHAR(n) | VARCHAR(n) | VARCHAR(n) | String |
| DECIMAL(p,s) | DECIMAL(p,s) | DECIMAL(p,s) | BigDecimal |
| INTEGER | INTEGER | INT | Integer |
| SMALLINT | SMALLINT | SMALLINT | Short |
| DATE | DATE | DATE | LocalDate |
| TIMESTAMP | TIMESTAMP | TIMESTAMP | LocalDateTime |
| CLOB | TEXT | TEXT | String/Clob |

### Modern Database Architecture

```mermaid
graph TB
    subgraph "Modern Database Tier"
        POOL[Connection Pool]
        CACHE[Query Cache]
        DB[Database (PostgreSQL/MySQL)]
        REPLICA[Read Replicas]
    end
    
    subgraph "Application Tier"
        SERVICE[Service Layer]
        REPO[Repository Layer]
        JPA[JPA/Hibernate]
        DS[Data Source]
    end
    
    SERVICE --> REPO
    REPO --> JPA
    JPA --> DS
    DS --> POOL
    POOL --> DB
    POOL --> REPLICA
    
    DB --> CACHE
    REPLICA --> CACHE
```

## Spring Boot Integration Pattern

### Repository Layer Design

```java
@Repository
public interface AccountRepository extends JpaRepository<Account, String> {
    
    @Query("SELECT a FROM Account a WHERE a.balance > :threshold")
    List<Account> findAccountsAboveBalance(@Param("threshold") BigDecimal threshold);
    
    @Query("SELECT a FROM Account a WHERE a.status = 'A' ORDER BY a.accountNumber")
    Page<Account> findActiveAccounts(Pageable pageable);
    
    @Modifying
    @Query("UPDATE Account a SET a.balance = :balance, a.lastUpdate = CURRENT_TIMESTAMP WHERE a.accountNumber = :accountNumber")
    int updateAccountBalance(@Param("accountNumber") String accountNumber, 
                           @Param("balance") BigDecimal balance);
}
```

### Service Layer Transaction Management

```java
@Service
@Transactional
public class AccountService {
    
    @Autowired
    private AccountRepository accountRepository;
    
    public void processAccountUpdate(AccountUpdateRequest request) {
        try {
            Account account = accountRepository.findById(request.getAccountNumber())
                .orElseThrow(() -> new AccountNotFoundException("Account not found"));
            
            account.setBalance(request.getNewBalance());
            account.setLastUpdate(LocalDateTime.now());
            
            accountRepository.save(account);
            
        } catch (Exception e) {
            // Exception handling replaces SQLCODE checking
            throw new AccountProcessingException("Failed to update account", e);
        }
    }
}
```

This database integration analysis provides the foundation for migrating from DB2 embedded SQL to modern ORM-based database access patterns in Spring Boot applications.