# COBOL Programming Course #4 - Testing Labs Documentation

## Overview

Course #4 focuses on testing methodologies and practices in COBOL programming. It contains practical examples of payroll processing programs designed to demonstrate testing concepts, debugging techniques, and quality assurance practices in COBOL development.

## Files Documentation

### COBOL Programs

#### [DEPTPAY.CBL](./DEPTPAY.md) - Department Payroll Processing
**Purpose**: Department-level payroll calculations and reporting
**Complexity**: Intermediate
**Testing Focus**: Unit testing for department-level calculations

**Key Features**:
- Department information management
- Average salary calculations
- Manager information processing
- Employee count tracking
- COMPUTE statement usage

**Data Structure**:
```cobol
01  DEPT-RECORD.
    05  DEPT-NAME            PIC X(20).    - Department name
    05  DEPT-LOC             PIC X(12).    - Department location
    05  DEPT-MANAGER.                      - Manager information group
         10 MANAGER-FNAME    PIC X(15).
         10 MANAGER-LNAME    PIC X(15).
    05  DEPT-NBR-EMPS        PIC 9(3).     - Number of employees
    05  DEPT-TOTAL-SALARIES  PIC 9(7)V99.  - Total department salaries
    05  DEPT-AVG-SALARY      PIC 9(7)V99.  - Calculated average salary
```

**Business Logic**:
1. Initialize department data (FINANCE department)
2. Calculate average salary (DEPT-TOTAL-SALARIES / DEPT-NBR-EMPS)
3. Display department information and calculations

#### [EMPPAY.CBL](./EMPPAY.md) - Employee Payroll Processing
**Purpose**: Individual employee payroll calculations with overtime and bonuses
**Complexity**: Advanced
**Testing Focus**: Complex calculation testing and conditional logic validation

**Key Features**:
- Employee information management
- Hourly and overtime rate calculations
- Weekly and monthly pay calculations
- Conditional bonus processing
- Multi-tiered overtime logic

**Data Structure**:
```cobol
01  EMP-RECORD.
    05  EMP-NAME.
         10 EMP-FNAME        PIC X(15).    - Employee first name
         10 EMP-LNAME        PIC X(15).    - Employee last name
    05  EMP-HOURLY-RATE      PIC 9(3)V99.  - Base hourly rate
    05  EMP-OT-RATE          PIC V99.      - Overtime rate multiplier
    05  EMP-REWARD           PIC V99.      - Monthly bonus multiplier
    05  EMP-HOURS            PIC 9(3).     - Hours worked per week
    05  EMP-PAY-WEEK         PIC 9(7)V99.  - Calculated weekly pay
    05  EMP-PAY-MONTH        PIC 9(7)V99.  - Calculated monthly pay
```

**Business Logic**:
1. **Initialization**: Set employee data (Millard Fillmore, 19 hours, $23.50/hour)
2. **Weekly Payment Calculation**:
   - Overtime logic: ≥40 hours = 25% bonus, ≥50 hours = 50% bonus
   - Formula: (Hours × Rate) × (1 + Overtime Rate)
3. **Monthly Payment Calculation**:
   - Reward logic: >150 hours/month = 50% bonus
   - Formula: (Weekly Pay × 4) × (1 + Reward Rate)

### JCL Files

#### [DEPTPAY.JCL](./DEPTPAY.JCL.md) - Department Payroll Job
**Purpose**: Execute DEPTPAY.CBL program
**Features**: Standard compile-link-go pattern for testing

#### [EMPPAY.JCL](./EMPPAY.JCL.md) - Employee Payroll Job  
**Purpose**: Execute EMPPAY.CBL program
**Features**: Standard execution environment for testing

## Testing Concepts Demonstrated

### Unit Testing Scenarios

#### DEPTPAY Testing Cases
1. **Department Data Validation**:
   - Verify department name assignment
   - Validate manager information
   - Check location data accuracy

2. **Calculation Testing**:
   - Average salary calculation accuracy
   - Division operation validation
   - Numeric precision verification

3. **Display Output Testing**:
   - Format verification
   - Data presentation accuracy
   - Output completeness

#### EMPPAY Testing Cases
1. **Conditional Logic Testing**:
   ```cobol
   Test Case 1: Hours = 19 (< 40)
   Expected: EMP-OT-RATE = 0.00
   
   Test Case 2: Hours = 45 (>= 40, < 50)  
   Expected: EMP-OT-RATE = 0.25
   
   Test Case 3: Hours = 55 (>= 50)
   Expected: EMP-OT-RATE = 0.50
   ```

2. **Calculation Validation**:
   ```
   Base Calculation: 19 hours × $23.50 = $446.50
   With 0% overtime: $446.50 × 1.00 = $446.50
   Monthly (no reward): $446.50 × 4 = $1,786.00
   ```

3. **Edge Case Testing**:
   - Boundary conditions (40 hours, 50 hours, 150 hours)
   - Zero hour scenarios
   - Maximum value testing

### Testing Methodologies

#### Static Testing
- **Code Review**: Logic validation, syntax checking
- **Structure Analysis**: Program flow verification
- **Data Definition Review**: Field size and type validation

#### Dynamic Testing
- **Execution Testing**: Run programs with test data
- **Output Verification**: Compare actual vs expected results
- **Error Condition Testing**: Invalid input handling

#### Debugging Techniques
1. **Display Statement Insertion**: Add strategic DISPLAY statements
2. **Variable Inspection**: Monitor data changes during execution
3. **Step-by-Step Execution**: Trace program flow
4. **Conditional Breakpoints**: Pause at specific conditions

### Quality Assurance Patterns

#### Data Validation
```cobol
* Input validation example
IF EMP-HOURS < 0 OR EMP-HOURS > 168
    DISPLAY "Invalid hours: " EMP-HOURS
    PERFORM ERROR-HANDLING
END-IF
```

#### Error Handling
```cobol
* Calculation error handling
IF DEPT-NBR-EMPS = 0
    MOVE 0 TO DEPT-AVG-SALARY
    DISPLAY "Warning: No employees in department"
ELSE
    COMPUTE DEPT-AVG-SALARY = DEPT-TOTAL-SALARIES / DEPT-NBR-EMPS
END-IF
```

#### Test Data Management
- **Standard Test Cases**: Predefined employee/department data
- **Boundary Testing**: Edge case scenarios
- **Error Scenarios**: Invalid data conditions

## Modern Testing Equivalent

### Unit Testing Framework (JUnit Style)
```java
@Test
public void testOvertimeCalculation() {
    Employee emp = new Employee("Millard", "Fillmore", 23.50);
    emp.setHours(45);
    
    double expectedOvertimeRate = 0.25;
    double actualOvertimeRate = emp.calculateOvertimeRate();
    
    assertEquals(expectedOvertimeRate, actualOvertimeRate, 0.01);
}

@Test
public void testWeeklyPayCalculation() {
    Employee emp = new Employee("Millard", "Fillmore", 23.50);
    emp.setHours(19);
    
    double expectedWeeklyPay = 19 * 23.50 * 1.0; // No overtime
    double actualWeeklyPay = emp.calculateWeeklyPay();
    
    assertEquals(expectedWeeklyPay, actualWeeklyPay, 0.01);
}
```

### Test Automation
```bash
# Automated testing script equivalent
#!/bin/bash
compile_program DEPTPAY.CBL
if [ $? -eq 0 ]; then
    run_test_cases DEPTPAY "test_data.txt"
    validate_output "expected_output.txt" "actual_output.txt"
fi
```

## Testing Documentation Requirements

### Test Case Format
```
Test Case ID: TC_EMPPAY_001
Description: Validate overtime calculation for 45 hours
Preconditions: Employee with 45 hours, $23.50 rate
Input Data: Hours=45, Rate=23.50
Expected Result: Overtime Rate = 0.25, Weekly Pay = $1,316.25
Actual Result: [To be filled during execution]
Status: [Pass/Fail]
```

### Test Coverage Areas
1. **Functional Testing**: Business logic validation
2. **Boundary Testing**: Edge case scenarios  
3. **Error Testing**: Invalid input handling
4. **Integration Testing**: Program interaction validation
5. **Performance Testing**: Execution time validation

## Modernization Testing Considerations

### Legacy to Modern Testing Migration
1. **Manual Testing** → **Automated Test Suites**
2. **Print Output Verification** → **Assertion-Based Testing**
3. **JCL Job Testing** → **Continuous Integration Pipelines**
4. **Mainframe Debugging** → **Modern IDE Debugging**

### Testing Tool Evolution
- **COBOL Display Statements** → **Logging Frameworks**
- **Manual Output Comparison** → **Automated Test Assertions**
- **Batch Job Testing** → **API Testing Frameworks**
- **Mainframe Profilers** → **Modern Performance Testing Tools**

---

*Course #4 demonstrates essential testing practices in COBOL development, providing foundational knowledge for quality assurance in enterprise mainframe applications and modern testing methodology migration.*