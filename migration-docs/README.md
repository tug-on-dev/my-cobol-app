# COBOL to Java Spring Boot Migration Documentation

This directory contains comprehensive documentation for migrating the COBOL/JCL application system to a modern Java Spring Boot application using JPA and PostgreSQL.

## Directory Structure

- **source-analysis/**: Detailed analysis of all COBOL and JCL source files
- **diagrams/**: Mermaid diagrams illustrating system architecture, data flows, and migration phases
- **planning/**: Migration strategy, phases, and implementation plans
- **data-mapping/**: Data structure mapping from COBOL to Java/JPA entities

## Migration Overview

This project migrates a mainframe COBOL application system from:
- **Source**: COBOL programs, JCL batch processing, DB2 database, z/OS platform
- **Target**: Java Spring Boot application, REST APIs, JPA entities, PostgreSQL database

## Key Components

### Current System
- **Basic COBOL Programs**: File processing, report generation, arithmetic operations
- **Advanced DB2 Integration**: Database operations, SQL embedded in COBOL
- **Batch Processing**: JCL job control for compilation, linking, and execution
- **Data Management**: Fixed-length records, packed decimal fields, EBCDIC encoding

### Target System
- **Spring Boot Application**: RESTful web services, microservices architecture
- **JPA Data Layer**: Object-relational mapping, entity relationships
- **PostgreSQL Database**: Modern relational database with JSON support
- **Cloud-Ready**: Containerizable, scalable, maintainable

## Getting Started

1. Review the [Source Analysis](source-analysis/) to understand the current system
2. Examine the [System Diagrams](diagrams/) for visual representations
3. Follow the [Migration Planning](planning/) for implementation strategy
4. Use the [Data Mapping](data-mapping/) for converting data structures