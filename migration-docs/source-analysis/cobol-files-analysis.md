# COBOL Source Files Analysis

This document provides a comprehensive analysis of all COBOL source files in the repository, documenting their purpose, functionality, and key technical details for migration planning.

## File Classification

### Basic COBOL Programs (Course #2)

#### CBL0001.cobol - Account Records File Processing
**Purpose**: Basic file processing demonstration
- **Functionality**: Reads account records from input file, formats and writes to output file
- **Key Data Structures**:
  - `ACCT-FIELDS`: Account record with number, limit, balance, names, address, comments
  - `PRINT-REC`: Formatted output record
- **Technical Details**:
  - Fixed-length record processing
  - COMP-3 packed decimal fields for monetary amounts
  - File I/O with READ/WRITE operations
- **Migration Impact**: Core entity model for Account data

#### CBL0002.cobol - Account Records Processing (Variant)
**Purpose**: Similar to CBL0001 with slight modifications
- **Functionality**: Account file processing with different output formatting
- **Key Difference**: Contains a typo in line 78 (`PRINT-REX` instead of `PRINT-REC`)
- **Migration Impact**: Same as CBL0001, demonstrates error handling needs

#### CBL0006.cobol - Financial Report Generation
**Purpose**: Complex report generation with headers and date handling
- **Functionality**: 
  - Processes account records with state filtering (Virginia clients)
  - Generates formatted financial reports with headers
  - Uses CURRENT-DATE function for timestamp
- **Key Data Structures**:
  - `HEADER-1`, `HEADER-2`, `HEADER-3`: Report formatting structures
  - `CLIENTS-PER-STATE`: State-specific counting
  - `WS-CURRENT-DATE-DATA`: Date/time handling
- **Technical Details**:
  - Complex report formatting
  - Date/time functions
  - Conditional processing
- **Migration Impact**: Reporting module, date/time utilities

#### PAYROL00.cobol - Basic Payroll Calculation
**Purpose**: Simple payroll calculation demonstration
- **Functionality**: 
  - Basic arithmetic operations (hours × rate = gross pay)
  - Variable initialization and display
- **Key Data Structures**:
  - Simple numeric and text variables (WHO, WHERE, WHY, RATE, HOURS, GROSS-PAY)
- **Technical Details**:
  - COMPUTE statement for calculations
  - MOVE statements for data transfer
  - DISPLAY for output
- **Migration Impact**: Business logic pattern for calculations

#### PAYROL0X.cobol - Extended Payroll Processing
**Purpose**: More complex payroll processing (file not examined in detail)
- **Migration Impact**: Advanced payroll business logic

#### File Search Programs
- **SRCHBIN.cobol**: Binary search algorithm implementation
- **SRCHSER.cobol**: Sequential search algorithm implementation
- **Purpose**: Demonstrate search algorithms in COBOL
- **Migration Impact**: Algorithm patterns for Java implementation

### Database Programs (Course #3)

#### CBLDB21.cbl - Database Report Generation
**Purpose**: DB2 database integration for account reporting
- **Functionality**:
  - Connects to DB2 database using embedded SQL
  - Declares cursor for account table (Z#####T)
  - Fetches and formats account records for reports
- **Key Data Structures**:
  - `CUSTOMER-RECORD`: Database record structure
  - SQL cursor (CUR1) for database iteration
  - Error handling structures
- **Technical Details**:
  - Embedded SQL with EXEC SQL statements
  - SQLCA (SQL Communication Area) for error handling
  - Cursor-based database processing
  - COMP-3 packed decimal for monetary fields
- **Migration Impact**: Core database access pattern, entity mapping

#### CBLDB22.cbl - Advanced Database Operations
**Purpose**: More complex database operations (not examined in detail)
- **Migration Impact**: Advanced database business logic patterns

#### CBLDB23.cbl - Database Maintenance Operations
**Purpose**: Database maintenance and updates (not examined in detail)
- **Migration Impact**: Data manipulation patterns

### Utility and Test Programs

#### HELLO.cobol - Basic Program Structure
**Purpose**: Simple "Hello World" type program
- **Migration Impact**: Basic program structure pattern

#### ADDAMT.cobol - Amount Addition Utility
**Purpose**: Utility for adding amounts (not examined in detail)
- **Migration Impact**: Utility function patterns

#### CBL0004-CBL0012.cobol - Course Examples
**Purpose**: Various programming concepts and exercises
- **Migration Impact**: Additional business logic patterns

## Common Patterns Identified

### Data Types and Structures
1. **Account Records**: Core business entity with consistent structure
2. **Monetary Fields**: COMP-3 packed decimal format (PIC S9(7)V99)
3. **Text Fields**: Fixed-length character fields (PIC X(n))
4. **Numeric Fields**: Various formats (PIC 9(n), PIC S9(n))

### Processing Patterns
1. **File Processing**: READ-PROCESS-WRITE loops
2. **Database Access**: Cursor-based SQL operations
3. **Report Generation**: Header/detail formatting
4. **Error Handling**: Structured error checking

### Business Logic
1. **Account Management**: Core financial account operations
2. **Payroll Processing**: Time and rate calculations
3. **Report Generation**: Formatted output with headers
4. **Search Operations**: Various search algorithms

## Migration Implications

### Core Entities Identified
- **Account**: Primary business entity
- **Customer**: Personal information
- **Address**: Geographic information
- **Transaction**: Financial operations

### Key Functionalities
- File/Database I/O operations
- Report generation
- Calculation engines
- Search and retrieval operations
- Error handling and validation