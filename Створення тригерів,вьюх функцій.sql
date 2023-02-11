USE	TravelAgency
GO

--************************************************************************************************************************
/* При видаленні минулих турів необхідно переносити їх до архіву турів;*/
---------------------ТРИГЕР-----------------------
CREATE TRIGGER MoveDeletedToArhive
ON [Tour]
FOR DELETE 
AS
	BEGIN

		declare @ID int

		SELECT @ID = [id]
		FROM deleted

		INSERT INTO [TourArhive] ([id], [name], [price], [startDate], [finishDate], [responsibleWorkerId], [maxTouristCount])
		SELECT [id], [name], [price], [startDate], [finishDate], [responsibleWorkerId], [maxTouristCount]
		FROM deleted
		PRINT ('Тур успішно переміщено у таблицю TourArhive')
	END
GO
---------------------ПРОЦЕДУРА-----------------------
GO
CREATE PROCEDURE DeleteNotActualTour
AS
	BEGIN
		DECLARE @Count int
		DECLARE @EndCount int
		DECLARE @date date
		SET @date = GETDATE()
		SET @Count = 1;
		SET @EndCount = (SELECT TOP(1) [Tour].[id]
							FROM [Tour]
							ORDER BY [Tour].[id] DESC)
		WHILE @Count < @EndCount
			BEGIN
				IF(@date > (SELECT [Tour].[finishDate]
								FROM [Tour]
								WHERE [Tour].[id] = @Count))
					BEGIN
						DELETE FROM [Tour] WHERE [Tour].[id] = @Count
				
						UPDATE [VisitCountryCity]
						SET [tourArchiveId] = @Count
						WHERE [tourId] IS NULL AND [tourArchiveId] IS NULL;

						UPDATE [MemorablePlaces]
						SET [tourArchiveId] = @Count
						WHERE [tourId] IS NULL AND [tourArchiveId] IS NULL;

						UPDATE [TourHotel]
						SET [tourArchiveId] = @Count
						WHERE [tourId] IS NULL AND [tourArchiveId] IS NULL;

						UPDATE [LastTourList]
						SET [tourArchiveId] = @Count
						WHERE [tourId] IS NULL AND [tourArchiveId] IS NULL;

						UPDATE [CustomerTourPayedList]
						SET [tourArchiveId] = @Count
						WHERE [tourId] IS NULL AND [tourArchiveId] IS NULL;

						UPDATE [TransportModeList]
						SET [tourArchiveId] = @Count
						WHERE [tourId] IS NULL AND [tourArchiveId] IS NULL;

					END
			SET @Count = @Count + 1
			END;

	PRINT ('Не актуальні тури було переміщенно до Архівних Турів')
	END
GO
-------------------------END-------------------------
-----------------------Перевірка роботи--------------

--- Переглянемо тури до змін (25 записів)
SELECT *
FROM [Tour]

--переміщення Турів які скінчились до АРХІВУ ТУРІВ
EXEC DeleteNotActualTour

--- Переглянемо тури після змін
SELECT *
FROM [Tour]

--- Переглянемо Архівні тури після змін
SELECT *
FROM [TourArhive]
--------------------****************************Кінець перевірки****************************----------------------


----************************************************************************************************************************
/* Надайте інформацію про всі актуальні тури; */
---------------------ВЬЮХА-----------------------
GO
CREATE VIEW [vAllActualTour]
AS
	SELECT 
		[T].[name] AS 'Назва туру',
		[T].[price] AS 'Вартість',
		[T].[startDate] AS 'Дата почачтку',
		[T].[finishDate] AS 'Дата закінчення',
		[T].[maxTouristCount] AS 'Ємність туру (людей)',
		[T].[maxTouristCount] - [CTPL].[HwMany] AS 'Кількість вільних місць у турі',
		[W].[firstName] + ' ' + [W].[surName] + ' ' + [W].[lastName] AS 'Менеджер туру',
		[CC].[code] + ' ' + [Num].[number] AS 'Телефон менеджера'
	FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
							FROM [CustomerTourPayedList]
							GROUP BY [tourId]) AS [CTPL] 
		ON [T].[id] = [CTPL].[tourId]
		JOIN [Worker] AS [W] ON [W].[id] = [T].[responsibleWorkerId]
		JOIN [Telephone] AS [Tel] ON [W].[telephoneId] = [Tel].[id]
		JOIN [CountryCode] AS [CC] ON [Tel].[countryCodeId] = [CC].[id]
		JOIN [Number] AS [Num] ON [Tel].[numberId] = [Num].[id]
	WHERE [T].[startDate] > GETDATE()
	AND [T].[maxTouristCount] - [CTPL].[HwMany] > 0
GO
-------------------------END-------------------------
-----------------------Перевірка роботи--------------

-- Подивимся результат роботи вьюхи (виведуться всі актуальні тури (дата початку тура > дату зараз; І тури у яких є вільні місця))
SELECT * 
FROM [vAllActualTour]
ORDER BY [Дата почачтку]
--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* Відобразіть інформацію про всі тури, які стартують у діапазоні дат. Діапазон дат передається як параметр */
---------------------ФУНКЦІЯ-----------------------
GO
CREATE FUNCTION [dbo].GetInformationTourByDates(@startDate date, @finishDate date)
RETURNS TABLE
AS
	RETURN (
		SELECT 
				[T].[name] AS 'Назва туру',
				[T].[price] AS 'Вартість',
				[T].[startDate] AS 'Дата почачтку',
				[T].[finishDate] AS 'Дата закінчення',
				[T].[maxTouristCount] AS 'Ємність туру (людей)',
				[T].[maxTouristCount] - [CTPL].[HwMany] AS 'Кількість вільних місць у турі',
				[W].[firstName] + ' ' + [W].[surName] + ' ' + [W].[lastName] AS 'Менеджер туру',
				[CC].[code] + ' ' + [Num].[number] AS 'Телефон менеджера'
			FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
									FROM [CustomerTourPayedList]
									GROUP BY [tourId]) AS [CTPL] 
				ON [T].[id] = [CTPL].[tourId]
				JOIN [Worker] AS [W] ON [W].[id] = [T].[responsibleWorkerId]
				JOIN [Telephone] AS [Tel] ON [W].[telephoneId] = [Tel].[id]
				JOIN [CountryCode] AS [CC] ON [Tel].[countryCodeId] = [CC].[id]
				JOIN [Number] AS [Num] ON [Tel].[numberId] = [Num].[id]
			WHERE [T].[startDate] BETWEEN @startDate AND @finishDate
			AND [T].[maxTouristCount] - [CTPL].[HwMany] > 0
			)
GO

-------------------------END-------------------------
-----------------------Перевірка роботи--------------
-- Подивимся результат роботи функції (виведуться всі актуальні тури (які у діапазоні дат; І тури у яких є вільні місця))

SELECT * 
FROM [dbo].GetInformationTourByDates('2023-03-05', '2023-04-04')
ORDER BY [Дата почачтку]

--- Спробуємо по іншому внести дати
SELECT * 
FROM [dbo].GetInformationTourByDates('230305', '230404')
ORDER BY [Дата почачтку]

--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* Відобразіть інформацію про всі тури, які відвідають вказану країну. Країна передається як параметр; */
---------------------ФУНКЦІЯ-----------------------

GO
CREATE FUNCTION [dbo].GetInformationTourByCountry(@countryName nvarchar(50))
RETURNS TABLE
AS
	RETURN (
		SELECT 
				[T].[name] AS 'Назва туру',
				[T].[price] AS 'Вартість',
				[T].[startDate] AS 'Дата почачтку',
				[T].[finishDate] AS 'Дата закінчення',
				[T].[maxTouristCount] AS 'Ємність туру (людей)',
				[T].[maxTouristCount] - [CTPL].[HwMany] AS 'Кількість вільних місць у турі',
				[W].[firstName] + ' ' + [W].[surName] + ' ' + [W].[lastName] AS 'Менеджер туру',
				[CC].[code] + ' ' + [Num].[number] AS 'Телефон менеджера',
				[TC].[Countrys] AS 'Відвідуємі країни'
			FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
									FROM [CustomerTourPayedList]
									GROUP BY [tourId]) AS [CTPL] 
				ON [T].[id] = [CTPL].[tourId]
				JOIN [Worker] AS [W] ON [W].[id] = [T].[responsibleWorkerId]
				JOIN [Telephone] AS [Tel] ON [W].[telephoneId] = [Tel].[id]
				JOIN [CountryCode] AS [CC] ON [Tel].[countryCodeId] = [CC].[id]
				JOIN [Number] AS [Num] ON [Tel].[numberId] = [Num].[id]
				JOIN (SELECT
							[VCC].[tourId] AS 'tourId',
							STRING_AGG(CONVERT(nvarchar(MAX), [Ctry].[countryName]), ', ') AS 'Countrys'
						FROM (SELECT DISTINCT [VisitCountryCity].[countryId] AS 'CountryID', [VisitCountryCity].[tourId] AS 'tourId'
								FROM [VisitCountryCity]) AS [VCC] JOIN [Country] AS [Ctry] ON [VCC].[countryId] = [Ctry].[id]
						GROUP BY [VCC].[tourId]) AS [TC]
					ON [T].[id] = [TC].[tourId]
			WHERE [TC].[Countrys] LIKE @countryName
			
			)
GO

-------------------------END-------------------------
-----------------------Перевірка роботи--------------
-- Подивимся результат роботи функції (виведуться всі тури, які відвідують передану країну)
SELECT * 
FROM [dbo].GetInformationTourByCountry('%Франція%')
ORDER BY [Дата почачтку]

-- Перевірємо також і тури по Україні
SELECT * 
FROM [dbo].GetInformationTourByCountry('%Україна%')
ORDER BY [Дата почачтку]

--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* Відобразіть найпопулярнішу туристичну країну (за найбільшою кількістю турів з урахуванням архівних); */
---------------------ВЬЮХА-----------------------
GO
CREATE VIEW [vTopCountryAmongTourAndArhiveTour]
AS
	SELECT TOP(1)
		[Назва країни] AS 'Найпопулярніша країна (за найбільшою кількістю турів з урах. архівних)',
		SUM([Кількість турів]) AS 'Сумарна кількість турів'
	FROM
		(SELECT
			[Country].[countryName] AS 'Назва країни',
			COUNT([T].[id]) AS 'Кількість турів'
		FROM [Tour] AS [T] JOIN [VisitCountryCity] AS [VCC] ON [T].[id] = [VCC].[tourId]
			 JOIN [Country] ON [VCC].[countryId] = [Country].[id]
		GROUP BY [countryName], [T].[id]
		UNION ALL
		SELECT
			[Country].[countryName] AS 'Назва країни',
			COUNT([TA].[id]) AS 'Кількість турів'
		FROM [TourArhive] AS [TA] JOIN [VisitCountryCity] AS [VCC] ON [TA].[id] = [VCC].[tourArchiveId]
			 JOIN [Country] ON [VCC].[countryId] = [Country].[id]
		GROUP BY [countryName], [TA].[id]) AS [Temp]
	GROUP BY [Назва країни]
	ORDER BY [Сумарна кількість турів] DESC

GO

-------------------------END-------------------------
-----------------------Перевірка роботи--------------
SELECT * 
FROM [vTopCountryAmongTourAndArhiveTour]

--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* Показати найпопулярніший актуальний тур (за максимальною кількістю куплених туристичних путівок) */
---------------------ВЬЮХА-----------------------
GO
CREATE VIEW [vTopTourByByedTickets]
AS
		SELECT TOP(1)
				[T].[name] AS 'Назва туру',
				[T].[price] AS 'Вартість',
				[T].[startDate] AS 'Дата почачтку',
				[T].[finishDate] AS 'Дата закінчення',
				[T].[maxTouristCount] AS 'Ємність туру (людей)',
				[CTPL].[HwMany] AS 'Кількість куплених турів'
			FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
									FROM [CustomerTourPayedList]
									GROUP BY [tourId]) AS [CTPL] 
				ON [T].[id] = [CTPL].[tourId]
			ORDER BY [CTPL].[HwMany] DESC
GO
-------------------------END-------------------------

-----------------------Перевірка роботи--------------
SELECT * 
FROM [vTopTourByByedTickets]
--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* Показати найпопулярніший архівний тур (за максимальною кількістю куплених туристичних путівок); */
---------------------ВЬЮХА-----------------------
GO
CREATE VIEW [vTopArhiveTourByByedTickets]
AS
		SELECT TOP(1)
				[TA].[name] AS 'Назва туру',
				[TA].[price] AS 'Вартість',
				[TA].[startDate] AS 'Дата почачтку',
				[TA].[finishDate] AS 'Дата закінчення',
				[TA].[maxTouristCount] AS 'Ємність туру (людей)',
				[CTPL].[HwMany] AS 'Кількість куплених турів'
			FROM [TourArhive] AS [TA] JOIN (SELECT [tourArchiveId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
									FROM [CustomerTourPayedList]
									GROUP BY [tourArchiveId]) AS [CTPL] 
				ON [TA].[id] = [CTPL].[tourId]
			ORDER BY [CTPL].[HwMany] DESC
GO
-------------------------END-------------------------

-----------------------Перевірка роботи--------------
SELECT * 
FROM [vTopArhiveTourByByedTickets]
--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/*  Показати найпопулярніший актуальний тур (за мінімальною кількістю куплених туристичних путівок); */
---------------------ВЬЮХА-----------------------
GO
CREATE VIEW [vTopTourByMinByedTickets]
AS
		SELECT TOP(1)
				[T].[name] AS 'Назва туру',
				[T].[price] AS 'Вартість',
				[T].[startDate] AS 'Дата почачтку',
				[T].[finishDate] AS 'Дата закінчення',
				[T].[maxTouristCount] AS 'Ємність туру (людей)',
				[CTPL].[HwMany] AS 'Кількість куплених турів'
			FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
									FROM [CustomerTourPayedList]
									GROUP BY [tourId]) AS [CTPL] 
				ON [T].[id] = [CTPL].[tourId]
			ORDER BY [CTPL].[HwMany] 
GO
-------------------------END-------------------------

-----------------------Перевірка роботи--------------
SELECT * 
FROM [vTopTourByMinByedTickets]
--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/*  Показати для конкретного туриста по ПІБ список усіх його турів. ПІБ туриста передається як параметр; */
---------------------ФУНКЦІЯ-----------------------
GO
CREATE FUNCTION [dbo].GetInformationByTouristByByedTour(@PIB nvarchar(155))
RETURNS TABLE
AS
	RETURN (
		   SELECT 
				[T].[name] AS 'Назва туру',
				[T].[price] AS 'Вартість',
				[T].[startDate] AS 'Дата почачтку',
				[T].[finishDate] AS 'Дата закінчення',
				[TC].[Countrys] AS 'Відвідуємі країни'
			FROM [Tour] AS [T] JOIN [CustomerTourPayedList] AS [CTPL] ON [T].[id] = [CTPL].[tourId]
				JOIN (SELECT
							[VCC].[tourId] AS 'tourId',
							STRING_AGG(CONVERT(nvarchar(MAX), [Ctry].[countryName]), ', ') AS 'Countrys'
						FROM (SELECT DISTINCT [VisitCountryCity].[countryId] AS 'CountryID', [VisitCountryCity].[tourId] AS 'tourId'
								FROM [VisitCountryCity]) AS [VCC] JOIN [Country] AS [Ctry] ON [VCC].[countryId] = [Ctry].[id]
						GROUP BY [VCC].[tourId]) AS [TC]
					ON [T].[id] = [TC].[tourId]
				 JOIN (SELECT 
						[Customers].[id] AS 'id',
						[Customers].[firstName] + SPACE(1) + [Customers].[surName] + SPACE(1) + [Customers].[lastName] AS 'PIB'
					   FROM [Customers]) AS [C] ON [CTPL].[customerId] = [C].[id]
			WHERE [C].[PIB] LIKE @PIB
		UNION ALL
		SELECT 
				[T].[name] AS 'Назва туру',
				[T].[price] AS 'Вартість',
				[T].[startDate] AS 'Дата почачтку',
				[T].[finishDate] AS 'Дата закінчення',
				[TC].[Countrys] AS 'Відвідуємі країни'
			FROM [TourArhive] AS [T] JOIN [CustomerTourPayedList] AS [CTPL] ON [T].[id] = [CTPL].[tourArchiveId]
				JOIN (SELECT
							[VCC].[tourId] AS 'tourId',
							STRING_AGG(CONVERT(nvarchar(MAX), [Ctry].[countryName]), ', ') AS 'Countrys'
						FROM (SELECT DISTINCT [VisitCountryCity].[countryId] AS 'CountryID', [VisitCountryCity].[tourArchiveId] AS 'tourId'
								FROM [VisitCountryCity]) AS [VCC] JOIN [Country] AS [Ctry] ON [VCC].[countryId] = [Ctry].[id]
						GROUP BY [VCC].[tourId]) AS [TC]
					ON [T].[id] = [TC].[tourId]
				 JOIN (SELECT 
						[Customers].[id] AS 'id',
						[Customers].[firstName] + SPACE(1) + [Customers].[surName] + SPACE(1) + [Customers].[lastName] AS 'PIB'
					   FROM [Customers]) AS [C] ON [CTPL].[customerId] = [C].[id]
			WHERE [C].[PIB] LIKE @PIB
			)
GO
-------------------------END-------------------------

-----------------------Перевірка роботи--------------
--Подивимось всі тури для конкретного туриста Покупець1 Турів1 Покупуйченко1
SELECT * 
FROM [dbo].GetInformationByTouristByByedTour('%Покупець1 Турів1 Покупуйченко1%')
ORDER BY [Дата почачтку]

--Подивимось всі тури для конкретного туриста Покупець1 Турів1 Покупуйченко1
SELECT * 
FROM [dbo].GetInformationByTouristByByedTour('%Покупець3 Турів3 Покупуйченко3%')
ORDER BY [Дата почачтку]
--------------------****************************Кінець перевірки****************************----------------------


----************************************************************************************************************************
/* Перевірити для конкретного туриста по ПІБ чи перебуває він зараз у турі. ПІБ туриста передається як параметр; */
---------------------ФУНКЦІЯ-----------------------
GO
CREATE FUNCTION [dbo].GetInformationByTouristOnTourNow(@PIB nvarchar(155))
RETURNS TABLE
AS
	RETURN (
		   SELECT 
				[T].[name] AS 'Назва туру',
				[T].[price] AS 'Вартість',
				[T].[startDate] AS 'Дата почачтку',
				[T].[finishDate] AS 'Дата закінчення'
			FROM [Tour] AS [T] JOIN [CustomerTourPayedList] AS [CTPL] ON [T].[id] = [CTPL].[tourId]
				 JOIN (SELECT 
						[Customers].[id] AS 'id',
						[Customers].[firstName] + SPACE(1) + [Customers].[surName] + SPACE(1) + [Customers].[lastName] AS 'PIB'
					   FROM [Customers]) AS [C] ON [CTPL].[customerId] = [C].[id]
			WHERE [C].[PIB] LIKE @PIB
				AND GETDATE() >= [T].[startDate] 
				AND GETDATE() <= [T].[finishDate]
				
			)
GO
-------------------------END-------------------------

-----------------------Перевірка роботи--------------
--Трохи змінемо існуюючу базу для перевірки роботи функції
UPDATE [Tour]
SET [startDate] = GETDATE() - 2
WHERE [id] = 30;

--Подивимось конкретного туриста Покупець3 Турів3 Покупуйченко3
SELECT * 
FROM [dbo].GetInformationByTouristOnTourNow('%Покупець3 Турів3 Покупуйченко3%')

--ПОВЕРНЕМО назад зміни
UPDATE [Tour]
SET [startDate] = '2023-04-04'
WHERE [id] = 30;
--------------------****************************Кінець перевірки****************************----------------------










--------------------ПОКА НЕ УДАЛЯТЬ
SELECT *
FROM [Tour]



SELECT
	[VCC].[tourId] AS 'tourId',
	STRING_AGG(CONVERT(nvarchar(MAX), [Ctry].[countryName]), ', ') AS 'Countrys'
FROM (SELECT DISTINCT [VisitCountryCity].[countryId] AS 'CountryID', [VisitCountryCity].[tourId] AS 'tourId'
		FROM [VisitCountryCity]) AS [VCC] JOIN [Country] AS [Ctry] ON [VCC].[countryId] = [Ctry].[id]
GROUP BY [VCC].[tourId]



SELECT 
DISTINCT [VisitCountryCity].[countryId] AS 'CountryID',
[VisitCountryCity].[tourId] AS 'tourId'
FROM [VisitCountryCity]
