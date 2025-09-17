# Source Files Inventory

This document provides a comprehensive inventory of all COBOL and JCL source files in the repository, organized by category and functionality.

## Summary Statistics

- **Total Files**: 62
- **COBOL Files**: 18 (.cobol) + 3 (.cbl) = 21 total
- **JCL Files**: 41 total
- **JCL Procedures**: 6 files

## File Organization by Course

### Course #2 - Learning COBOL (Basic COBOL Programming)

#### COBOL Programs (15 files)

| File | Purpose | Description |
|------|---------|-------------|
| `HELLO.cobol` | Hello World | Simple "Hello World" program demonstrating basic COBOL structure |
| `PAYROL00.cobol` | Payroll Calculation | Basic payroll calculation using MOVE and COMPUTE statements |
| `PAYROL0X.cobol` | Extended Payroll | Extended payroll program with more complex calculations |
| `CBL0001.cobol` | File Processing | Account record reading and printing with file I/O operations |
| `CBL0002.cobol` | Data Manipulation | Data manipulation and formatting operations |
| `CBL0003.cobol` | Conditional Logic | Program demonstrating IF-THEN-ELSE conditional statements |
| `CBL0004.cobol` | Loops and Iteration | PERFORM loops and iteration control structures |
| `CBL0005.cobol` | Data Validation | Input validation and error handling |
| `CBL0006.cobol` | State Processing | Client state filtering (Virginia clients counter) |
| `CBL0007.cobol` | String Operations | String manipulation and text processing |
| `CBL0008.cobol` | Mathematical Operations | Complex mathematical calculations and functions |
| `CBL0009.cobol` | Financial Calculations | Account limit and balance totaling with formatted output |
| `CBL0010.cobol` | Report Generation | Financial report generation with headers and date formatting |
| `CBL0011.cobol` | Advanced Reporting | Enhanced financial reporting with intrinsic functions |
| `CBL0012.cobol` | Date Functions | Date manipulation using COBOL intrinsic functions |
| `CBL0033.cobol` | Table Processing | Table operations and array processing |
| `ADDAMT.cobol` | Amount Addition | Simple amount addition utility |
| `SRCHBIN.cobol` | Binary Search | Binary search algorithm implementation |
| `SRCHSER.cobol` | Serial Search | Serial search algorithm implementation |
| `COBOL.cobol` | Generic Program | General purpose COBOL program template |

#### JCL Files (20 files)

| File | Purpose | Associated COBOL |
|------|---------|------------------|
| `CBL0001J.jcl` | Job Control for CBL0001 | CBL0001.cobol |
| `CBL0002J.jcl` | Job Control for CBL0002 | CBL0002.cobol |
| `CBL0003J.jcl` | Job Control for CBL0003 | CBL0003.cobol |
| `CBL0004J.jcl` | Job Control for CBL0004 | CBL0004.cobol |
| `CBL0005J.jcl` | Job Control for CBL0005 | CBL0005.cobol |
| `CBL0006J.jcl` | Job Control for CBL0006 | CBL0006.cobol |
| `CBL0007J.jcl` | Job Control for CBL0007 | CBL0007.cobol |
| `CBL0008J.jcl` | Job Control for CBL0008 | CBL0008.cobol |
| `CBL0009J.jcl` | Job Control for CBL0009 | CBL0009.cobol |
| `CBL0010J.jcl` | Job Control for CBL0010 | CBL0010.cobol |
| `CBL0011J.jcl` | Job Control for CBL0011 | CBL0011.cobol |
| `CBL0012J.jcl` | Job Control for CBL0012 | CBL0012.cobol |
| `CBL0033J.jcl` | Job Control for CBL0033 | CBL0033.cobol |
| `HELLO.jcl` | Job Control for HELLO | HELLO.cobol |
| `PAYROL00.jcl` | Job Control for PAYROL00 | PAYROL00.cobol |
| `PAYROL0X.jcl` | Job Control for PAYROL0X | PAYROL0X.cobol |
| `ADDAMT.jcl` | Job Control for ADDAMT | ADDAMT.cobol |
| `SRCHBINJ.jcl` | Job Control for Binary Search | SRCHBIN.cobol |
| `SRCHSERJ.jcl` | Job Control for Serial Search | SRCHSER.cobol |
| `COBRUN.jcl` | Generic COBOL Run Job | Generic execution template |

#### JCL Procedures (3 files)

| File | Purpose | Description |
|------|---------|-------------|
| `IGYWC.jcl` | COBOL Compile | IBM Enterprise COBOL compilation procedure |
| `IGYWCL.jcl` | Compile and Link | COBOL compilation and link-edit procedure |
| `IGYWCLG.jcl` | Compile, Link, Go | Complete compile, link, and execute procedure |

### Course #3 - Advanced Topics (Database Programming)

#### COBOL Programs (3 files)

| File | Purpose | Description |
|------|---------|-------------|
| `CBLDB21.cbl` | DB2 Basic Operations | Basic DB2 database operations with embedded SQL |
| `CBLDB22.cbl` | DB2 Advanced Queries | Advanced DB2 queries and data manipulation |
| `CBLDB23.cbl` | DB2 Complex Processing | Complex database processing with multiple operations |

#### JCL Files (14 files)

| File | Purpose | Description |
|------|---------|-------------|
| `CBLDB21C.jcl` | Compile CBLDB21 | Compilation job for CBLDB21 |
| `CBLDB21R.jcl` | Run CBLDB21 | Execution job for CBLDB21 |
| `CBLDB22C.jcl` | Compile CBLDB22 | Compilation job for CBLDB22 |
| `CBLDB22R.jcl` | Run CBLDB22 | Execution job for CBLDB22 |
| `CBLDB23C.jcl` | Compile CBLDB23 | Compilation job for CBLDB23 |
| `CBLDB23R.jcl` | Run CBLDB23 | Execution job for CBLDB23 |
| `DB2SETUP.jcl` | Database Setup | DB2 database and table creation |
| `CRETBL.jcl` | Create Tables | Table creation with indexes |
| `LOADTBL.jcl` | Load Tables | Data loading into tables |
| `SELTBL.jcl` | Select from Tables | Table query operations |
| `DBRMLIB.jcl` | DBRM Library Setup | Database Request Module library setup |

#### JCL Procedures (3 files)

| File | Purpose | Description |
|------|---------|-------------|
| `DB2CBL.jcl` | DB2 COBOL Procedure | DB2 COBOL compilation, link-edit, and binding procedure |
| `DB2JCL.jcl` | DB2 Execution Procedure | DB2 SQL execution procedure |
| `DSNUPROC.jcl` | DB2 Utility Procedure | IBM-supplied DB2 online utility procedure |

### Course #3 - Debugging Challenges (2 files)

#### COBOL Programs (2 files)

| File | Purpose | Description |
|------|---------|-------------|
| `CBL0106.cbl` | Debug Exercise | COBOL program with intentional bugs for debugging practice |
| `CBL0106C.cbl` | Corrected Version | Corrected version of CBL0106 |

#### JCL Files (1 file)

| File | Purpose | Description |
|------|---------|-------------|
| `CBL0106J.jcl` | Debug Job Control | JCL for running debugging exercises |

## Data Structures and Entities

### Core Business Entities

Based on the analysis of COBOL programs, the following core business entities have been identified:

#### Account Entity
```cobol
05  ACCT-NO            PIC X(8).           // Account Number (8 characters)
05  ACCT-LIMIT         PIC S9(7)V99 COMP-3. // Account Limit (7 digits + 2 decimal places)
05  ACCT-BALANCE       PIC S9(7)V99 COMP-3. // Account Balance (7 digits + 2 decimal places)
05  LAST-NAME          PIC X(20).          // Customer Last Name (20 characters)
05  FIRST-NAME         PIC X(15).          // Customer First Name (15 characters)
05  CLIENT-ADDR.                           // Address structure
    10  STREET-ADDR     PIC X(25).         // Street Address (25 characters)
    10  CITY-COUNTY     PIC X(20).         // City/County (20 characters)
    10  ADDRSTATE       PIC X(15).         // State (15 characters)
05  RESERVED           PIC X(7).           // Reserved field (7 characters)
05  COMMENTS           PIC X(50).          // Comments (50 characters)
```

#### Database Table Structure (from CRETBL.jcl)
```sql
CREATE TABLE &SYSUID.T (
    ACCTNO    CHAR(8)        NOT NULL,     // Primary Key
    LIMIT     DECIMAL(9,2),               // Account Limit
    BALANCE   DECIMAL(9,2),               // Account Balance
    SURNAME   CHAR(20)       NOT NULL,    // Last Name
    FIRSTN    CHAR(15)       NOT NULL,    // First Name
    ADDRESS1  CHAR(25),                   // Address Line 1
    ADDRESS2  CHAR(20),                   // Address Line 2
    ADDRESS3  CHAR(15),                   // Address Line 3
    RESERVED  CHAR(7),                    // Reserved Field
    COMMENTS  CHAR(50),                   // Comments
    PRIMARY KEY(ACCTNO)
);
```

## Program Categories by Functionality

### 1. Basic I/O and Data Processing
- `HELLO.cobol` - Basic output
- `PAYROL00.cobol`, `PAYROL0X.cobol` - Simple calculations
- `CBL0001.cobol` - File reading and printing

### 2. Advanced Business Logic
- `CBL0006.cobol` - State-based filtering
- `CBL0009.cobol`, `CBL0010.cobol`, `CBL0011.cobol` - Financial reporting
- `CBL0012.cobol` - Date processing

### 3. Database Operations
- `CBLDB21.cbl` - Basic DB2 operations
- `CBLDB22.cbl` - Advanced queries
- `CBLDB23.cbl` - Complex processing

### 4. Utility Programs
- `ADDAMT.cobol` - Amount calculations
- `SRCHBIN.cobol`, `SRCHSER.cobol` - Search algorithms
- `CBL0033.cobol` - Table processing

## Migration Considerations

### File Processing Patterns
1. **Sequential File Processing**: Most programs follow a pattern of OPEN -> READ -> PROCESS -> WRITE -> CLOSE
2. **Record-Level Processing**: Programs process one record at a time in batch mode
3. **Fixed-Length Records**: All data structures use fixed-length fields with specific picture clauses

### Data Format Conversions Required
1. **COMP-3 (Packed Decimal)** → **BigDecimal** in Java
2. **PIC X(n)** → **String** with appropriate length validation
3. **PIC 9(n)V99** → **BigDecimal** for financial amounts
4. **Fixed-width records** → **JPA Entities** with proper field mapping

### Business Logic Patterns
1. **Report Generation**: Header/detail/trailer pattern with formatted output
2. **Data Validation**: Input validation and error handling
3. **Mathematical Operations**: Financial calculations with precision requirements
4. **Conditional Processing**: State-based logic and filtering operations

---

*This inventory serves as the foundation for understanding the current system architecture and planning the migration to Spring Boot.*