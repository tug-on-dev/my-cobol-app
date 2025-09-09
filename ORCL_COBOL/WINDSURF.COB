       IDENTIFICATION DIVISION.
       PROGRAM-ID. WINDSURF.
       
       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WINDSURF-SESSION.
           05  SESSION-INFO.
               10  RIDER-NAME          PIC X(30)    VALUE 'Damien Henry'.
               10  SESSION-DATE        PIC X(10)    VALUE '31/07/2023'.
               10  SESSION-LOCATION    PIC X(30)    VALUE 'Pont-Mahe'.
               10  SESSION-TYPE        PIC X(10)    VALUE 'Slalom'.
           
           05  EQUIPMENT-INFO.
               10  BOARD-TYPE          PIC X(20).
               10  SAIL-SIZE           PIC X(20).
               10  FIN-TYPE            PIC X(20).
               10  GPS-MODEL           PIC X(10)    VALUE 'GW-60'.
           
           05  PERFORMANCE-METRICS.
               10  MAX-2S             PIC 99V99    VALUE 31.93.
               10  VMAX               PIC 99V99    VALUE 31.98.
               10  AVG-10S            PIC 99V99    VALUE 30.44.
               
               10  DISTANCE-MARKS.
                   15  MARK-100M      PIC 99V99    VALUE 30.54.
                   15  MARK-250M      PIC 99V99    VALUE 30.87.
                   15  MARK-500M      PIC 99V99    VALUE 30.02.
               
               10  TIME-SPLITS.
                   15  NAUTICAL-MILE  PIC 99V99    VALUE 24.04.
                   15  MARK-30MIN     PIC 99V99    VALUE 15.34.
                   15  MARK-1HOUR     PIC 99V99    VALUE 12.82.
           
           05  SESSION-TOTALS.
               10  ALPHA-500          PIC 999.
               10  TOTAL-DISTANCE     PIC 999V99   VALUE 71.98.
               10  SESSION-DURATION   PIC X(4)     VALUE '4h7'.
       
       PROCEDURE DIVISION.
           DISPLAY 'Windsurf Session Details:'.
           DISPLAY 'Rider: ' RIDER-NAME.
           DISPLAY 'Date: ' SESSION-DATE.
           DISPLAY 'Location: ' SESSION-LOCATION.
           DISPLAY 'Max Speed (2s): ' MAX-2S ' knots'.
           DISPLAY 'VMax: ' VMAX ' knots'.
           DISPLAY 'Average (10s): ' AVG-10S ' knots'.
           GOBACK.