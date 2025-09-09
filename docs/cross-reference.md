# Cross-Reference Guide - COBOL Files and Dependencies

## File Dependencies Matrix

### COBOL Programs and JCL Relationships

| COBOL Program | Corresponding JCL | Purpose | Input Files | Output Files | 
|---------------|-------------------|---------|-------------|--------------|
| **ORCL_COBOL** |
| CBDEM1.COB | - | Oracle DB integration | Oracle EMP/DEPT tables | Console output |
| WINDSURF.COB | - | Data structure demo | None (hardcoded) | Console output |
| **Course #2** |
| HELLO.cobol | HELLOJ.jcl | Basic display | None | Console output |
| PAYROL00.cobol | PAYROL00.jcl | Payroll calculation | None (hardcoded) | Console output |
| ADDAMT.cobol | ADDAMT.jcl | Interactive calculation | User input | Console output |
| CBL0001.cobol | CBL0001J.jcl | Basic file processing | ACCTREC | PRTLINE |
| CBL0002.cobol | CBL0002J.jcl | Enhanced file processing | ACCTREC | PRTLINE |
| CBL0004.cobol | CBL0004J.jcl | Formatted output | ACCTREC | PRTLINE |
| CBL0005.cobol | CBL0005J.jcl | Advanced formatting | ACCTREC | PRTLINE |
| CBL0006.cobol | CBL0006J.jcl | Conditional processing | ACCTREC | PRTLINE |
| CBL0007.cobol | CBL0007J.jcl | State filtering | ACCTREC | PRTLINE |
| CBL0008.cobol | CBL0008J.jcl | Report without totals | ACCTREC | PRTLINE |
| CBL0009.cobol | CBL0009J.jcl | Full report with totals | ACCTREC | PRTLINE |
| CBL0010.cobol | CBL0010J.jcl | Extended processing | ACCTREC | PRTLINE |
| CBL0011.cobol | CBL0011J.jcl | Multi-field processing | ACCTREC | PRTLINE |
| CBL0012.cobol | CBL0012J.jcl | Advanced reporting | ACCTREC | PRTLINE |
| CBL0033.cobol | CBL0033J.jcl | Specialized processing | ACCTREC | PRTLINE |
| SRCHBIN.cobol | SRCHBINJ.jcl | Binary search | Search table | Console output |
| SRCHSER.cobol | SRCHSERJ.jcl | Sequential search | Search table | Console output |
| COBOL.cobol | COBRUN.jcl | COBOL structure demo | None | Console output |
| PAYROL0X.cobol | PAYROL0X.jcl | Advanced payroll | Employee data | Console output |
| **Course #3** |
| CBLDB21.cbl | CBLDB21C.jcl, CBLDB21R.jcl | Basic DB2 report | Z#####T table | Report output |
| CBLDB22.cbl | CBLDB22C.jcl, CBLDB22R.jcl | Enhanced DB2 processing | Z#####T table | Report output |
| CBLDB23.cbl | CBLDB23C.jcl, CBLDB23R.jcl | Advanced DB2 operations | Z#####T table | Report output |
| CBL0106.cbl | CBL0106J.jcl | Debugging exercise | ACCTREC | PRTLINE |
| CBL0106C.cbl | - | Corrected debug version | ACCTREC | PRTLINE |
| **Course #4** |
| DEPTPAY.CBL | DEPTPAY.JCL | Department payroll | None (hardcoded) | Console output |
| EMPPAY.CBL | EMPPAY.JCL | Employee payroll | None (hardcoded) | Console output |

## Data Dependencies

### File Assignments (DD Names)
| DD Name | COBOL Assignment | Purpose | Usage Pattern |
|---------|------------------|---------|---------------|
| ACCTREC | ASSIGN TO ACCTREC | Account input records | Most file processing programs |
| PRTLINE | ASSIGN TO PRTLINE | Formatted output | Report generation programs |
| SYSIN | ASSIGN TO SYSIN | Standard input | Batch processing |
| SYSOUT | ASSIGN TO SYSOUT | Standard output | Error messages, listings |

### Database Dependencies
| Database | Tables/Views | Programs Using | Purpose |
|----------|--------------|----------------|---------|
| Oracle | EMP, DEPT | CBDEM1.COB | Employee management |
| DB2 | Z#####T | CBLDB21-23.cbl | Account processing |

## JCL Procedure Dependencies

### Standard Procedures
| Procedure | Purpose | Used By | Parameters |
|-----------|---------|---------|------------|
| IGYWC | Compile only | All compilation jobs | COBOL source member |
| IGYWCL | Compile and link | Most programs | Source and load members |
| IGYWCLG | Compile, link, and go | Simple execution jobs | Complete processing |
| DB2CBL | DB2 COBOL compilation | DB2 programs | DB2-specific compilation |
| DSNUPROC | DB2 utilities | DB2 setup jobs | DB2 utility execution |

### Custom Procedures
| Procedure File | Purpose | Description |
|----------------|---------|-------------|
| jclproc/IGYWC.jcl | COBOL compile procedure | Standard COBOL compilation |
| jclproc/IGYWCL.jcl | Compile and link procedure | Compilation with link editing |
| jclproc/IGYWCLG.jcl | Compile, link, go procedure | Complete build and execution |
| jclproc/DB2CBL.jcl | DB2 COBOL procedure | DB2-enabled COBOL compilation |
| jclproc/DB2JCL.jcl | DB2 job procedure | DB2 job execution framework |
| jclproc/DSNUPROC.jcl | DB2 utility procedure | DB2 utility operations |

## Data Structure Dependencies

### Common Data Structures
| Structure | Used In | Purpose | Key Fields |
|-----------|---------|---------|------------|
| Account Record | CBL0001-CBL0012, CBL0106 | Customer account data | ACCT-NO, ACCT-LIMIT, ACCT-BALANCE |
| Customer Address | File processing programs | Address information | STREET-ADDR, CITY-COUNTY, USA-STATE |
| Employee Record | CBDEM1.COB, Payroll programs | Employee information | EMPNO, ENAME, JOB, SAL |
| Department Record | DEPTPAY.CBL | Department data | DEPT-NAME, DEPT-LOC, MANAGER info |

### Database Host Variables
| Variable Group | Used In | Purpose | Database Fields |
|----------------|---------|---------|-----------------|
| Account Variables | CBLDB21-23.cbl | DB2 account processing | ACCTNO, LIMIT, BALANCE |
| Customer Variables | DB2 programs | Customer information | SURNAME, FIRSTN, ADDRESS fields |
| Oracle Variables | CBDEM1.COB | Oracle integration | EMPNO, ENAME, JOB, DEPTNO |

## Program Complexity Matrix

### Complexity Rating (1-5 scale)
| Program | Data Complexity | Logic Complexity | Integration Complexity | Testing Complexity |
|---------|-----------------|------------------|------------------------|-------------------|
| HELLO.cobol | 1 | 1 | 1 | 1 |
| PAYROL00.cobol | 2 | 2 | 1 | 2 |
| ADDAMT.cobol | 2 | 3 | 1 | 3 |
| CBL0001.cobol | 3 | 2 | 2 | 2 |
| CBL0009.cobol | 4 | 4 | 2 | 4 |
| CBDEM1.COB | 5 | 5 | 5 | 5 |
| WINDSURF.COB | 4 | 2 | 1 | 2 |
| CBLDB21.cbl | 4 | 4 | 5 | 5 |
| EMPPAY.CBL | 3 | 4 | 1 | 4 |

## Modernization Dependencies

### Technology Stack Mapping
| Current Technology | Modern Equivalent | Migration Priority | Complexity |
|-------------------|-------------------|-------------------|------------|
| COBOL File I/O | Stream Processing | High | Medium |
| Oracle OCI | Modern DB Drivers | High | High |
| DB2 Embedded SQL | ORM/SQL Libraries | High | Medium |
| JCL Job Control | CI/CD Pipelines | Medium | High |
| Sequential Files | NoSQL/Message Queues | Medium | Medium |
| Report Generation | Modern Reporting Tools | Low | Low |

### Data Migration Requirements
| Data Type | Current Format | Target Format | Migration Tool |
|-----------|----------------|---------------|----------------|
| Account Records | Fixed-length COBOL | JSON/XML | Custom converter |
| Financial Data | COMP-3 Packed Decimal | Standard numeric | Data transformation |
| Customer Data | COBOL copybooks | Database schema | Schema migration |

## Testing Dependencies

### Test Data Requirements
| Program Type | Test Data Needed | Source | Validation |
|--------------|------------------|--------|------------|
| File Processing | Account records | Sample ACCTREC file | Output comparison |
| Database Programs | Test database | DB2/Oracle test DB | SQL verification |
| Interactive Programs | User input scenarios | Manual test cases | Screen validation |
| Calculation Programs | Numeric test cases | Boundary conditions | Result verification |

### Integration Testing
| Integration Point | Dependencies | Test Approach |
|------------------|--------------|---------------|
| File → Program | File format, program logic | End-to-end testing |
| Program → Database | DB connectivity, SQL correctness | Database testing |
| JCL → Program | Job control, resource allocation | Job execution testing |
| Program → Output | Format specifications, data accuracy | Output validation |

## Documentation Cross-Reference

### Documentation Categories
| Category | Files Documented | Documentation Type | Completeness |
|----------|------------------|-------------------|---------------|
| Basic Programs | HELLO, PAYROL00, ADDAMT | Comprehensive | Complete |
| File Processing | CBL0001-CBL0012 | Consolidated | Complete |
| Database Integration | CBDEM1, CBLDB21-23 | Detailed | Complete |
| Testing Examples | DEPTPAY, EMPPAY | Comprehensive | Complete |
| JCL Files | All JCL patterns | Template-based | Complete |

### Reference Relationships
| Source File | Related Documentation | Cross-References |
|-------------|----------------------|------------------|
| Any COBOL file | Program-specific .md file | Architecture, patterns |
| JCL files | JCL documentation | Program dependencies |
| Database programs | Database integration docs | SQL patterns |
| Test programs | Testing methodology | QA processes |

---

*This cross-reference guide provides comprehensive mapping of all dependencies, relationships, and integration points across the COBOL application suite, essential for maintenance, testing, and modernization planning.*