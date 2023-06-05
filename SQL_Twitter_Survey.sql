

--Renaming columns: 
--Renames specific columns in the "Twittersurvey" table.

EXEC sp_rename 'Twittersurvey.Unique_ID', 'id', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Date_Taken_America_New_York', 'date', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Time_Taken_America_New_York', 'time', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Time_Spent', 'time_spent', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q1_Which_Title_Best_Fits_your_Current_Role', 'current_role', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q2_Did_you_switch_careers_into_data', 'career_switch', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q3_Current_Yearly_Salary_in_USD', 'current_salary', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q4_What_Industry_do_you_work_in', 'industry', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q5_Favorite_Programming_Language', 'favourite_programming_language', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q7_How_difficult_was_it_for_you_to_break_into_data', 'career_switch_difficulty', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q8_if_you_were_to_look_for_a_new_job_today_what_would_be_the_most_important_thing_to_you', 'important_needs', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q9_Male_Female', 'gender', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q10_Current_Age', 'age', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q11_Which_Country_do_you_live_in', 'location', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q12_Highest_Level_of_Education', 'education', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q13_Ethnicity', 'ethnicity', 'COLUMN';

EXEC sp_rename 'Twittersurvey.Q6_How_Happy_are_you_in_your_Current_Position_with_the_following_Salary', 'happiness_with_salary', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q6_How_Happy_are_you_in_your_Current_Position_with_the_following_Work_Life_Balance', 'happiness_with_work_life_balance', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q6_How_Happy_are_you_in_your_Current_Position_with_the_following_Coworkers', 'happiness_with_coworkers', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q6_How_Happy_are_you_in_your_Current_Position_with_the_following_Management', 'happiness_with_management', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q6_How_Happy_are_you_in_your_Current_Position_with_the_following_Upward_Mobility', 'happiness_with_upward_mobility', 'COLUMN';
EXEC sp_rename 'Twittersurvey.Q6_How_Happy_are_you_in_your_Current_Position_with_the_following_Learning_New_Things', 'happiness_with_skills_development', 'COLUMN';




--Dropping unused columns: 
--Removes specified columns from the "Twittersurvey" table.


ALTER TABLE Twittersurvey
DROP COLUMN Email, Browser, OS, City, Country, Referrer;




--Creating a copy of the table: 
--Creates a new table "Twitter_Survey_clean" with the same structure and data as the original table.


SELECT *
INTO Twitter_Survey_clean
FROM Twittersurvey

SELECT * FROM Twitter_Survey_clean




--Formatting time column: 
--Adds a new column "formatted_time_column" with time values converted to a specific format, then renames the column to "time".


ALTER TABLE Twitter_Survey_clean
ADD formatted_time_column VARCHAR(5);

UPDATE Twitter_Survey_clean
SET formatted_time_column = CONVERT(VARCHAR(5), time, 108);

ALTER TABLE Twitter_Survey_clean
DROP COLUMN time

EXEC sp_rename 'Twitter_Survey_clean.formatted_time_column', 'time', 'COLUMN';




--Formatting time_spent column: 
--Adds a new column "ts_column" with time_spent values converted to a specific format, then renames the column to "time_spent".


ALTER TABLE Twitter_Survey_clean
ADD ts_column VARCHAR(8);

UPDATE Twitter_Survey_clean
SET ts_column = CONVERT(VARCHAR(8), time_spent, 108);

ALTER TABLE Twitter_Survey_clean
DROP COLUMN time_spent

EXEC sp_rename 'Twitter_Survey_clean.ts_column', 'time_spent', 'COLUMN';




--Splitting role columns: 
--Splits the "current_role" column into "role_column" and "other_answer_column" based on the presence of "Other" values.


ALTER TABLE Twitter_Survey_clean
ADD role_column VARCHAR(100),
    other_answer_column VARCHAR(100);

UPDATE Twitter_Survey_clean
SET role_column = CASE
                        WHEN current_role LIKE 'Other%' THEN 'Other'
                        ELSE current_role
                 END,
    other_answer_column = CASE
                        WHEN current_role LIKE 'Other%' THEN SUBSTRING(current_role, CHARINDEX(':', current_role) + 1, LEN(current_role))
                        ELSE NULL
                     END;

ALTER TABLE Twitter_Survey_clean
DROP COLUMN current_role

EXEC sp_rename 'Twitter_Survey_clean.role_column', 'current_role', 'COLUMN';
EXEC sp_rename 'Twitter_Survey_clean.other_answer_column', 'other_role_specified', 'COLUMN';




--Splitting industry columns: 
--Splits the "industry" column into "industry_column" and "other_answer_column" based on the presence of "Other" values.


ALTER TABLE Twitter_Survey_clean
ADD industry_column VARCHAR(100),
    other_answer_column VARCHAR(100);

UPDATE Twitter_Survey_clean
SET industry_column = CASE
                        WHEN industry LIKE 'Other%' THEN 'Other'
                        ELSE industry
                 END,
    other_answer_column = CASE
                        WHEN industry LIKE 'Other%' THEN SUBSTRING(industry, CHARINDEX(':', industry) + 1, LEN(industry))
                        ELSE NULL
                     END;


ALTER TABLE Twitter_Survey_clean
DROP COLUMN industry

EXEC sp_rename 'Twitter_Survey_clean.industry_column', 'industry', 'COLUMN';
EXEC sp_rename 'Twitter_Survey_clean.other_answer_column', 'other_industry_specified', 'COLUMN';




--Splitting salary column: 
--Splits the "current_salary" column into "low_range" and "high_range" columns based on the "-" delimiter.


ALTER TABLE Twitter_Survey_clean
ADD low_range DECIMAL(10,2),
    high_range DECIMAL(10,2);

UPDATE Twitter_Survey_clean
SET low_range = CASE
                    WHEN CHARINDEX('-', current_salary) > 0 THEN CAST(REPLACE(SUBSTRING(current_salary, 1, CHARINDEX('-', current_salary) - 1), 'k', '') AS DECIMAL(10, 2))
                    ELSE NULL
                END,
    high_range = CASE
                    WHEN CHARINDEX('-', current_salary) > 0 THEN CAST(REPLACE(SUBSTRING(current_salary, CHARINDEX('-', current_salary) + 1, LEN(current_salary)), 'k', '') AS DECIMAL(10, 2))
                    ELSE NULL
                END;




--Calculating the average of salary range: 
--Adds a new column "salary_average" with the average value between the low and high range.


ALTER TABLE Twitter_Survey_clean
ADD salary_average DECIMAL(10,2);

UPDATE Twitter_Survey_clean
SET salary_average = (low_range + high_range) / 2;


ALTER TABLE Twitter_Survey_clean
ADD average_salary DECIMAL(10,0);

 UPDATE Twitter_Survey_clean
SET average_salary = (salary_average) * 1000;

ALTER TABLE Twitter_Survey_clean
DROP COLUMN current_salary

EXEC sp_rename 'Twitter_Survey_clean.average_salary', 'current_salary', 'COLUMN';

SELECT * FROM Twitter_Survey_clean




--Splitting location column: 
--Splits the "location" column into "location_column" and "other_location_specified" based on the presence of "Other" values.


ALTER TABLE Twitter_Survey_clean
ADD location_column VARCHAR(100),
    other_location_specified VARCHAR(100);

UPDATE Twitter_Survey_clean
SET location_column = CASE
                        WHEN location LIKE 'Other%' THEN 'Other'
                        ELSE location
                 END,
    other_location_specified = CASE
                        WHEN location LIKE 'Other%' THEN SUBSTRING(location, CHARINDEX(':', location) + 1, LEN(location))
                        ELSE NULL
                     END;

ALTER TABLE Twitter_Survey_clean
DROP COLUMN location

EXEC sp_rename 'Twitter_Survey_clean.location_column', 'location', 'COLUMN';




--Splitting favorite programming language column: 
--Splits the "favourite_programming_language" column into "fpl_column" and "other_programming_language" based on the presence of "Other" values, considering length constraints.


ALTER TABLE Twitter_Survey_clean
ADD fpl_column VARCHAR(100),
    other_programming_language VARCHAR(100);

UPDATE Twitter_Survey_clean
SET fpl_column = CASE
                        WHEN favourite_programming_language LIKE 'Other%' THEN 'Other'
                        ELSE favourite_programming_language
                 END,
    other_programming_language = CASE
                        WHEN favourite_programming_language LIKE 'Other%' THEN 
                            CASE
                                WHEN LEN(SUBSTRING(favourite_programming_language, CHARINDEX(':', favourite_programming_language) + 1, LEN(favourite_programming_language))) > 100 THEN NULL
                                ELSE SUBSTRING(favourite_programming_language, CHARINDEX(':', favourite_programming_language) + 1, LEN(favourite_programming_language))
                            END
                        ELSE NULL
                     END;

ALTER TABLE Twitter_Survey_clean
DROP COLUMN favourite_programming_language

EXEC sp_rename 'Twitter_Survey_clean.fpl_column', 'favourite_programming_language', 'COLUMN';




--Splitting ethnicity column: 
--Splits the "ethnicity" column into "ethnicity_column" and "other_ethnicity_specified" based on the presence of "Other" values.


ALTER TABLE Twitter_Survey_clean
ADD ethnicity_column VARCHAR(100),
    other_ethnicity_specified VARCHAR(100);

UPDATE Twitter_Survey_clean
SET ethnicity_column = CASE
                        WHEN ethnicity LIKE 'Other%' THEN 'Other'
                        ELSE ethnicity
                 END,
    other_ethnicity_specified = CASE
                        WHEN ethnicity LIKE 'Other%' THEN SUBSTRING(ethnicity, CHARINDEX(':', ethnicity) + 1, LEN(ethnicity))
                        ELSE NULL
                     END;

ALTER TABLE Twitter_Survey_clean
DROP COLUMN ethnicity

EXEC sp_rename 'Twitter_Survey_clean.ethnicity_column', 'ethnicity', 'COLUMN';




--Splitting important needs column: 
--Splits the "important_needs" column into "IN_column" and "other_needs_specified" based on the presence of "Other" values, considering length constraints.


ALTER TABLE Twitter_Survey_clean
ADD IN_column VARCHAR(100),
    other_needs_specified VARCHAR(100);

UPDATE Twitter_Survey_clean
SET IN_column = CASE
                        WHEN important_needs LIKE 'Other%' THEN 'Other'
                        ELSE important_needs
                 END,
    other_needs_specified = CASE
                              WHEN important_needs LIKE 'Other%' THEN 
                            CASE
                                WHEN LEN(SUBSTRING(important_needs, CHARINDEX(':', important_needs) + 1, LEN(important_needs))) > 100 THEN NULL
                                ELSE SUBSTRING(important_needs, CHARINDEX(':', important_needs) + 1, LEN(important_needs))
                            END
                        ELSE NULL
                     END;


ALTER TABLE Twitter_Survey_clean
DROP COLUMN important_needs

EXEC sp_rename 'Twitter_Survey_clean.IN_column', 'important_needs', 'COLUMN';




--Replacing NULL values: 
--Updates the "Twitter_Survey_clean" table and replaces any NULL values in the columns "education," "other_role_specified," "other_industry_specified," "other_location_specified," "other_programming_language," "other_ethnicity_specified," and "other_needs_specified" with the string 'NA' using the COALESCE function. 
--This ensures consistent and standardized representation of missing values in the dataset.

UPDATE Twitter_Survey_clean
SET education = COALESCE(education, 'NA'),
    other_role_specified = COALESCE(other_role_specified, 'NA'),
	other_industry_specified = COALESCE(other_industry_specified, 'NA'),
     other_location_specified = COALESCE( other_location_specified, 'NA'),
	 other_programming_language = COALESCE( other_programming_language, 'NA'),
	  other_ethnicity_specified = COALESCE( other_ethnicity_specified, 'NA'),
	 other_needs_specified = COALESCE(other_needs_specified, 'NA');




--Creating tables with clean data: 
--Creates separate tables "Twitter_Survey_Salaries," "Twitter_Survey_Demographic," "Twitter_Survey_Happiness," "Twitter_Survey_Career," and "Twitter_Survey_Summary" with selected columns from the cleaned data.


SELECT id, current_role, other_role_specified, current_salary, low_range, high_range, salary_average
INTO Twitter_Survey_Salaries
FROM Twitter_Survey_clean

SELECT id, date, current_role, other_role_specified, current_salary, education, age, gender, ethnicity, location, other_location_specified
INTO Twitter_Survey_Demographic
FROM Twitter_Survey_clean

SELECT id, happiness_with_salary, happiness_with_work_life_balance, happiness_with_coworkers, happiness_with_management, happiness_with_upward_mobility, happiness_with_skills_development
INTO Twitter_Survey_Happiness
FROM Twitter_Survey_clean

SELECT id, career_switch, career_switch_difficulty, important_needs, favourite_programming_language, industry
INTO Twitter_Survey_Career
FROM Twitter_Survey_clean

SELECT id, gender, age, ethnicity, location, current_role, industry, current_salary, favourite_programming_language
INTO Twitter_Survey_Summary
FROM Twitter_Survey_clean




SELECT * FROM Twitter_Survey_clean