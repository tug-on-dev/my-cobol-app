import java.io.*;
import java.util.*;

public class RecordProcessor {

    private static final String VIRGINIA = "Virginia";
    private List<Record> records = new ArrayList<>();
    private int virginiaClients = 0;

    public static void main(String[] args) {
        RecordProcessor processor = new RecordProcessor();
        processor.processRecords();
    }

    public void processRecords() {
        readRecords();
        for (Record record : records) {
            if (isStateVirginia(record)) {
                virginiaClients++;
            }
            writeRecord(record);
        }
        closeStop();
    }

    private void readRecords() {
        // Implement reading records from a file or database
        // For example purposes, we will add dummy records
        records.add(new Record("123", "1000", "500", "Smith", "Virginia"));
        records.add(new Record("124", "2000", "1500", "Johnson", "California"));
    }

    private boolean isStateVirginia(Record record) {
        return VIRGINIA.equals(record.getState());
    }

    private void writeRecord(Record record) {
        // Implement writing records to a file or output stream
        System.out.println("Account No: " + record.getAcctNo());
        System.out.println("Account Limit: " + record.getAcctLimit());
        System.out.println("Account Balance: " + record.getAcctBalance());
        System.out.println("Last Name: " + record.getLastName());
    }

    private void closeStop() {
        // Implement closing resources and final output
        System.out.println("Clients per state: " + virginiaClients);
    }

    class Record {
        private String acctNo;
        private String acctLimit;
        private String acctBalance;
        private String lastName;
        private String state;

        public Record(String acctNo, String acctLimit, String acctBalance, String lastName, String state) {
            this.acctNo = acctNo;
            this.acctLimit = acctLimit;
            this.acctBalance = acctBalance;
            this.lastName = lastName;
            this.state = state;
        }

        public String getAcctNo() {
            return acctNo;
        }

        public String getAcctLimit() {
            return acctLimit;
        }

        public String getAcctBalance() {
            return acctBalance;
        }

        public String getLastName() {
            return lastName;
        }

        public String getState() {
            return state;
        }
    }
}