# COBOL and JCL Files Documentation

This directory contains comprehensive documentation for all COBOL and JCL files in the repository, organized to help developers understand the codebase for potential migration to new technologies.

## Directory Structure

### [ORCL_COBOL/](./ORCL_COBOL/)
Oracle-specific COBOL programs for database integration.
- **CBDEM1.COB** - Employee database management system
- **WINDSURF.COB** - Windsurf session tracking application

### [COBOL Programming Course #2 - Learning COBOL/Labs/](./COBOL%20Programming%20Course%20%232%20-%20Learning%20COBOL/Labs/)
Basic COBOL programming examples and exercises.
- 19 COBOL programs (.cobol files)
- 23 JCL job control files (.jcl files)
- 3 JCL procedure files

### [COBOL Programming Course #3 - Advanced Topics/](./COBOL%20Programming%20Course%20%233%20-%20Advanced%20Topics/)
Advanced COBOL features including DB2 integration and debugging.
- **Labs/** - 3 DB2 integration programs and 10 supporting JCL files
- **Challenges/** - 2 debugging exercise programs and 1 JCL file

### [COBOL Programming Course #4 - Testing/Labs/](./COBOL%20Programming%20Course%20%234%20-%20Testing/Labs/)
Testing-focused COBOL programs.
- **DEPTPAY.CBL** - Department payroll processing
- **EMPPAY.CBL** - Employee payroll processing
- Supporting JCL files

## Documentation Types

Each file is documented with:

### Reference Documentation
- **File Purpose**: Clear description of what the program does
- **Program Structure**: Main divisions, sections, and procedures
- **Data Structures**: Detailed breakdown of data definitions and relationships
- **Dependencies**: External files, databases, and system dependencies
- **Parameters**: Input/output specifications

### Explanation Documentation
- **Design Rationale**: Why the program was designed this way
- **Business Logic**: How the program fits into business processes
- **Data Flow**: How data moves through the program
- **Integration Points**: How it connects with other systems

## Navigation

- **By Directory**: Browse files organized by their location in the source tree
- **By Type**: 
  - [COBOL Programs](./cobol-programs.md) - All .COB, .cbl, .CBL, .cobol files
  - [JCL Files](./jcl-files.md) - All Job Control Language files
- **By Function**:
  - [Database Integration](./database-integration.md)
  - [Report Generation](./report-generation.md)
  - [Data Processing](./data-processing.md)

## Architectural Overview

The codebase represents a collection of COBOL programs spanning from basic educational examples to production-ready database integration systems. The architecture follows traditional mainframe patterns with clear separation between:

1. **Data Processing Layer** - File I/O and data manipulation
2. **Business Logic Layer** - Calculations and business rules
3. **Presentation Layer** - Report formatting and output
4. **Integration Layer** - Database connections and external system interfaces

## Getting Started

1. Start with the [Architectural Overview](./architectural-overview.md)
2. Review the [Data Flow Diagrams](./data-flow-diagrams.md)
3. Explore individual program documentation by directory
4. Reference the [Cross-Reference Guide](./cross-reference.md) for dependencies

---

*This documentation is designed following Diátaxis principles to serve developers preparing for codebase migration and modernization efforts.*