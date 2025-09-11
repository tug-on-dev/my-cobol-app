# Current Architecture Overview

## System Architecture

The current COBOL application system is built on traditional mainframe architecture with the following key components:

### High-Level Architecture

```mermaid
graph TB
    subgraph "Mainframe Environment"
        JCL[JCL Job Control]
        COBOL[COBOL Programs]
        DB2[DB2 Database]
        FILES[Sequential/VSAM Files]
    end
    
    subgraph "Application Layer"
        CBL0011[Financial Reporting]
        EMPPAY[Employee Payroll]
        CBLDB21[DB2 Account Query]
        CBLDB22[DB2 Update Operations]
        CBLDB23[DB2 Report Generation]
    end
    
    subgraph "Data Layer"
        ACCT[Account Records]
        EMP[Employee Records]
        TABLES[DB2 Tables]
    end
    
    JCL --> COBOL
    COBOL --> CBL0011
    COBOL --> EMPPAY
    COBOL --> CBLDB21
    COBOL --> CBLDB22
    COBOL --> CBLDB23
    
    CBL0011 --> ACCT
    EMPPAY --> EMP
    CBLDB21 --> TABLES
    CBLDB22 --> TABLES
    CBLDB23 --> TABLES
    
    COBOL --> DB2
    COBOL --> FILES
```

## Current System Components

### 1. COBOL Programs

| Program | Purpose | Data Access |
|---------|---------|-------------|
| CBL0011 | Financial reporting and account analysis | Sequential file processing |
| EMPPAY | Employee payroll calculations | Working storage records |
| CBLDB21 | Database query operations | DB2 SQL SELECT |
| CBLDB22 | Database update operations | DB2 SQL INSERT/UPDATE |
| CBLDB23 | Database report generation | DB2 SQL with cursors |

### 2. Job Control Language (JCL)

JCL manages the execution environment and coordinates:
- Program compilation with IGYWC/IGYWCL/IGYWCLG procedures
- Data set allocation and management
- Program execution sequence
- Error handling and conditional processing

### 3. Data Management

#### File Types:
- **Sequential Files**: EBCDIC-encoded binary data with packed decimal fields
- **VSAM Files**: Indexed sequential access for account records
- **DB2 Tables**: Relational data for advanced operations

#### Data Characteristics:
- **EBCDIC Encoding**: Legacy character encoding
- **COMP-3 (Packed Decimal)**: Space-efficient numeric storage
- **Fixed-length Records**: Predictable data structure layouts

## Process Flow

```mermaid
sequenceDiagram
    participant User
    participant JCL
    participant COBOL
    participant DB2
    participant Files
    
    User->>JCL: Submit Job
    JCL->>COBOL: Compile Program
    JCL->>COBOL: Execute Program
    
    COBOL->>Files: Read Input Data
    Files-->>COBOL: Return Records
    
    COBOL->>DB2: Execute SQL
    DB2-->>COBOL: Return Result Set
    
    COBOL->>Files: Write Output
    COBOL-->>JCL: Program Complete
    JCL-->>User: Job Results
```

## Key Characteristics

### Strengths
- **Reliability**: Proven mainframe stability and transaction processing
- **Performance**: Optimized for high-volume batch processing
- **Data Integrity**: Strong ACID compliance with DB2
- **Mature Ecosystem**: Well-established development and operational procedures

### Challenges
- **Legacy Technology**: Limited developer talent pool
- **Maintenance Complexity**: Aging codebase with limited documentation
- **Scalability Constraints**: Vertical scaling limitations
- **Integration Difficulties**: Challenges interfacing with modern systems
- **Cost**: High mainframe licensing and operational expenses

## Technology Stack

| Component | Technology | Version | Usage |
|-----------|------------|---------|-------|
| Programming Language | Enterprise COBOL | v6.3 | Application logic |
| Database | DB2 for z/OS | v12 | Data persistence |
| Operating System | z/OS | 2.4 | Runtime environment |
| Job Control | JCL | - | Batch processing |
| Data Format | EBCDIC/COMP-3 | - | Data storage |

## Infrastructure Dependencies

```mermaid
graph LR
    subgraph "Mainframe Hardware"
        CPU[z/OS CPU]
        STORAGE[DASD Storage]
        MEMORY[Main Memory]
    end
    
    subgraph "System Software"
        ZOS[z/OS Operating System]
        DB2SYS[DB2 System]
        CICS[CICS Transaction Server]
    end
    
    subgraph "Development Tools"
        COMPILER[COBOL Compiler]
        DEBUGGER[Debug Tools]
        EDITOR[ISPF Editor]
    end
    
    CPU --> ZOS
    STORAGE --> ZOS
    MEMORY --> ZOS
    
    ZOS --> DB2SYS
    ZOS --> CICS
    
    COMPILER --> ZOS
    DEBUGGER --> ZOS
    EDITOR --> ZOS
```

This current architecture serves as the baseline for understanding the migration scope and complexity involved in modernizing to cloud-native Java applications.