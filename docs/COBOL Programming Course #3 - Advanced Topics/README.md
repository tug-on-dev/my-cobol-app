# COBOL Programming Course #3 - Advanced Topics Documentation

## Overview

Course #3 contains advanced COBOL programming examples focusing on database integration with DB2 and debugging techniques. This represents enterprise-level COBOL programming with SQL integration and production debugging scenarios.

## Directory Structure

### [Labs/](./Labs/) - Database Integration Programs
Advanced COBOL programs demonstrating DB2 database integration using embedded SQL.

**Programs**:
- **CBLDB21.cbl** - Basic DB2 report generation
- **CBLDB22.cbl** - Enhanced DB2 processing with error handling
- **CBLDB23.cbl** - Advanced DB2 operations with complex queries

**Supporting JCL Files**:
- **Compile Jobs**: CBLDB21C.jcl, CBLDB22C.jcl, CBLDB23C.jcl
- **Run Jobs**: CBLDB21R.jcl, CBLDB22R.jcl, CBLDB23R.jcl
- **Database Setup**: DB2SETUP.jcl, CRETBL.jcl, LOADTBL.jcl, SELTBL.jcl
- **Database Resource Management**: DBRMLIB.jcl

**JCL Procedures**:
- **DB2CBL.jcl** - DB2 COBOL compilation procedure
- **DB2JCL.jcl** - DB2 job execution procedure
- **DSNUPROC.jcl** - DB2 utility procedures

### [Challenges/Debugging/](./Challenges/Debugging/) - Debugging Exercises
Programs designed for debugging practice and error identification.

**Programs**:
- **CBL0106.cbl** - Debugging exercise program
- **CBL0106C.cbl** - Corrected version of debugging program

**Supporting JCL**:
- **CBL0106J.jcl** - Execution job for debugging exercise

## Key Technologies Demonstrated

### Embedded SQL in COBOL
The Labs programs demonstrate professional database integration patterns:

#### SQL Declaration Section
```cobol
EXEC SQL INCLUDE SQLCA END-EXEC.
EXEC SQL DECLARE TABLE-NAME TABLE
    (COLUMN1 CHAR(8) NOT NULL,
     COLUMN2 DECIMAL(9,2),
     COLUMN3 CHAR(20) NOT NULL)
END-EXEC.
```

#### Cursor Processing
```cobol
EXEC SQL DECLARE CUR1 CURSOR FOR
    SELECT * FROM TABLE-NAME
END-EXEC.

EXEC SQL OPEN CUR1 END-EXEC.
EXEC SQL FETCH CUR1 INTO :HOST-VARIABLES END-EXEC.
EXEC SQL CLOSE CUR1 END-EXEC.
```

#### Error Handling
```cobol
EXEC SQL WHENEVER SQLERROR PERFORM SQL-ERROR END-EXEC.
IF SQLCODE NOT = 0
    PERFORM ERROR-HANDLING
END-IF.
```

### DB2 Integration Architecture

#### Database Tables
- **Z#####T**: Account information table with customer data
- **Standard Schema**: Account number, limits, balances, customer details

#### Host Variable Integration
```cobol
01 CUSTOMER-RECORD.
   02 ACCT-NO            PIC X(8).
   02 ACCT-LIMIT         PIC S9(7)V99 COMP-3.
   02 ACCT-BALANCE       PIC S9(7)V99 COMP-3.
   02 ACCT-LASTN         PIC X(20).
   02 ACCT-FIRSTN        PIC X(15).
```

#### SQL Communication Area (SQLCA)
- **SQLCODE**: Return code from SQL operations
- **SQLERRM**: Error message information
- **SQLWARN**: Warning indicators

## Program Documentation

### CBLDB21.cbl - Basic DB2 Report Generation
**Purpose**: Fundamental DB2 integration with report generation
**Complexity**: Intermediate
**Features**:
- Basic embedded SQL statements
- Cursor processing for result sets
- Report formatting with database data
- Standard error handling patterns

### CBLDB22.cbl - Enhanced DB2 Processing
**Purpose**: Advanced DB2 operations with comprehensive error handling
**Complexity**: Advanced
**Features**:
- Complex SQL queries
- Enhanced error handling and recovery
- Multiple cursor management
- Transaction processing

### CBLDB23.cbl - Advanced DB2 Operations
**Purpose**: Production-level DB2 integration
**Complexity**: Expert
**Features**:
- Advanced SQL operations
- Complex business logic integration
- Performance optimization techniques
- Enterprise error handling

### CBL0106.cbl - Debugging Exercise
**Purpose**: Debugging and error identification practice
**Complexity**: Educational
**Features**:
- Intentional coding errors for identification
- Common COBOL programming mistakes
- Debugging technique demonstration

## JCL Integration Patterns

### Database Compilation Pattern
```jcl
//COMPILE  EXEC DB2CBL,MEMBER=CBLDB21
//BIND     EXEC DSNUPROC,MEMBER=CBLDB21
//RUN      EXEC PGM=CBLDB21
```

### Database Setup Pattern
```jcl
//DB2SETUP EXEC DSNUPROC
//CRETBL   EXEC DSNUPROC,SQL='CREATE TABLE...'
//LOADTBL  EXEC DSNUPROC,SQL='INSERT INTO...'
```

### Resource Management
- **DBRMLIB.jcl**: Database Request Module library management
- **DB2SETUP.jcl**: Database environment initialization
- **SELTBL.jcl**: Table selection and validation

## Advanced COBOL Concepts Demonstrated

### Error Handling Strategies
1. **SQL Error Detection**: SQLCODE checking
2. **Error Message Formatting**: SQLERRM processing
3. **Recovery Procedures**: Rollback and retry logic
4. **User Error Reporting**: Formatted error messages

### Performance Optimization
1. **Cursor Efficiency**: Proper cursor usage patterns
2. **Transaction Management**: COMMIT/ROLLBACK strategies
3. **Resource Management**: Connection and cursor cleanup
4. **Memory Usage**: Efficient host variable usage

### Production Patterns
1. **Logging**: Error and transaction logging
2. **Monitoring**: Performance and error monitoring
3. **Recovery**: Restart and recovery procedures
4. **Maintenance**: Database maintenance integration

## Debugging Methodology

### Common Error Types (CBL0106 Exercise)
1. **Logic Errors**: Incorrect conditional statements
2. **Data Type Mismatches**: Incompatible data movements
3. **File Handling Errors**: Missing OPEN/CLOSE statements
4. **Calculation Errors**: Incorrect arithmetic operations

### Debugging Techniques
1. **Display Statements**: Strategic debugging output
2. **File Status Checking**: I/O operation validation
3. **Data Inspection**: Variable content verification
4. **Flow Control Analysis**: Program execution path tracing

## Modernization Considerations

### Database Integration Migration
- **COBOL + DB2** → **Modern Language + SQL Database**
- **Embedded SQL** → **ORM Frameworks**
- **Host Variables** → **Parameter Binding**
- **Cursors** → **Result Set Processing**

### Error Handling Evolution
- **SQLCODE Checking** → **Exception Handling**
- **Error Message Formatting** → **Logging Frameworks**
- **Manual Recovery** → **Automatic Retry Logic**

### Performance Optimization Translation
- **Cursor Management** → **Connection Pooling**
- **Transaction Control** → **Transaction Managers**
- **Resource Cleanup** → **Automatic Resource Management**

## Architecture Integration

### Traditional Architecture
```
COBOL Program ←→ DB2 Database
      ↓
   JCL Job Control
      ↓
  Mainframe System
```

### Modern Architecture Equivalent
```
Application ←→ SQL Database
     ↓
Container Orchestration
     ↓
  Cloud Platform
```

---

*Course #3 represents professional-level COBOL programming with enterprise database integration, demonstrating the sophisticated patterns used in production mainframe applications.*