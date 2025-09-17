# COBOL Application File Inventory

## Overview
This document provides a comprehensive inventory of all COBOL and JCL files in the repository, organized by category and functionality.

## File Statistics
- **Total COBOL/JCL Files**: 66
- **COBOL Programs**: 41
- **JCL Jobs**: 25

## Categorized File Inventory

### 1. Core Business Application Files

#### Oracle Database Integration (ORCL_COBOL/)
| File | Type | Purpose | Description |
|------|------|---------|-------------|
| `CBDEM1.COB` | COBOL | Employee Management | Employee database CRUD operations with Oracle DB integration. Handles employee addition, validation, and department lookup |
| `WINDSURF.COB` | COBOL | Sports Session Tracking | Windsurf session data management with performance metrics tracking |

#### Financial System (Course #2 - Learning COBOL)
| File | Type | Purpose | Description |
|------|------|---------|-------------|
| `CBL0001.cobol` | COBOL | Account Processing | Core account record processing - reads account data and generates formatted reports |
| `CBL0002.cobol` | COBOL | Account Processing Extended | Enhanced account processing with additional validation |
| `CBL0004.cobol` | COBOL | Account Operations | Account transaction and balance processing |
| `CBL0005.cobol` | COBOL | Account Analysis | Account limit and balance analysis with conditional logic |
| `CBL0006.cobol` | COBOL | State-based Reporting | Client counting by state (Virginia clients tracking) |
| `CBL0007.cobol` | COBOL | Advanced Processing | Enhanced account processing with advanced features |
| `CBL0008.cobol` | COBOL | Data Validation | Account data validation and error handling |
| `CBL0009.cobol` | COBOL | Reporting Module | Financial reporting with totals and summaries |
| `CBL0010.cobol` | COBOL | Date Processing | Date-aware financial reporting with current date integration |
| `CBL0011.cobol` | COBOL | Advanced Reporting | Comprehensive financial reports with totals and date headers |
| `CBL0012.cobol` | COBOL | Final Processing | Final account processing with complete reporting features |
| `CBL0033.cobol` | COBOL | Special Processing | Specialized account processing module |

#### Search and Utility Programs
| File | Type | Purpose | Description |
|------|------|---------|-------------|
| `SRCHBIN.cobol` | COBOL | Binary Search | Binary search implementation for account lookup in sorted tables |
| `SRCHSER.cobol` | COBOL | Sequential Search | Sequential search for account data |
| `ADDAMT.cobol` | COBOL | Amount Addition | Utility for adding amounts to accounts |

#### Payroll System
| File | Type | Purpose | Description |
|------|------|---------|-------------|
| `PAYROL00.cobol` | COBOL | Basic Payroll | Basic payroll processing functionality |
| `PAYROL0X.cobol` | COBOL | Extended Payroll | Enhanced payroll processing with additional features |

#### System Utilities
| File | Type | Purpose | Description |
|------|------|---------|-------------|
| `HELLO.cobol` | COBOL | Hello World | Basic COBOL program demonstration |
| `COBOL.cobol` | COBOL | System Demo | COBOL language demonstration with date/time functions |

### 2. Database Integration (Course #3 - Advanced Topics)

#### DB2 Integration Programs
| File | Type | Purpose | Description |
|------|------|---------|-------------|
| `CBLDB21.cbl` | COBOL | DB2 Basic Operations | Basic DB2 database operations and connectivity |
| `CBLDB22.cbl` | COBOL | DB2 Advanced Operations | Advanced DB2 operations with complex queries |
| `CBLDB23.cbl` | COBOL | DB2 Reporting | DB2-based reporting and data extraction |

#### Debugging and Challenge Programs
| File | Type | Purpose | Description |
|------|------|---------|-------------|
| `CBL0106.cbl` | COBOL | Debug Challenge | Program for debugging exercises and troubleshooting |
| `CBL0106C.cbl` | COBOL | Corrected Version | Corrected version of debugging challenge program |

### 3. Job Control Language (JCL) Files

#### Course #2 - Learning COBOL JCL Jobs
| File | Purpose | Associated COBOL |
|------|---------|------------------|
| `CBL0001J.jcl` | Compile and run CBL0001 | CBL0001.cobol |
| `CBL0002J.jcl` | Compile and run CBL0002 | CBL0002.cobol |
| `CBL0003J.jcl` | Compile and run CBL0003 | (Referenced program) |
| `CBL0004J.jcl` | Compile and run CBL0004 | CBL0004.cobol |
| `CBL0005J.jcl` | Compile and run CBL0005 | CBL0005.cobol |
| `CBL0006J.jcl` | Compile and run CBL0006 | CBL0006.cobol |
| `CBL0007J.jcl` | Compile and run CBL0007 | CBL0007.cobol |
| `CBL0008J.jcl` | Compile and run CBL0008 | CBL0008.cobol |
| `CBL0009J.jcl` | Compile and run CBL0009 | CBL0009.cobol |
| `CBL0010J.jcl` | Compile and run CBL0010 | CBL0010.cobol |
| `CBL0011J.jcl` | Compile and run CBL0011 | CBL0011.cobol |
| `CBL0012J.jcl` | Compile and run CBL0012 | CBL0012.cobol |
| `CBL0033J.jcl` | Compile and run CBL0033 | CBL0033.cobol |
| `ADDAMT.jcl` | Compile and run ADDAMT | ADDAMT.cobol |
| `HELLO.jcl` | Compile and run HELLO | HELLO.cobol |
| `PAYROL00.jcl` | Compile and run PAYROL00 | PAYROL00.cobol |
| `PAYROL0X.jcl` | Compile and run PAYROL0X | PAYROL0X.cobol |
| `SRCHBINJ.jcl` | Compile and run SRCHBIN | SRCHBIN.cobol |
| `SRCHSERJ.jcl` | Compile and run SRCHSER | SRCHSER.cobol |
| `COBRUN.jcl` | Compile and run COBOL | COBOL.cobol |

#### Course #3 - Advanced Topics JCL Jobs
| File | Purpose | Associated COBOL |
|------|---------|------------------|
| `CBLDB21C.jcl` | Compile DB2 program 1 | CBLDB21.cbl |
| `CBLDB21R.jcl` | Run DB2 program 1 | CBLDB21.cbl |
| `CBLDB22C.jcl` | Compile DB2 program 2 | CBLDB22.cbl |
| `CBLDB22R.jcl` | Run DB2 program 2 | CBLDB22.cbl |
| `CBLDB23C.jcl` | Compile DB2 program 3 | CBLDB23.cbl |
| `CBLDB23R.jcl` | Run DB2 program 3 | CBLDB23.cbl |
| `CBL0106J.jcl` | Debug challenge job | CBL0106.cbl |

#### Database Setup and Utility JCL
| File | Purpose | Description |
|------|---------|-------------|
| `DB2SETUP.jcl` | Database setup | Initialize DB2 environment and create database objects |
| `DBRMLIB.jcl` | Database request module | Manage DB2 database request modules |
| `CRETBL.jcl` | Create tables | Create DB2 tables for application |
| `LOADTBL.jcl` | Load tables | Load data into DB2 tables |
| `SELTBL.jcl` | Select from tables | Query and validate DB2 table data |

#### Catalog Procedures (jclproc/)
| File | Purpose | Description |
|------|---------|-------------|
| `IGYWC.jcl` | Compile procedure | COBOL compile-only cataloged procedure |
| `IGYWCL.jcl` | Compile and link | COBOL compile and link cataloged procedure |
| `IGYWCLG.jcl` | Compile, link, go | COBOL compile, link, and execute procedure |
| `DB2CBL.jcl` | DB2 COBOL procedure | DB2 COBOL compilation and binding procedure |
| `DB2JCL.jcl` | DB2 execution | DB2 SQL execution procedure |
| `DSNUPROC.jcl` | DB2 utility | IBM-supplied DB2 utility procedure |

#### Course #4 - Testing JCL
| File | Purpose | Description |
|------|---------|-------------|
| `DEPTPAY.JCL` | Department payroll | Department-based payroll processing |
| `EMPPAY.JCL` | Employee payroll | Individual employee payroll processing |

## Data Structures Identified

### Core Account Record Structure
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

### Employee Database Structure (Oracle)
```cobol
77   EMPNO              PIC S9(9) COMP.
77   ENAME              PIC X(12).
77   JOB                PIC X(12).
77   SAL                PIC X(10).
77   DEPTNO             PIC X(10).
77   DNAME              PIC X(15).
```

## Migration Priorities

### High Priority (Core Business Logic)
1. Account processing system (CBL0001-CBL0012)
2. Employee management (CBDEM1)
3. Financial reporting modules
4. Database integration patterns

### Medium Priority (Utilities and Extensions)
1. Search algorithms (SRCHBIN, SRCHSER)
2. Payroll system (PAYROL00, PAYROL0X)
3. Utility programs (ADDAMT)

### Low Priority (Learning/Demo Programs)
1. Hello World and demo programs
2. Debugging challenge programs
3. Course-specific exercises

## File Dependencies

### Data Dependencies
- All programs depend on account master data file (ACCTREC)
- DB2 programs require database setup (DB2SETUP.jcl)
- Oracle programs require Oracle database connectivity

### Processing Dependencies
- Search programs require sorted data structures
- Reporting programs depend on data processing modules
- JCL jobs depend on corresponding COBOL programs

## Next Steps for Migration Analysis
1. Detailed business logic analysis for each core program
2. Data flow mapping between programs
3. Database schema analysis and mapping
4. Integration points identification
5. Performance requirements analysis