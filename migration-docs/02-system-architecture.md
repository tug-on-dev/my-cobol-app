# System Architecture Analysis

This document provides a comprehensive analysis of the current COBOL/JCL system architecture and data flow patterns.

## Current System Architecture

### High-Level Architecture

```mermaid
graph TB
    subgraph "z/OS Mainframe Environment"
        JCL[JCL Job Control]
        COBOL[COBOL Programs]
        DATA[Sequential Data Files]
        DB2[(DB2 Database)]
        PRINT[Print Output]
    end
    
    subgraph "External Systems"
        BATCH[Batch Scheduler]
        USERS[End Users]
    end
    
    BATCH --> JCL
    JCL --> COBOL
    COBOL --> DATA
    COBOL --> DB2
    COBOL --> PRINT
    PRINT --> USERS
    
    style JCL fill:#e1f5fe
    style COBOL fill:#f3e5f5
    style DATA fill:#e8f5e8
    style DB2 fill:#fff3e0
```

### Current Processing Model

The existing system follows a traditional mainframe batch processing model:

1. **Job Submission**: JCL jobs are submitted to the z/OS job scheduler
2. **Compilation**: COBOL programs are compiled using IBM Enterprise COBOL
3. **Execution**: Compiled programs process sequential files and/or database records
4. **Output Generation**: Results are written to output files or printed reports

### Data Flow Architecture

```mermaid
flowchart LR
    subgraph "Input Layer"
        SEQFILE[Sequential Files<br/>EBCDIC Format<br/>Fixed Length Records]
        DBINPUT[DB2 Tables<br/>Account Data<br/>Transactional Records]
    end
    
    subgraph "Processing Layer"
        PROG1[File Processing Programs<br/>CBL0001-CBL0012]
        PROG2[Database Programs<br/>CBLDB21-CBLDB23]
        PROG3[Utility Programs<br/>Search, Calculate]
    end
    
    subgraph "Output Layer"
        REPORTS[Formatted Reports<br/>Financial Statements<br/>Account Listings]
        SEQOUT[Updated Sequential Files<br/>Processed Data]
        DBOUT[Updated DB2 Tables<br/>Modified Records]
    end
    
    SEQFILE --> PROG1
    DBINPUT --> PROG2
    SEQFILE --> PROG3
    
    PROG1 --> REPORTS
    PROG1 --> SEQOUT
    PROG2 --> REPORTS
    PROG2 --> DBOUT
    PROG3 --> REPORTS
    
    style SEQFILE fill:#ffebee
    style DBINPUT fill:#e3f2fd
    style REPORTS fill:#e8f5e8
```

## Program Classification and Architecture

### 1. Basic File Processing Programs

These programs follow the classic COBOL file processing pattern:

```mermaid
sequenceDiagram
    participant JCL as JCL Job
    participant COBOL as COBOL Program
    participant INPUT as Input File
    participant OUTPUT as Output File
    
    JCL->>COBOL: Execute Program
    COBOL->>INPUT: OPEN INPUT
    COBOL->>OUTPUT: OPEN OUTPUT
    
    loop For Each Record
        COBOL->>INPUT: READ RECORD
        INPUT-->>COBOL: Record Data
        COBOL->>COBOL: Process Data
        COBOL->>OUTPUT: WRITE RECORD
    end
    
    COBOL->>INPUT: CLOSE
    COBOL->>OUTPUT: CLOSE
    COBOL-->>JCL: Return Code
```

**Programs in this category:**
- CBL0001: Account record processing
- CBL0006: State filtering
- CBL0009-CBL0012: Financial reporting

### 2. Database Processing Programs

Advanced programs that interact with DB2 databases:

```mermaid
sequenceDiagram
    participant JCL as JCL Job
    participant COBOL as COBOL Program
    participant DB2 as DB2 Database
    participant REPORT as Report Output
    
    JCL->>COBOL: Execute Program
    COBOL->>DB2: CONNECT
    
    loop SQL Operations
        COBOL->>DB2: SELECT/INSERT/UPDATE
        DB2-->>COBOL: Result Set/Status
        COBOL->>COBOL: Process Results
    end
    
    COBOL->>REPORT: Generate Report
    COBOL->>DB2: COMMIT/ROLLBACK
    COBOL-->>JCL: Return Code
```

**Programs in this category:**
- CBLDB21: Basic DB2 operations
- CBLDB22: Advanced queries
- CBLDB23: Complex processing

### 3. Utility and Calculation Programs

Special-purpose programs for specific business functions:

```mermaid
graph LR
    INPUT[Input Data] --> CALC[Calculation Logic]
    CALC --> VALIDATION[Data Validation]
    VALIDATION --> OUTPUT[Formatted Output]
    
    subgraph "Utility Functions"
        SEARCH[Search Algorithms]
        MATH[Mathematical Operations]
        FORMAT[Data Formatting]
    end
    
    CALC --> SEARCH
    CALC --> MATH
    CALC --> FORMAT
```

**Programs in this category:**
- ADDAMT: Amount calculations
- SRCHBIN/SRCHSER: Search algorithms
- PAYROL00/PAYROL0X: Payroll calculations

## Data Architecture

### Data Storage Patterns

```mermaid
erDiagram
    ACCOUNT ||--|| CUSTOMER : "belongs to"
    ACCOUNT {
        string ACCT_NO PK "8 characters"
        decimal ACCT_LIMIT "S9(7)V99 COMP-3"
        decimal ACCT_BALANCE "S9(7)V99 COMP-3"
        string COMMENTS "50 characters"
    }
    
    CUSTOMER {
        string LAST_NAME "20 characters"
        string FIRST_NAME "15 characters"
        string STREET_ADDR "25 characters"
        string CITY_COUNTY "20 characters"
        string STATE "15 characters"
    }
    
    TRANSACTION ||--}| ACCOUNT : "updates"
    TRANSACTION {
        string TRANS_ID PK
        string ACCT_NO FK
        decimal AMOUNT
        date TRANS_DATE
        string TRANS_TYPE
    }
```

### File Processing Patterns

1. **Sequential File Access**
   - Files are processed record by record
   - Fixed-length records with EBCDIC encoding
   - Packed decimal (COMP-3) for numeric fields

2. **Database Access**
   - Embedded SQL in COBOL programs
   - DB2 database with standard SQL operations
   - Transaction management with COMMIT/ROLLBACK

3. **Report Generation**
   - Formatted output to SYSOUT
   - Header/detail/trailer patterns
   - Fixed-width columnar reports

## Integration Points

### External System Interfaces

```mermaid
graph TB
    subgraph "Current System"
        MAINFRAME[z/OS Mainframe]
        COBOL[COBOL Applications]
        DB2[DB2 Database]
        FILES[Sequential Files]
    end
    
    subgraph "External Interfaces"
        SCHEDULER[Job Scheduler]
        REPORTS[Report Distribution]
        BACKUP[Backup Systems]
        MONITOR[System Monitoring]
    end
    
    SCHEDULER --> MAINFRAME
    MAINFRAME --> REPORTS
    MAINFRAME --> BACKUP
    MAINFRAME --> MONITOR
    
    subgraph "Data Interfaces"
        IMPORT[Data Import]
        EXPORT[Data Export]
        ARCHIVE[Data Archival]
    end
    
    IMPORT --> FILES
    FILES --> EXPORT
    FILES --> ARCHIVE
```

## Performance Characteristics

### Current System Performance Profile

1. **Batch Processing Windows**
   - Most processing occurs during scheduled batch windows
   - Large volume processing capabilities
   - Sequential processing optimization

2. **Resource Utilization**
   - CPU-intensive operations for data processing
   - I/O-intensive for file operations
   - Memory usage optimized for record-at-a-time processing

3. **Scalability Limitations**
   - Vertical scaling only (more powerful mainframe hardware)
   - Limited concurrent processing
   - Batch-oriented processing model

## Security Model

### Current Security Architecture

```mermaid
graph TB
    subgraph "Security Layers"
        RACF[RACF Security]
        DATASET[Dataset Permissions]
        JOB[Job-Level Security]
        PROG[Program Authorization]
    end
    
    subgraph "Access Control"
        USER[User Authentication]
        ROLE[Role-Based Access]
        AUDIT[Audit Logging]
    end
    
    USER --> RACF
    RACF --> DATASET
    RACF --> JOB
    JOB --> PROG
    
    RACF --> ROLE
    ROLE --> AUDIT
```

### Security Features

1. **Authentication**: RACF-based user authentication
2. **Authorization**: Dataset and program-level permissions
3. **Auditing**: Job execution and data access logging
4. **Data Protection**: EBCDIC encoding and mainframe isolation

## Migration Implications

### Architecture Transformation Requirements

1. **Processing Model Change**
   - From batch-oriented to real-time capable
   - From sequential to random access patterns
   - From single-threaded to multi-threaded processing

2. **Data Access Transformation**
   - From file-based to database-centric
   - From EBCDIC to UTF-8 encoding
   - From fixed-length to variable-length records

3. **Integration Requirements**
   - RESTful API endpoints for external integration
   - Real-time data validation and processing
   - Event-driven architecture capabilities

4. **Scalability Requirements**
   - Horizontal scaling capabilities
   - Cloud-native deployment options
   - Microservices architecture readiness

---

*This architecture analysis provides the foundation for designing the target Spring Boot system architecture.*