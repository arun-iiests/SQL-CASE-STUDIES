# My Learnings from SQL Case Studies
Through extensive practice with various SQL case studies, I have gained a comprehensive understanding of data manipulation and management
using SQL and Python. Here are the key learnings and techniques that I have mastered:

# Google Play Store Case Study
### 1. Handling Special Characters in Table Names:
  - Recognizing the need to use backticks when table names contain special characters to avoid syntax errors.
### 2. Data Cleaning:
  - Ensuring the correct date format (dd/mm/yyyy) in SQL.
  - Understanding that row counts may differ between SQL and Excel due to data type and format discrepancies, emphasizing the importance of data cleaning and standardization.
### 3. Bulk Data Import with LOAD DATA INFILE:
  - Utilizing the LOAD DATA INFILE statement in MySQL for efficient bulk importing of large datasets.
### 4. SQL Triggers:
  - Implementing triggers to enforce business rules, validate data, audit changes, and maintain database integrity.
### 5. UPDATE JOIN:
  - Using UPDATE JOIN to synchronize data across related tables.
### 6. Duration and Fetch Time:
  - Managing and monitoring query duration and fetch time for optimal database performance.



# Indian Tourism Case Study
### 1. Removing Duplicate Values Using Window Functions:
  - Utilizing the ROW_NUMBER() window function to identify and remove duplicates.
### 2. Handling Safe Updates:
  - Disabling safe updates mode when necessary for unrestricted updates.
### 3. Update and Insertion Techniques:
  - Mastering various techniques for efficient data updates and insertions.
### 4.Introduction to SQL Events:
  - Practicing creating and managing events to automate scheduled tasks within the database.

# Shark Tank India Case Study
### 1. Hands-on Working with Procedures:
  - Gaining practical experience with stored procedures to automate tasks and enforce business logic.
### 2. Pivoting Technique:
  - Applying pivoting techniques to transform and summarize data for better analysis.

# Swiggy Case Study
### 1. Finding Number of Null Values in a Column:
  - Reviewing techniques to find and count null values in specific columns.
### 2. Printing Column Names of a Table:
  - Learning to retrieve and print column names from a table.
### 3.Calculating Number of Null Values in a Table:
  - Dynamically calculating the number of null values across all columns in a table.
### 4. String Splitting Using Substring:
  - Exploring methods to split strings based on delimiters.

# DateTime-casestudy-flights-dataset
### 1. Extracting Date and Time Components:
  - Practical use case of: 
                        MONTHNAME(date):, 
                        DAYNAME(date):, 
                        DATE(date):, 
### 2. Aggregating Data by Time Intervals:
  - Grouping by Month or Weekday:
### 3. Filtering Data Based on Time Conditions:
  - TIME(datetime): Extracts the time part from a datetime
  - HOUR(time): Extracts the hour from a time, which helps in creating time-based filters
  - BETWEEN: Used to filter records within a specific time range, such as flights departing between 10 AM and 2 PM
### 4. Handling Weekend and Weekday Data:
  - DAYNAME(date) IN ('Saturday', 'Sunday'): Filters data to include only weekends.
### 5.Calculating Arrival Times:
  - STR_TO_DATE: Converts a string to a date.
  - CONCAT: Combines date and time strings into a single datetime string.
  - ADDDATE(datetime, INTERVAL value unit): Adds a specified time interval to a datetime.
### 6. Handling Multiple Dates:
  - DATE(departure) != DATE(arrival): Identifies flights that span multiple dates, indicating long-haul or overnight flights.

### 7. Practical use case of:
  - SEC_TO_TIME: Converts seconds to a time format.
  - TIME_FORMAT: Formats a time value according to a specified format.
  - AVG: Computes the average duration of flights between city pairs.
  - QUARTER(datetime): Extracts the quarter from a datetime, useful for quarterly analysis of flight data.

### 8.Weekday and Time Grids:
  - CASE: Creates conditional expressions for summarizing data in different time slots.
  - SUM and AVG: Aggregates data within specific time intervals to create grids showing frequency and average prices.

These insights and techniques reflect my continuous growth and understanding of SQL and Python, enabling effective data handling and manipulation across diverse datasets.











