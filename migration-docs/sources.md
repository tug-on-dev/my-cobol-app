# COBOL/JCL Source Files Inventory

This document provides an inventory of all COBOL and JCL source files discovered in the repository.

## Primary Application Files

### ORCL_COBOL Directory
These appear to be the main application programs:

| File | Type | Description |
|------|------|-------------|
| `ORCL_COBOL/CBDEM1.COB` | COBOL | Employee management system - adds new employee records to database with Oracle connectivity. Performs SQL operations including SELECT, INSERT with employee and department tables. Uses cursors and parameter binding. |
| `ORCL_COBOL/WINDSURF.COB` | COBOL | Windsurf session tracking program - displays session information including rider details, performance metrics (speed, distance), and equipment info. Appears to be a reporting/display program without database operations. |

## Learning Materials and Examples

### COBOL Programming Course #2 - Learning COBOL

#### COBOL Programs (.cobol files)
| File | Description |
|------|-------------|
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/ADDAMT.cobol` | Amount addition program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0001.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0002.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0004.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0005.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0006.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0007.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0008.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0009.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0010.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0011.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0012.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/CBL0033.cobol` | Basic COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/COBOL.cobol` | COBOL program example |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/HELLO.cobol` | Hello World COBOL program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/PAYROL00.cobol` | Payroll processing program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/PAYROL0X.cobol` | Extended payroll processing program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/SRCHBIN.cobol` | Binary search program with account records table handling |
| `COBOL Programming Course #2 - Learning COBOL/Labs/cbl/SRCHSER.cobol` | Serial search program |

#### JCL Files (.jcl files)
| File | Description |
|------|-------------|
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/ADDAMT.jcl` | Job control for ADDAMT program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0001J.jcl` | Job control for CBL0001 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0002J.jcl` | Job control for CBL0002 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0003J.jcl` | Job control for CBL0003 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0004J.jcl` | Job control for CBL0004 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0005J.jcl` | Job control for CBL0005 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0006J.jcl` | Job control for CBL0006 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0007J.jcl` | Job control for CBL0007 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0008J.jcl` | Job control for CBL0008 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0009J.jcl` | Job control for CBL0009 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0010J.jcl` | Job control for CBL0010 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0011J.jcl` | Job control for CBL0011 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0012J.jcl` | Job control for CBL0012 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/CBL0033J.jcl` | Job control for CBL0033 program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/COBRUN.jcl` | Generic COBOL program runner |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/HELLO.jcl` | Job control for Hello World program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/PAYROL00.jcl` | Job control for payroll program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/PAYROL0X.jcl` | Job control for extended payroll program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/SRCHBINJ.jcl` | Job control for binary search program |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jcl/SRCHSERJ.jcl` | Job control for serial search program |

#### JCL Procedures
| File | Description |
|------|-------------|
| `COBOL Programming Course #2 - Learning COBOL/Labs/jclproc/IGYWC.jcl` | COBOL compilation procedure |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jclproc/IGYWCL.jcl` | COBOL compile and link procedure |
| `COBOL Programming Course #2 - Learning COBOL/Labs/jclproc/IGYWCLG.jcl` | COBOL compile, link, and go procedure |

### COBOL Programming Course #3 - Advanced Topics

#### Database-Related COBOL Programs (.cbl files)
| File | Description |
|------|-------------|
| `COBOL Programming Course #3 - Advanced Topics/Labs/cbl/CBLDB21.cbl` | Database program with SQL operations |
| `COBOL Programming Course #3 - Advanced Topics/Labs/cbl/CBLDB22.cbl` | Database program with SQL operations |
| `COBOL Programming Course #3 - Advanced Topics/Labs/cbl/CBLDB23.cbl` | Database program with cursors and customer records - contains SQL operations with Z#####T table |

#### Debugging Examples
| File | Description |
|------|-------------|
| `COBOL Programming Course #3 - Advanced Topics/Challenges/Debugging/cbl/CBL0106.cbl` | Debugging exercise program |
| `COBOL Programming Course #3 - Advanced Topics/Challenges/Debugging/cbl/CBL0106C.cbl` | Debugging exercise corrected version |

#### Database JCL Files
| File | Description |
|------|-------------|
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/CBLDB21C.jcl` | Compile job for CBLDB21 |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/CBLDB21R.jcl` | Run job for CBLDB21 |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/CBLDB22C.jcl` | Compile job for CBLDB22 |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/CBLDB22R.jcl` | Run job for CBLDB22 |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/CBLDB23C.jcl` | Compile job for CBLDB23 |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/CBLDB23R.jcl` | Run job for CBLDB23 |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/CRETBL.jcl` | Create table job |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/DB2SETUP.jcl` | DB2 setup job |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/DBRMLIB.jcl` | Database request module library setup |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/LOADTBL.jcl` | Load table job |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jcl/SELTBL.jcl` | Select table job |
| `COBOL Programming Course #3 - Advanced Topics/Challenges/Debugging/jcl/CBL0106J.jcl` | Debug program job control |

#### DB2 Procedures
| File | Description |
|------|-------------|
| `COBOL Programming Course #3 - Advanced Topics/Labs/jclproc/DB2CBL.jcl` | DB2 COBOL compile and bind procedure |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jclproc/DB2JCL.jcl` | DB2 SQL execution procedure |
| `COBOL Programming Course #3 - Advanced Topics/Labs/jclproc/DSNUPROC.jcl` | DB2 utility procedure (IBM-supplied) |

### COBOL Programming Course #4 - Testing

#### Testing Programs
| File | Description |
|------|-------------|
| `COBOL Programming Course #4 - Testing/Labs/cbl/DEPTPAY.CBL` | Department payroll program |
| `COBOL Programming Course #4 - Testing/Labs/cbl/EMPPAY.CBL` | Employee payroll program |
| `COBOL Programming Course #4 - Testing/Labs/jcl/DEPTPAY.JCL` | Job control for department payroll |
| `COBOL Programming Course #4 - Testing/Labs/jcl/EMPPAY.JCL` | Job control for employee payroll |

## Summary

**Total Files Found**: 60 COBOL/JCL files
- **Primary Application**: 2 COBOL programs (CBDEM1.COB, WINDSURF.COB)
- **Course Material**: 58 files across 4 course directories
- **Database Programs**: 4 main database-connected programs (CBDEM1, CBLDB21-23)
- **JCL Procedures**: 6 system procedures for compilation and DB operations

## Migration Priority

For migration planning, the primary focus should be on:
1. **CBDEM1.COB** - Main business application with employee database operations
2. **WINDSURF.COB** - Secondary application for session tracking
3. **Database schema inference** from SQL statements in CBDEM1 and CBLDB23
4. **Learning examples** can provide additional insights into COBOL patterns used

> **Note**: This inventory was generated via repository scan. If additional COBOL/JCL files are discovered during development, they should be added to this list.