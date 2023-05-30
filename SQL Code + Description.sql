SELECT Id, ActivityDate, TotalSteps, Calories
INTO Daily_Activity
FROM dbo.dailyActivity_merged

SELECT *
INTO Daily_Steps
FROM dbo.dailySteps_merged

SELECT *
INTO Daily_Sleep
FROM dbo.sleepDay_merged

SELECT *
INTO Hourly_Steps
FROM dbo.hourlySteps_merged




----- Daily Activity

--------The provided SQL queries aim to improve the clarity and usability of the "Daily_Activity" table. 
--------This is achieved by renaming certain columns to more descriptive names, such as changing "Id" to "id", 
--------"ActivityDate" to "date", "TotalSteps" to "steps", and "Calories" to "calories". Additionally, 
--------the "date" column is standardized by converting its values to a consistent date format using the 
--------CONVERT function with a style code of 101.


EXEC sp_rename 'Daily_Activity.Id', 'id', 'COLUMN';
EXEC sp_rename 'Daily_Activity.ActivityDate', 'date', 'COLUMN';
EXEC sp_rename 'Daily_Activity.TotalSteps', 'steps', 'COLUMN';
EXEC sp_rename 'Daily_Activity.Calories', 'calories', 'COLUMN';

UPDATE Daily_Activity
SET date = CONVERT(date, date, 101)



----- Daily Sleep

--------The provided SQL queries aim to improve the clarity and usability of the "Daily_Activity" table. 
--------This is achieved by renaming of specific columns to ensure more descriptive names. 
--------For instance, "Id" is changed to "id", "TotalMinutesAsleep" is modified to "minutes_asleep", 
--------and "TotalTimeInBed" is transformed into "minutes_in_bed".
--------Furthermore, alterations are made to the table structure. 
--------First, two new columns, namely "date" and "time", are added to the "Daily_Sleep" table using the ALTER TABLE statement. 
--------The "date" column is intended to store date values, while the "time" column is designated for time values.
--------To populate the newly added "date" and "time" columns, an UPDATE statement is employed. 
--------The existing column "SleepDay" is converted to a date format using the CONVERT function with a style code of 101, 
--------and the resulting value is assigned to the "date" column. Similarly, the "SleepDay" column is converted to a time format with a precision of 0, 
--------and the obtained value is stored in the "time" column.
--------Following these modifications, the columns "SleepDay" and "TotalSleepRecords" are removed from the "Daily_Sleep" table using the ALTER TABLE statement.




EXEC sp_rename 'Daily_Sleep.Id', 'id', 'COLUMN';
EXEC sp_rename 'Daily_Sleep.TotalMinutesAsleep', 'minutes_asleep', 'COLUMN';
EXEC sp_rename 'Daily_Sleep.TotalTimeInBed', 'minutes_in_bed', 'COLUMN';


ALTER TABLE Daily_Sleep
ADD [date] DATE,
    [time] TIME(0);

UPDATE Daily_Sleep
SET [date] = CONVERT(DATE, SleepDay, 101),
    [time] = CONVERT(TIME(0), SleepDay);

ALTER TABLE Daily_Sleep
DROP COLUMN SleepDay;

ALTER TABLE Daily_Sleep
DROP COLUMN TotalSleepRecords



----- Daily Steps

--------The provided SQL queries focus on improving the clarity and usability of the "Daily_Steps" table. 
--------To achieve this, the code snippet begins with the renaming of specific columns to more descriptive names. 
--------The column names are changed from "Id" to "id", "ActivityDay" to "date", and "StepTotal" to "steps".
--------Following the column renaming process, an update statement is used to modify the "date" column. 
--------The existing values in the "date" column are converted to a consistent date format using the CONVERT function with a style code of 101. 
--------This conversion ensures uniformity and consistency in the date values.


EXEC sp_rename 'Daily_Steps.Id', 'id', 'COLUMN';
EXEC sp_rename 'Daily_Steps.ActivityDay', 'date', 'COLUMN';
EXEC sp_rename 'Daily_Steps.StepTotal', 'steps', 'COLUMN';

UPDATE Daily_Steps
SET date = CONVERT(date, date, 101)




----- Hourly Steps

--------The provided SQL queries are intended to enhance the clarity and usability of the "Hourly_Steps" table. 
--------The code snippet begins with the renaming of specific columns to more descriptive names. 
--------The column "Id" is changed to "id", and "StepTotal" is modified to "steps".
--------Additionally, alterations are made to the table structure. 
--------The ALTER TABLE statement is used to add two new columns, "date" and "time", to the "Hourly_Steps" table. 
--------The "date" column is intended to store date values, while the "time" column is designated for time values.
--------To populate the newly added "date" and "time" columns, an UPDATE statement is employed. 
--------The existing column "ActivityHour" is converted to a date format using the CONVERT function with a style code of 101, 
--------and the resulting value is assigned to the "date" column. 
--------Similarly, the "ActivityHour" column is converted to a time format with a precision of 0, and the obtained value is stored in the "time" column.
--------Following these modifications, the column "ActivityHour" is removed from the "Hourly_Steps" table using the ALTER TABLE statement.



EXEC sp_rename 'Hourly_Steps.Id', 'id', 'COLUMN';
EXEC sp_rename 'Hourly_Steps.StepTotal', 'steps', 'COLUMN';

ALTER TABLE Hourly_Steps
ADD [date] DATE,
    [time] TIME(0);

UPDATE Hourly_Steps
SET [date] = CONVERT(DATE, ActivityHour, 101),
    [time] = CONVERT(TIME(0), ActivityHour);

ALTER TABLE Hourly_Steps
DROP COLUMN ActivityHour;



