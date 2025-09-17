# JCL Files Analysis

This document analyzes all JCL (Job Control Language) files used for compilation, execution, and database operations in the COBOL system.

## JCL File Categories

### 1. COBOL Compilation and Execution JCL

#### Standard Program JCL Pattern (CBL0001J.jcl, CBL0002J.jcl, etc.)
**Purpose**: Compile, link, and execute basic COBOL programs
- **Structure**:
  ```jcl
  //COBRUN  EXEC IGYWCL
  //COBOL.SYSIN  DD DSN=&SYSUID..CBL(program),DISP=SHR
  //LKED.SYSLMOD DD DSN=&SYSUID..LOAD(program),DISP=SHR
  //RUN     EXEC PGM=program
  ```
- **Key Components**:
  - Uses IGYWCL procedure (compile and link)
  - References source in `&SYSUID..CBL` dataset
  - Creates executable in `&SYSUID..LOAD` dataset
  - Executes program with data files
- **Data Assignments**:
  - `ACCTREC`: Input account data (`&SYSUID..DATA`)
  - `PRTLINE`: Output report file
- **Migration Impact**: Build and deployment process patterns

### 2. JCL Procedures (jclproc directory)

#### IGYWCL.jcl - COBOL Compile and Link Procedure
**Purpose**: Standard COBOL compilation and linking
- **Functionality**:
  - COBOL compilation step using IGYCRCTL
  - Link-edit step using IEWBLINK
  - Creates executable load modules
- **Key Parameters**:
  - `LNGPRFX='IGY630'`: COBOL compiler prefix
  - `LIBPRFX='CEE'`: Runtime library prefix
  - `SRC=COBOL`: Source member name
- **Technical Details**:
  - Uses SYSUT files for temporary storage
  - References COBOL runtime libraries
  - Conditional processing based on return codes
- **Migration Impact**: Build process automation

#### IGYWCLG.jcl - Compile, Link, and Go
**Purpose**: Extended procedure for compile, link, and execute
- **Migration Impact**: Complete CI/CD pipeline pattern

### 3. Database Operations JCL

#### DB2SETUP.jcl - Database Environment Setup
**Purpose**: Sets up DB2 development environment
- **Functionality**:
  - Copies DB2-related JCL and COBOL members
  - Creates DBRMLIB dataset for database request modules
  - Uses IEBCOPY utility for dataset operations
- **Key Operations**:
  - Copies compilation/execution JCL for DB2 programs
  - Copies DB2 COBOL source programs
  - Creates library for database binding
- **Migration Impact**: Database environment setup patterns

#### CRETBL.jcl - Create Database Tables
**Purpose**: Creates database tables and indexes
- **SQL Operations**:
  ```sql
  CREATE TABLESPACE &SYSUID.S IN DB2
  CREATE TABLE &SYSUID.T (
    ACCTNO    CHAR(8) NOT NULL,
    LIMIT     DECIMAL(9,2),
    BALANCE   DECIMAL(9,2),
    SURNAME   CHAR(20) NOT NULL,
    FIRSTN    CHAR(15) NOT NULL,
    ADDRESS1  CHAR(25),
    ADDRESS2  CHAR(20),
    ADDRESS3  CHAR(15),
    RESERVED  CHAR(7),
    COMMENTS  CHAR(50),
    PRIMARY KEY(ACCTNO)
  )
  CREATE UNIQUE INDEX &SYSUID.I ON &SYSUID.T (ACCTNO ASC)
  ```
- **Migration Impact**: Database schema definition

#### LOADTBL.jcl - Load Table Data
**Purpose**: Load data into database tables
- **Migration Impact**: Data loading processes

#### Database Compilation JCL (CBLDB21C.jcl, etc.)
**Purpose**: Compile COBOL programs with DB2 integration
- **Key Features**:
  - Uses DB2CBL procedure for DB2 COBOL compilation
  - Creates database request modules (DBRM)
  - Binds database plans
- **Migration Impact**: Database application build process

#### Database Execution JCL (CBLDB21R.jcl, etc.)
**Purpose**: Execute DB2 COBOL programs
- **Key Features**:
  - Sets up DB2 runtime environment
  - Executes programs with database connectivity
- **Migration Impact**: Database application runtime

### 4. Specialized JCL Procedures

#### DB2CBL.jcl - DB2 COBOL Compile Procedure
**Purpose**: Specialized compilation for DB2 COBOL programs
- **Functionality**:
  - COBOL compilation with DB2 precompiler
  - Creates DBRM (Database Request Module)
  - Link-edits with DB2 libraries
  - Binds DB2 plans
- **Key Steps**:
  1. COBOL compilation with SQL preprocessing
  2. Link-edit with DB2 runtime libraries
  3. BIND DB2 plan creation
- **Technical Details**:
  - References DB2 system libraries (DSNC10.SDSNLOAD)
  - Creates database request modules in DBRMLIB
  - Uses IKJEFT01 for DB2 bind operations
- **Migration Impact**: Database integration build process

#### DB2JCL.jcl - DB2 SQL Execution Procedure
**Purpose**: Execute SQL statements via JCL
- **Migration Impact**: Database administration scripts

## Common JCL Patterns

### 1. Dataset Naming Conventions
- `&SYSUID..CBL`: COBOL source programs
- `&SYSUID..JCL`: JCL members
- `&SYSUID..LOAD`: Executable load modules
- `&SYSUID..DATA`: Input data files
- `&SYSUID..DBRMLIB`: Database request modules

### 2. Compilation Process
1. **Source Preparation**: COBOL source in CBL dataset
2. **Compilation**: IGYCRCTL compiler creates object code
3. **Link-Edit**: IEWBLINK creates executable module
4. **Execution**: Program runs with data files

### 3. Database Process
1. **Precompilation**: DB2 precompiler processes embedded SQL
2. **COBOL Compilation**: Standard COBOL compilation
3. **DBRM Creation**: Database request module generated
4. **Link-Edit**: Link with DB2 runtime libraries
5. **Bind**: Create DB2 application plan
6. **Execution**: Run with DB2 connectivity

## Migration Implications

### Build Process Mapping
| Current (JCL) | Target (Spring Boot) |
|---------------|---------------------|
| COBOL Compilation | Java Compilation (Maven/Gradle) |
| Link-Edit | JAR/WAR packaging |
| Dataset Management | File system/artifact repository |
| Job Execution | Application server deployment |

### Database Process Mapping
| Current (DB2/JCL) | Target (PostgreSQL/Spring) |
|-------------------|---------------------------|
| DBRM/Bind | JPA Entity Configuration |
| Embedded SQL | JPA Repository Methods |
| DB2 Connection | Spring Data Source |
| SQL Scripts in JCL | Flyway/Liquibase Migrations |

### Deployment Process
- **Current**: JCL job submission, dataset management
- **Target**: Container deployment, configuration management

### Data Management
- **Current**: Fixed datasets, EBCDIC encoding
- **Target**: Relational tables, UTF-8 encoding