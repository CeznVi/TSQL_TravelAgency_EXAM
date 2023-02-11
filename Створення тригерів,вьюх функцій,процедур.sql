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
SET [startDate] = GETDATE() - 1
WHERE [id] = 30;

--Подивимось конкретного туриста Покупець3 Турів3 Покупуйченко3
SELECT * 
FROM [dbo].GetInformationByTouristOnTourNow('%Покупець3 Турів3 Покупуйченко3%')

--ПОВЕРНЕМО назад зміни
UPDATE [Tour]
SET [startDate] = '2023-04-04'
WHERE [id] = 30;
--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* Відобразити інформацію про найактивнішого туриста (за кількістю придбаних турів) */
---------------------ВЬЮХА-----------------------
GO
CREATE VIEW [vTopCustomerByByedTour]
AS
		SELECT TOP(1)
			[C].[firstName] + SPACE(1) + [C].[surName] + SPACE(1) + [C].[lastName] AS 'ПІБ, найактивнішого туриста',
			[TEMP].[HowMany] AS 'Кількість придбаних турів',
			[C].[birthDay] AS 'Дата народження',
			[C].[email] AS 'Електрона пошта',
			[CC].[code] + SPACE(1) + [N].[number] AS 'Телефонний номер'
		FROM (	SELECT 
					[CTPL].[customerId] AS 'customerId',
					COUNT([CTPL].[id]) AS 'HowMany'
				FROM [CustomerTourPayedList] AS [CTPL] 
				GROUP BY [customerId]) AS [TEMP] JOIN [Customers] AS [C] ON [TEMP].[customerId] = [C].[id]
			JOIN [Telephone] AS [T] ON [T].[id] = [C].[telephoneId] 
			JOIN [CountryCode] AS [CC] ON [CC].[id] = [T].[countryCodeId]
			JOIN [Number] AS [N] ON [N].[id] = [T].[numberId]
		ORDER BY [TEMP].[HowMany] DESC
GO
-------------------------END-------------------------

-----------------------Перевірка роботи--------------
SELECT * 
FROM [vTopCustomerByByedTour]
--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* Відобразити інформацію про найпопулярніший готель серед туристів (за кількістю туристів) */
---------------------ВЬЮХА-----------------------
GO
CREATE VIEW [vTopHotelByByedTour]
AS
		SELECT TOP(1) 
				[H].[name] AS 'Назва найпопулярнішого готелю',
				[TEMP].[byeCount] AS 'Кількість побувавших туристів',
				[H].[description] AS 'Опис',
				[H].[starCount] AS 'Кількість зірок',
				[CC].[code] + SPACE(1) + [N].[number] AS 'Телефонний номер',
				[C].[countryName] + ', ' + [Ci].[cityName] AS 'Місце знаходження'
		FROM (
				SELECT 
						[TH].[hotelId] AS 'hotelId',
						[CTPL].[HwMany] AS 'byeCount'
					FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
											FROM [CustomerTourPayedList]
											GROUP BY [tourId]) AS [CTPL] 
						ON [T].[id] = [CTPL].[tourId]
						JOIN [TourHotel] AS [TH] ON [TH].[tourId] = [T].[id]
			
				UNION ALL
				SELECT
						[TH].[hotelId] AS 'hotelId',
						[CTPL].[HwMany]
					FROM [TourArhive] AS [TA] JOIN (SELECT [tourArchiveId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
											FROM [CustomerTourPayedList]
											GROUP BY [tourArchiveId]) AS [CTPL] 
						ON [TA].[id] = [CTPL].[tourId]
						JOIN [TourHotel] AS [TH] ON [TH].[tourArchiveId] = [TA].[id]
			) AS [TEMP] JOIN [Hotel] AS [H] ON [H].[id] = [TEMP].[hotelId]
			JOIN [Telephone] AS [T] ON [T].[id] = [H].[telephoneId] 
			JOIN [CountryCode] AS [CC] ON [CC].[id] = [T].[countryCodeId]
			JOIN [Number] AS [N] ON [N].[id] = [T].[numberId]
			JOIN [Country] AS [C] ON [C].[id] = [H].[countryId]
			JOIN [City] AS [Ci] ON [Ci].[id] = [H].[cityId]
			ORDER BY [byeCount] DESC
GO
-------------------------END-------------------------

-----------------------Перевірка роботи--------------
SELECT * 
FROM [vTopHotelByByedTour]
--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* Відобразити інформацію про всі тури вказаного способу пересування. Спосіб пересування передається як параметр */
---------------------ФУНКЦІЯ-----------------------
GO
CREATE FUNCTION [dbo].GetInformationByTourByTypeTransport(@TypeTransport nvarchar(50))
RETURNS TABLE
AS
	RETURN (
		   SELECT 
				[T].[name] AS 'Назва туру',
				[T].[price] AS 'Вартість',
				[T].[startDate] AS 'Дата почачтку',
				[T].[finishDate] AS 'Дата закінчення',
				[TC].[Countrys] AS 'Відвідуємі країни',
				[TML].[TypeOfTrans] AS 'Способи пересування у турі',
				[T].[maxTouristCount] AS 'Максимальна кількість туристів',
				[CTPL].[HwMany] AS 'Кількість придбаних турів'
			FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
									FROM [CustomerTourPayedList]
									GROUP BY [tourId]) AS [CTPL] ON [T].[id] = [CTPL].[tourId]
				JOIN (SELECT
							[VCC].[tourId] AS 'tourId',
							STRING_AGG(CONVERT(nvarchar(MAX), [Ctry].[countryName]), ', ') AS 'Countrys'
						FROM (SELECT DISTINCT [VisitCountryCity].[countryId] AS 'CountryID', [VisitCountryCity].[tourId] AS 'tourId'
								FROM [VisitCountryCity]) AS [VCC] JOIN [Country] AS [Ctry] ON [VCC].[countryId] = [Ctry].[id]
						GROUP BY [VCC].[tourId]) AS [TC]
					ON [T].[id] = [TC].[tourId]
				JOIN (SELECT
							[TML].[tourId] AS 'tourId',
							STRING_AGG(CONVERT(nvarchar(MAX), [Trans].[typeOfTransport]), ', ') AS 'TypeOfTrans'
						FROM (SELECT DISTINCT [TransportModeList].[transportId] AS 'transportID', 
											  [TransportModeList].[tourId] AS 'tourId'
							  FROM [TransportModeList]) AS [TML] JOIN [Transport] AS [Trans] ON [TML].[transportID] = [Trans].[id]
						GROUP BY [TML].[tourId]) AS [TML] ON [TML].[tourId] = [T].[id]
			WHERE [TML].[TypeOfTrans] LIKE @TypeTransport
		UNION ALL
		SELECT 
				[T].[name],
				[T].[price],
				[T].[startDate],
				[T].[finishDate],
				[TC].[Countrys],
				[TML].[TypeOfTrans],
				[T].[maxTouristCount],
				[CTPL].[HwMany]
			FROM [TourArhive] AS [T] JOIN (SELECT [tourArchiveId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
									FROM [CustomerTourPayedList]
									GROUP BY [tourArchiveId]) AS [CTPL] ON [T].[id] = [CTPL].[tourId]
				JOIN (SELECT
							[VCC].[tourId] AS 'tourId',
							STRING_AGG(CONVERT(nvarchar(MAX), [Ctry].[countryName]), ', ') AS 'Countrys'
						FROM (SELECT DISTINCT [VisitCountryCity].[countryId] AS 'CountryID', [VisitCountryCity].[tourArchiveId] AS 'tourId'
								FROM [VisitCountryCity]) AS [VCC] JOIN [Country] AS [Ctry] ON [VCC].[countryId] = [Ctry].[id]
						GROUP BY [VCC].[tourId]) AS [TC]
					ON [T].[id] = [TC].[tourId]
				JOIN (SELECT
							[TML].[tourId] AS 'tourId',
							STRING_AGG(CONVERT(nvarchar(MAX), [Trans].[typeOfTransport]), ', ') AS 'TypeOfTrans'
						FROM (SELECT DISTINCT [TransportModeList].[transportId] AS 'transportID', 
											  [TransportModeList].[tourArchiveId] AS 'tourId'
							  FROM [TransportModeList]) AS [TML] JOIN [Transport] AS [Trans] ON [TML].[transportID] = [Trans].[id]
						GROUP BY [TML].[tourId]) AS [TML] ON [TML].[tourId] = [T].[id]
			WHERE [TML].[TypeOfTrans] LIKE @TypeTransport
			)
GO
-------------------------END-------------------------
-----------------------Перевірка роботи--------------
---Переглянемо тури у яких тільки піший спосіб пересування
SELECT *
FROM [dbo].GetInformationByTourByTypeTransport('піший')
---Подивимось тури у яких піший спосіб пересування та інші способи
SELECT *
FROM [dbo].GetInformationByTourByTypeTransport('%піший%')
---Подивимось тури у яких тільки катер спосіб пересування 
SELECT *
FROM [dbo].GetInformationByTourByTypeTransport('катер')
---Подивимось тури у яких тільки автобус спосіб пересування 
SELECT *
FROM [dbo].GetInformationByTourByTypeTransport('автобус')
--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* При вставці нового клієнта необхідно перевіряти, чи немає його вже в базі даних. 
Якщо такий клієнт є, генерувати помилку з описом проблеми, що виникла */
---------------------ТРИГЕР-----------------------
GO
CREATE TRIGGER CheckNewCustomers
ON [Customers]
INSTEAD OF INSERT 
AS
	BEGIN
		DECLARE @InsertFName nvarchar(50)
		DECLARE @InsertSName nvarchar(50)
		DECLARE @InsertLName nvarchar(50)
		DECLARE @InsertBday Date
		DECLARE @InsertTId int

	SELECT 
		@InsertFName = [inserted].[firstName],
		@InsertSName = [inserted].[surName],
		@InsertLName = [inserted].[lastName],
		@InsertTId = [inserted].[telephoneId],
		@InsertBday = [inserted].[birthDay]
	FROM [inserted]

		IF (EXISTS (SELECT * 
					FROM [Customers] AS [C]
					WHERE [C].[firstName] = @InsertFName
						  AND [C].[surName] = @InsertSName
						  AND [C].[lastName] = @InsertLName
						  AND [C].[birthDay] = @InsertBday
						  AND [C].[telephoneId] = @InsertTId))
			BEGIN
				RAISERROR('Такий клієнт уже є в базі!',0,1)
				ROLLBACK TRANSACTION
			END
		ELSE
			BEGIN

				INSERT INTO [Customers] ([firstName],[surName],[lastName],[email],[telephoneId],[birthDay])
				SELECT [firstName], [surName], [lastName], [email], [telephoneId], [birthDay]
				FROM [inserted]
				
				PRINT ('Кліента успішно додано')
			END
	END
-------------------------END-------------------------
-----------------------Перевірка роботи--------------
---Виведемо всіх кліентів тур агенства
SELECT * FROM [Customers]

-----Спробуємо додати кліента(КЛОНА) який уже точно е в базі(буде помилка так як поле EMAIL унікальний ключ)

INSERT [Customers] ([firstName], [surName], [lastName], [email], [telephoneId], [birthDay]) 
VALUES (N'Цікавиться', N'Турами', N'Некупуйченко', N'n1@g.com', 19, CAST(N'1980-01-01' AS Date))

-----Змінемо клону ЕМАЙЛ і спробуємо додати (Спойлер-- не вийде, трігер спрацює)

INSERT [Customers] ([firstName], [surName], [lastName], [email], [telephoneId], [birthDay]) 
VALUES (N'Цікавиться', N'Турами', N'Некупуйченко', N'n1777@g.com', 19, CAST(N'1980-01-01' AS Date))

---Для тесту сробуємо додати не клона (Спойлер -- буде успішно додано)
INSERT [Customers] ([firstName], [surName], [lastName], [email], [telephoneId], [birthDay]) 
VALUES (N'Цік', N'Тур', N'Некуп', N'n177787@g.com', 19, CAST(N'1988-01-01' AS Date))

---Подивимось результати додавання
SELECT * 
FROM [Customers]
ORDER BY [id] DESC

--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* При додаванні нового туриста в тур перевіряти чи не досягнуто вже максимальної кількості. 
Якщо максимальна кількість досягнуто, генерувати помилку з інформацією про проблему */
---------------------ТРИГЕР-----------------------
GO
CREATE TRIGGER CheckOverflowTour
ON [CustomerTourPayedList]
INSTEAD OF INSERT 
AS
	BEGIN
		DECLARE @tourID int

	SELECT 
		@tourID = [inserted].[tourId]
	FROM [inserted]


	DECLARE @FreePlaces int
	SET @FreePlaces = (SELECT 
							[T].[maxTouristCount] - [CTPL].[HwMany]
						FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
													FROM [CustomerTourPayedList]
													GROUP BY [tourId]) AS [CTPL] ON [T].[id] = [CTPL].[tourId]
						WHERE [T].[id] = @tourID)

	IF (@FreePlaces <= 0)
		BEGIN
			RAISERROR('Досягнут ліміт за максимальною кількістю людей у турі!',0,1)
			ROLLBACK TRANSACTION
		END
	ELSE
		BEGIN

			INSERT INTO [CustomerTourPayedList] ([tourId],[customerId])
			SELECT [tourId],[customerId]
			FROM [inserted]
				
			PRINT ('Кліента успішно підписано на тур')
		END
	END
---------------------ВЬЮХА-----------------------
--Для зручності сторемо вьюху яка покаже АйдіТура - ВільнихМісць
GO
CREATE VIEW [vShowFreePlacesInTours]
AS
	SELECT 
		[T].[id] AS 'TourId',
		[T].[maxTouristCount] - [CTPL].[HwMany] AS 'Вільних місць у турі'
	FROM [Tour] AS [T] JOIN (SELECT [tourId] AS 'tourId', COUNT([customerId]) AS 'HwMany'
							  FROM [CustomerTourPayedList]
							  GROUP BY [tourId]) AS [CTPL] ON [T].[id] = [CTPL].[tourId]
GO
-------------------------END-------------------------
-----------------------Перевірка роботи--------------

---Переглянемо тури і вільні місця у них
SELECT * FROM [vShowFreePlacesInTours]

---Переглянемо користувачів
SELECT * FROM [Customers]

---Спроба підписати на архівний тур (СПОЙЛЕР: НЕ вийде так як база так побудована)
INSERT [CustomerTourPayedList] ([tourId],[customerId]) 
VALUES (1,18)

---Спроба підписати на переповнений тур
INSERT [CustomerTourPayedList] ([tourId],[customerId]) 
VALUES (12,18)

---Спроба підписати на тур у якому є вільне місці і який не є архівним
INSERT [CustomerTourPayedList] ([tourId],[customerId]) 
VALUES (15,18)

--------------------****************************Кінець перевірки****************************----------------------

----************************************************************************************************************************
/* ■ Відобразити інформацію про те, де знаходиться конкретний турист з ПІБ. Якщо турист не в турі згенерувати помилку 
з описом проблеми, що виникла. ПІБ туриста передається як параметр; */
GO
CREATE PROCEDURE WhereIsTouristByPIB
@PIB nvarchar(155)
	AS
		IF(EXISTS (SELECT [C].[PIB]
					FROM
						(SELECT 
							[C].[firstName] + SPACE(1) + [C].[surName] + SPACE(1) + [C].[lastName] AS 'PIB'
						FROM 
							[Customers] AS [C]) AS [C]
					WHERE 
						[C].[PIB] = @PIB))
			BEGIN
					IF(EXISTS(SELECT * 
								FROM [dbo].GetInformationByTouristOnTourNow(@PIB)))
						BEGIN
							RAISERROR('ТУРИСТ У ТУРІ',0,1)
						END
					ELSE
						BEGIN
							RAISERROR('Наразі турист не перебуває у турі',0,1)
						END
			END
		ELSE
			BEGIN
				RAISERROR('Данних не знайдено, так як людина не є кліентом турагенства',0,1)
			END
	GO
-------------------------END-------------------------
-----------------------Перевірка роботи--------------
----користувач не кліент

EXEC WhereIsTouristByPIB 'Ціавит Тура Неупченко'

----користувач не в турі
EXEC WhereIsTouristByPIB 'Покупець5 Турів5 Покупайченко5'

---Показати інформацію про туриста який знаходиться у турі
---Але потрібно дещо змінити, щоб данні вивелись на екран

UPDATE [Tour] SET [startDate] = GETDATE() - 1 WHERE [id] = 30;



--Подивимось конкретного туриста Покупець3 Турів3 Покупуйченко3
SELECT * 
FROM [dbo].GetInformationByTouristOnTourNow('%Покупець3 Турів3 Покупуйченко3%')

--ПОВЕРНЕМО назад зміни
UPDATE [Tour]
SET [startDate] = '2023-04-04'
WHERE [id] = 30;

----вивести де користувач (країна, місто, готель)






		   
-------------------------END-------------------------
-----------------------Перевірка роботи--------------
