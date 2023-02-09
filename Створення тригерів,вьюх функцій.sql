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
		
		UPDATE [VisitCountryCity]
		SET [tourArchiveId] = @ID
		WHERE [tourId] IS NULL;

		UPDATE [MemorablePlaces]
		SET [tourArchiveId] = @ID
		WHERE [tourId] IS NULL;

		UPDATE [TourHotel]
		SET [tourArchiveId] = @ID
		WHERE [tourId] IS NULL;

		UPDATE [LastTourList]
		SET [tourArchiveId] = @ID
		WHERE [tourId] IS NULL;

		UPDATE [CustomerTourPayedList]
		SET [tourArchiveId] = @ID
		WHERE [tourId] IS NULL;

		UPDATE [TransportModeList]
		SET [tourArchiveId] = @ID
		WHERE [tourId] IS NULL;
	END
GO
-------------------------END-------------------------
-----------------------Перевірка роботи--------------

--- Переглянемо тури до змін (25 записів)
SELECT *
FROM [Tour]

--переміщення Турів які скінчились до АРХІВУ ТУРІВ
DELETE 
FROM [Tour]
WHERE [Tour].[finishDate] < GETDATE()

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


