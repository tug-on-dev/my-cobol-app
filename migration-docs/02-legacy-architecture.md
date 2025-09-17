# Legacy System Architecture Analysis

## Overview
This document analyzes the existing COBOL application architecture, data flows, and system components to understand the current state before migration to Java Spring Boot.

## System Architecture Overview

```mermaid
graph TB
    subgraph "COBOL Application Layer"
        A[Account Processing Module<br/>CBL0001-CBL0012]
        B[Employee Management<br/>CBDEM1]
        C[Payroll System<br/>PAYROL00/0X]
        D[Search & Utilities<br/>SRCHBIN/SER, ADDAMT]
        E[Reporting Module<br/>Financial Reports]
    end
    
    subgraph "Data Layer"
        F[Sequential Files<br/>ACCTREC, PRTLINE]
        G[Oracle Database<br/>EMP, DEPT Tables]
        H[DB2 Database<br/>Advanced Features]
    end
    
    subgraph "Job Control Layer"
        I[Compile JCL<br/>IGYWC, IGYWCL]
        J[Execute JCL<br/>CBL****J jobs]
        K[DB2 JCL<br/>DB2CBL, DB2JCL]
    end
    
    A --> F
    B --> G
    C --> F
    D --> F
    E --> F
    
    I --> A
    I --> B
    I --> C
    J --> A
    J --> B
    J --> C
    K --> H
```

## Data Architecture and Flow

### Primary Data Structures

```mermaid
erDiagram
    ACCOUNT ||--o{ TRANSACTION : has
    ACCOUNT ||--o{ REPORT : generates
    EMPLOYEE ||--o{ DEPARTMENT : belongs_to
    EMPLOYEE ||--o{ PAYROLL : receives
    
    ACCOUNT {
        string acct_no PK
        decimal acct_limit
        decimal acct_balance
        string last_name
        string first_name
        string street_addr
        string city_county
        string usa_state
        string comments
    }
    
    EMPLOYEE {
        int empno PK
        string ename
        string job
        decimal sal
        int deptno FK
    }
    
    DEPARTMENT {
        int deptno PK
        string dname
    }
    
    TRANSACTION {
        string acct_no FK
        decimal amount
        string type
        date trans_date
    }
    
    PAYROLL {
        int empno FK
        decimal gross_pay
        decimal net_pay
        date pay_date
    }
    
    REPORT {
        string report_id PK
        string acct_no FK
        date report_date
        string report_type
    }
```

## System Components Analysis

### 1. Account Processing System

```mermaid
sequenceDiagram
    participant JCL as JCL Job
    participant CBL as COBOL Program
    participant DATA as Data Files
    participant RPT as Report Output
    
    JCL->>CBL: Execute Program
    CBL->>DATA: Open ACCT-REC (Input)
    CBL->>RPT: Open PRINT-LINE (Output)
    
    loop Process Records
        CBL->>DATA: Read Account Record
        alt Record Found
            CBL->>CBL: Validate Data
            CBL->>CBL: Calculate Balances
            CBL->>RPT: Write Report Line
        else End of File
            CBL->>CBL: Set LASTREC Flag
        end
    end
    
    CBL->>DATA: Close Input File
    CBL->>RPT: Close Output File
    CBL->>JCL: Return Control
```

### 2. Employee Management System (Oracle Integration)

```mermaid
sequenceDiagram
    participant USER as User Interface
    participant CBDEM1 as CBDEM1 Program
    participant ORA as Oracle Database
    
    USER->>CBDEM1: Start Program
    CBDEM1->>ORA: Connect (OLOG)
    CBDEM1->>ORA: Open Cursors (OOPEN)
    CBDEM1->>ORA: Get Max Employee Number
    
    loop Add Employees
        USER->>CBDEM1: Enter Employee Data
        CBDEM1->>ORA: Validate Department
        alt Valid Department
            CBDEM1->>ORA: Insert Employee
            CBDEM1->>ORA: Commit Transaction
            CBDEM1->>USER: Display Success
        else Invalid Department
            CBDEM1->>USER: Display Error
        end
    end
    
    CBDEM1->>ORA: Close Cursors (OCLOSE)
    CBDEM1->>ORA: Disconnect (OLOGOF)
```

### 3. File Processing Patterns

```mermaid
flowchart TD
    A[Start Program] --> B[Open Files]
    B --> C{Read First Record}
    C -->|Success| D[Process Record]
    C -->|EOF| E[Close Files]
    D --> F[Validate Data]
    F --> G[Perform Calculations]
    G --> H[Write Output]
    H --> I{Read Next Record}
    I -->|Success| D
    I -->|EOF| J[Write Totals]
    J --> E
    E --> K[End Program]
```

## Technology Stack Analysis

### Current COBOL Technology Stack
- **Language**: COBOL (Enterprise COBOL for z/OS)
- **Database**: Oracle Database, DB2 for z/OS
- **File System**: Sequential files (VSAM, flat files)
- **Job Control**: JCL (Job Control Language)
- **Runtime**: z/OS mainframe environment
- **Compilation**: IBM COBOL compiler (IGYWC procedures)

### Database Integration Patterns

#### Oracle Integration (CBDEM1)
```mermaid
graph LR
    A[COBOL Program] --> B[Oracle Call Interface]
    B --> C[OLOG - Login]
    B --> D[OOPEN - Open Cursor]
    B --> E[OPARSE - Parse SQL]
    B --> F[OEXEC - Execute]
    B --> G[OFETCH - Fetch Results]
    B --> H[OCLOSE - Close Cursor]
    B --> I[OLOGOF - Logout]
```

#### File-based Processing
```mermaid
graph LR
    A[COBOL Program] --> B[SELECT Statement]
    B --> C[ASSIGN TO DDNAME]
    C --> D[JCL DD Statement]
    D --> E[Physical Dataset]
    E --> F[Sequential Processing]
```

## Business Logic Patterns

### 1. Financial Calculations
- Account balance validation
- Credit limit checking
- Running totals and summaries
- Date-based reporting
- Currency formatting

### 2. Data Validation
- Account number format validation
- State code validation
- Department number validation
- Employee number generation
- Duplicate detection

### 3. Error Handling
- End-of-file detection
- Database error handling
- Data validation errors
- File operation errors
- Oracle-specific error handling

## Performance Characteristics

### Current System Performance
- **Batch Processing**: Sequential file processing
- **Memory Usage**: Fixed record layouts, minimal memory
- **Scalability**: Limited by mainframe resources
- **Throughput**: Optimized for batch operations

### Processing Volumes
- Account records: Variable, typically thousands
- Employee records: Smaller datasets
- Report generation: Daily/monthly batch cycles
- Search operations: Linear/binary search algorithms

## Integration Points

### External Systems
1. **Oracle Database**: Employee and department data
2. **DB2 Database**: Advanced reporting data
3. **File Systems**: Account master files, transaction files
4. **Print Systems**: Report output generation

### Data Exchange Formats
- Fixed-length records
- COMP-3 packed decimal fields
- Character data with EBCDIC encoding
- Sequential file organization

## Security Model

### Current Security Features
- Database user authentication (Oracle/DB2)
- File access controls through z/OS security
- Program-level authorization
- Limited audit trails

## Configuration Management

### Environment Management
- Development: Course environments
- Test: JCL-based testing
- Production: Mainframe batch scheduling

### Deployment Process
- COBOL compilation through JCL
- Load module management
- Dataset allocation and management
- Procedure library maintenance

## System Limitations

### Technical Constraints
1. **Platform Dependency**: z/OS mainframe only
2. **Language Limitations**: COBOL-specific features
3. **Database Integration**: Proprietary Oracle/DB2 interfaces
4. **User Interface**: Batch-only, no interactive UI
5. **Modern Integration**: Limited API capabilities

### Scalability Issues
1. **Single-threaded Processing**: Sequential batch only
2. **Memory Constraints**: Fixed allocation patterns
3. **Storage Limitations**: Dataset size restrictions
4. **Processing Windows**: Batch scheduling constraints

### Maintenance Challenges
1. **Skill Availability**: COBOL developer shortage
2. **Technology Age**: Legacy technology stack
3. **Integration Complexity**: Mainframe-centric
4. **Testing Limitations**: Limited automated testing

## Migration Readiness Assessment

### Well-Structured Components
- Clear separation of data and logic
- Consistent error handling patterns
- Modular program design
- Well-documented business rules

### Migration Challenges
- Proprietary database interfaces
- COBOL-specific data types
- Mainframe file system dependencies
- JCL job scheduling integration

### Migration Opportunities
- Clean business logic separation
- Clear data structures
- Consistent processing patterns
- Modular program architecture