/* Script: BikeSalesDWMinions CreateTableForTimeDimension.sql
   Purpose: To create the Time dimension table
*/

Use BikeSalesDWMinions

DECLARE @StartDate DATETIME = '20160101' --Starting value of Date Range
DECLARE @EndDate DATETIME = '20221231' --End Value of Date Range

DECLARE @curDate DATE
DECLARE @FirstDayMonth DATE
DECLARE @QtrMonthNo int
DECLARE @FirstDayQtr DATE

SET @curdate = @StartDate
while @curDate < @EndDate 
  Begin
		   
    SET @FirstDayMonth = DateFromParts(Year(@curDate), Month(@curDate), '01')
	SET @QtrMonthNo = ((DatePart(Quarter, @CurDate) - 1) * 3) + 1 
    Set @FirstDayQtr = DateFromParts(Year(@curDate), @QtrMonthNo, '01')

	INSERT INTO [Time]
    select 
	  CONVERT (char(8),@curDate,112) as time_key,
	  @CurDate AS Date,
	  CONVERT (char(10), @CurDate,103) as FullDateUK,

	  DATEPART(Day, @curDate) AS DayOfMonth,



	  DATENAME(WeekDay, @curDate) AS DayName,

	

	  


	  DatePart(Month, @curDate) AS Month,
	  Datename(Month, @curDate) AS MonthName,

	  DatePart(Quarter, @curDate) as Quarter,
	  CASE DatePart(Quarter, @curDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
	  END AS QuarterName,
	  DatePart(Year, @curDate) as Year,


	  CASE
		WHEN DATEPART(WeekDay, @curDate) in (1, 7) THEN 0
		WHEN DATEPART(WeekDay, @curDate) in (2, 3, 4, 5, 6) THEN 1
	  END as IsWeekDay
   	
		
    /* Increate @curDate by 1 day */
	SET @curDate = DateAdd(Day, 1, @curDate)
  End


