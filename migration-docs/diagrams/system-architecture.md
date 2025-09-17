# System Architecture and Migration Diagrams

This document contains Mermaid diagrams illustrating the current COBOL system architecture, data flows, and migration planning.

## Current System Architecture

### Overall System Architecture
```mermaid
graph TB
    subgraph "z/OS Mainframe Environment"
        subgraph "Data Storage"
            DS1[Account Data Files<br/>&SYSUID..DATA]
            DS2[Source Code<br/>&SYSUID..CBL]
            DS3[Load Modules<br/>&SYSUID..LOAD]
            DS4[JCL Jobs<br/>&SYSUID..JCL]
            DB[(DB2 Database<br/>Account Tables)]
        end
        
        subgraph "Processing Components"
            JCL[JCL Job Control]
            COMP[COBOL Compiler<br/>IGYCRCTL]
            LINK[Link Editor<br/>IEWBLINK]
            
            subgraph "COBOL Programs"
                P1[CBL0001<br/>File Processing]
                P2[CBL0006<br/>Report Generation]
                P3[PAYROL00<br/>Payroll Calc]
                P4[CBLDB21<br/>DB2 Reports]
                P5[CBLDB22<br/>DB2 Operations]
            end
        end
        
        subgraph "Output"
            RPT[Reports<br/>PRTLINE]
            OUT[System Output<br/>SYSOUT]
        end
    end
    
    DS1 --> P1
    DS1 --> P2
    DB --> P4
    DB --> P5
    DS2 --> COMP
    COMP --> LINK
    LINK --> DS3
    JCL --> COMP
    JCL --> P1
    JCL --> P2
    JCL --> P3
    JCL --> P4
    JCL --> P5
    P1 --> RPT
    P2 --> RPT
    P3 --> OUT
    P4 --> RPT
    P5 --> RPT
```

### Database Entity Relationship Diagram
```mermaid
erDiagram
    ACCOUNT ||--|| CUSTOMER : belongs_to
    CUSTOMER ||--o{ ADDRESS : has
    ACCOUNT ||--o{ TRANSACTION : contains
    
    ACCOUNT {
        char8 acct_no PK
        decimal9_2 acct_limit
        decimal9_2 acct_balance
        char50 comments
        char7 reserved
    }
    
    CUSTOMER {
        char8 acct_no FK
        char20 surname
        char15 first_name
    }
    
    ADDRESS {
        char8 acct_no FK
        char25 address1
        char20 address2
        char15 address3
    }
    
    TRANSACTION {
        char8 acct_no FK
        date transaction_date
        decimal9_2 amount
        char20 transaction_type
        char50 description
    }
```

## Current System Processing Flow

### File Processing Sequence
```mermaid
sequenceDiagram
    participant JCL as JCL Job Control
    participant COMP as COBOL Compiler
    participant PROG as COBOL Program
    participant DATA as Data Files
    participant OUT as Output Files
    
    JCL->>COMP: Submit compilation job
    COMP->>COMP: Compile COBOL source
    COMP->>JCL: Return compilation status
    
    alt Compilation Successful
        JCL->>PROG: Execute program
        PROG->>DATA: Open input files
        loop For each record
            PROG->>DATA: Read record
            PROG->>PROG: Process record
            PROG->>OUT: Write formatted output
        end
        PROG->>DATA: Close files
        PROG->>OUT: Close output
        PROG->>JCL: Return execution status
    else Compilation Failed
        JCL->>JCL: Terminate with error
    end
```

### Database Processing Sequence
```mermaid
sequenceDiagram
    participant JCL as JCL Job Control
    participant DB2PROC as DB2 Procedure
    participant PROG as COBOL Program
    participant DB2 as DB2 Database
    participant OUT as Report Output
    
    JCL->>DB2PROC: Submit DB2 COBOL job
    DB2PROC->>DB2PROC: Precompile SQL
    DB2PROC->>DB2PROC: Compile COBOL
    DB2PROC->>DB2PROC: Create DBRM
    DB2PROC->>DB2PROC: Bind DB2 plan
    
    alt Build Successful
        JCL->>PROG: Execute program
        PROG->>DB2: Connect to database
        PROG->>DB2: Open cursor
        loop For each record
            PROG->>DB2: Fetch record
            PROG->>PROG: Format record
            PROG->>OUT: Write to report
        end
        PROG->>DB2: Close cursor
        PROG->>DB2: Disconnect
        PROG->>JCL: Return status
    else Build Failed
        JCL->>JCL: Terminate with error
    end
```

## Target Spring Boot Architecture

### Target System Architecture
```mermaid
graph TB
    subgraph "Cloud/Container Environment"
        subgraph "Web Layer"
            API[REST API Controllers]
            WEB[Web Interface]
        end
        
        subgraph "Business Layer"
            SVC[Service Classes]
            CALC[Calculation Engine]
            RPT[Report Generator]
        end
        
        subgraph "Data Layer"
            REPO[JPA Repositories]
            ENT[JPA Entities]
        end
        
        subgraph "Infrastructure"
            DB[(PostgreSQL Database)]
            CACHE[(Redis Cache)]
            MSG[Message Queue]
        end
        
        subgraph "External Systems"
            FILE[File Processing]
            EXT[External APIs]
        end
    end
    
    API --> SVC
    WEB --> SVC
    SVC --> CALC
    SVC --> RPT
    SVC --> REPO
    REPO --> ENT
    ENT --> DB
    SVC --> CACHE
    SVC --> MSG
    SVC --> FILE
    SVC --> EXT
```

### Target Entity Relationship (JPA)
```mermaid
erDiagram
    Account ||--|| Customer : "OneToOne"
    Customer ||--o{ Address : "OneToMany"
    Account ||--o{ Transaction : "OneToMany"
    Account ||--o{ AccountLimit : "OneToMany"
    
    Account {
        Long id PK
        String accountNumber UK
        BigDecimal accountLimit
        BigDecimal accountBalance
        String comments
        LocalDateTime createdDate
        LocalDateTime modifiedDate
    }
    
    Customer {
        Long id PK
        Long accountId FK
        String surname
        String firstName
        String email
        String phone
    }
    
    Address {
        Long id PK
        Long customerId FK
        String streetAddress
        String cityCounty
        String state
        String zipCode
        String country
        AddressType type
    }
    
    Transaction {
        Long id PK
        Long accountId FK
        LocalDateTime transactionDate
        BigDecimal amount
        TransactionType type
        String description
        String reference
    }
    
    AccountLimit {
        Long id PK
        Long accountId FK
        BigDecimal limitAmount
        LimitType type
        LocalDate effectiveDate
        LocalDate expiryDate
    }
```

## Migration Phase Diagrams

### Migration Phases Overview
```mermaid
gantt
    title COBOL to Spring Boot Migration Timeline
    dateFormat  YYYY-MM-DD
    section Analysis Phase
    System Analysis          :a1, 2024-01-01, 4w
    Data Mapping            :a2, after a1, 2w
    Architecture Design     :a3, after a2, 3w
    
    section Development Phase
    Core Entities           :d1, after a3, 3w
    Database Migration      :d2, after d1, 2w
    Business Logic          :d3, after d1, 6w
    API Development         :d4, after d3, 4w
    
    section Testing Phase
    Unit Testing            :t1, after d2, 8w
    Integration Testing     :t2, after d4, 4w
    Performance Testing     :t3, after t2, 2w
    
    section Deployment Phase
    Staging Deployment      :dep1, after t1, 2w
    Production Preparation  :dep2, after t3, 3w
    Go-Live                 :dep3, after dep2, 1w
```

### Data Migration Strategy
```mermaid
flowchart TD
    A[EBCDIC Fixed Files] --> B[Data Extraction]
    C[DB2 Database] --> B
    B --> D[Data Transformation]
    D --> E[Encoding Conversion<br/>EBCDIC → UTF-8]
    E --> F[Format Conversion<br/>COMP-3 → BigDecimal]
    F --> G[Data Validation]
    G --> H[PostgreSQL Loading]
    H --> I[Data Verification]
    
    subgraph "Data Quality"
        J[Duplicate Detection]
        K[Referential Integrity]
        L[Business Rules Validation]
    end
    
    G --> J
    G --> K
    G --> L
    J --> H
    K --> H
    L --> H
```

### Application Migration Strategy
```mermaid
flowchart TD
    A[COBOL Programs] --> B[Functionality Analysis]
    B --> C[Business Logic Extraction]
    C --> D[Algorithm Translation]
    D --> E[Java Implementation]
    
    F[JCL Jobs] --> G[Process Analysis]
    G --> H[Workflow Design]
    H --> I[Spring Batch Jobs]
    
    J[DB2 SQL] --> K[SQL Analysis]
    K --> L[JPA Query Design]
    L --> M[Repository Implementation]
    
    E --> N[Service Layer]
    I --> N
    M --> N
    N --> O[REST API Layer]
    O --> P[Testing & Validation]
    
    subgraph "Migration Tools"
        Q[COBOL Parser]
        R[SQL Converter]
        S[Data Mapper]
    end
    
    B --> Q
    K --> R
    C --> S
```

## Risk Assessment Diagram

### Migration Risk Matrix
```mermaid
quadrantChart
    title Migration Risk Assessment
    x-axis Low Impact --> High Impact
    y-axis Low Probability --> High Probability
    
    quadrant-1 Monitor
    quadrant-2 Manage Closely
    quadrant-3 Accept
    quadrant-4 Mitigate
    
    Data Loss: [0.8, 0.2]
    Performance Issues: [0.7, 0.6]
    Integration Failures: [0.6, 0.7]
    Business Logic Errors: [0.9, 0.5]
    Timeline Delays: [0.5, 0.8]
    Resource Constraints: [0.4, 0.7]
    User Adoption: [0.8, 0.4]
    Security Vulnerabilities: [0.7, 0.3]
```