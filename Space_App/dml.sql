--Задание: 1 (Serge I: 2004-09-08)
--Добавить в таблицу PC следующую модель:
--code: 20
--model: 2111
--speed: 950
--ram: 512
--hd: 60
--cd: 52x
--price: 1100

insert into PC values
(20,2111,950,512,60,'52x',1100)


--Задание: 2 (Serge I: 2004-09-08)
--Добавить в таблицу Product следующие продукты производителя Z:
--принтер модели 4003, ПК модели 4001 и блокнот модели 4002

insert into Product values
('Z',4003,'Printer'),
('Z',4001,'PC'),
('Z',4002,'Laptop')

--Задание: 3 (Serge I: 2004-09-08)
--Добавить в таблицу PC модель 4444 с кодом 22, имеющую скорость процессора 1200 и цену 1350.

--Отсутствующие характеристики должны быть восполнены значениями по умолчанию, принятыми для соответствующих столбцов.

insert into PC(code,model,speed,price) values
(22,4444,1200,1350)

--Задание: 4 (Serge I: 2004-09-08)
--Для каждой группы блокнотов с одинаковым номером модели добавить запись в таблицу PC со следующими характеристиками:
--код: минимальный код блокнота в группе +20;
--модель: номер модели блокнота +1000;
--скорость: максимальная скорость блокнота в группе;
--ram: максимальный объем ram блокнота в группе *2;
--hd: максимальный объем hd блокнота в группе *2;
--cd: значение по умолчанию;
--цена: максимальная цена блокнота в группе, уменьшенная в 1,5 раза.
--Замечание. Считать номер модели числом.

insert into pc(code,model,speed,ram,hd,price)

select
min(code)+20,
model+1000,
max(speed),
max(ram)*2,
max(hd)*2,
max(price)/1.5
from Laptop
group by model



--5
--Удалить из таблицы PC компьютеры, имеющие минимальный объем диска или памяти.

delete from PC
where 
hd = (select min(hd) from PC)
or
ram = (select min(ram) from PC)


--6
--Удалить все блокноты, выпускаемые производителями, которые не выпускают принтеры.

delete  from Laptop
where model not in

(select model from Product
where maker in 
(select maker from Product where type='printer')
)


--7
--Производство принтеров производитель A передал производителю Z. Выполнить соответствующее изменение.

update Product
set maker='Z' where maker='A' and type='Printer'



--8
--Удалите из таблицы Ships все корабли, потопленные в сражениях.

delete from Ships
where name in
(
select ship from Outcomes
where result='sunk')


--9
--Измените данные в таблице Classes так, чтобы калибры орудий измерялись в
--сантиметрах (1 дюйм=2,5см), а водоизмещение в метрических тоннах (1
--метрическая тонна = 1,1 тонны). Водоизмещение вычислить с точностью до
--целых.

update Classes
set bore = bore*2.5,
displacement = round((displacement/1.1),0)



--Задание: 10 (Serge I: 2004-09-09)
--Добавить в таблицу PC те модели ПК из Product, которые отсутствуют в таблице PC.

--При этом модели должны иметь следующие характеристики:

--1. Код равен номеру модели плюс максимальный код, который был до вставки.

--2. Скорость, объем памяти и диска, а также скорость CD должны иметь максимальные характеристики среди всех имеющихся в таблице PC.

--3. Цена должна быть средней среди всех ПК, имевшихся в таблице PC до вставки.

insert into PC
select (select max(code) from PC)+model as code,model,
 (select max(speed) from PC) as speed,
       (select max(ram) from PC) as ram, 
(select max(hd) from PC) as hd,
CAST((SELECT MAX(CAST (SUBSTRING(cd,1,LEN(cd) - 1) AS int)) FROM PC) AS VARCHAR) + 'x' AS cd,
(select AVG(price) from PC ) as price
   from Product
where type='PC' and model not in (select model from pc)


--Задание: 11 (Serge I: 2004-09-09)
--Для каждой группы блокнотов с одинаковым номером модели добавить запись в таблицу PC со следующими характеристиками:
--код: минимальный код блокнота в группе +20;
--модель: номер модели блокнота +1000;
--скорость: максимальная скорость блокнота в группе;
--ram: максимальный объем ram блокнота в группе *2;
--hd: максимальный объем hd блокнота в группе *2;
--cd: cd c максимальной скоростью среди всех ПК;
--цена: максимальная цена блокнота в группе, уменьшенная в 1,5 раза

insert into PC
select 
min(code)+20,
cast(model as int)+1000  as model,
max(speed) as speed,
max(ram)*2 as ram,
max(hd)*2 as hd,
cast((select max(cast(substring(cd,1,len(cd)-1) as int) )  from PC) as varchar)+'x' as cd,
max(price)/1.5 as price
from Laptop
group by model


--Задание: 12 (Serge I: 2004-09-09)
--Добавьте один дюйм к размеру экрана каждого блокнота,
--выпущенного производителями E и B, и уменьшите его цену на $100.

update Laptop
set screen = screen+1,price = price-100
where model in
(select model from Product
where maker ='E' or maker='B' and type='Laptop')


--Задание: 13 (Serge I: 2004-09-09)
--Ввести в базу данных информацию о том, что корабль Rodney был потоплен в битве, произошедшей 25/10/1944, а корабль Nelson поврежден - 28/01/1945.
--Замечание: считать, что дата битвы уникальна в таблице Battles.

insert into Outcomes
select 
'Rodney' as ship,(select  name from Battles
where date = '1944-10-25') as battle,
'sunk' as result
union
select
  'Nelson' as ship, 
(select  name from Battles
where date='1945-01-28'),
'damaged' as result


--14
--Удалите классы, имеющие в базе данных менее трех кораблей (учесть корабли из Outcomes).

delete from  Classes
where class in
(select Classes.class from
(
select name,class from Ships
union
select ship,ship from Outcomes
) as s
right join Classes on Classes.class = s.class
group by Classes.class
having count(s.name)<3
)


--Задание: 15 (Serge I: 2009-06-05)
--Из каждой группы ПК с одинаковым номером модели в таблице PC удалить все строки кроме строки с наибольшим для этой группы кодом (столбец code).

delete from PC
where code not in
(select max(code) from PC
group by model)


--Задание: 16 (Serge I: 2004-09-09)
--Удалить из таблицы Product те модели, которые отсутствуют в других таблицах.

delete from Product
where model not in
(
select model from PC
union
select model from Laptop
union
select model from Printer
)


--Задание: 17 (Serge I: 2017-04-14)
--Удалить из таблицы PC компьютеры, у которых величина hd попадает в тройку наименьших значений.

delete from PC
where hd  in
(
select top 3 min(hd) from PC
group by hd
order by hd
)


--Задание: 18 (Serge I: 2015-12-21)
--Перенести все концевые пробелы, имеющиеся в названии каждого сражения в таблице Battles, в начало названия.


UPDATE Battles
SET name = REPLACE(name, rtrim(name), '')+rtrim(name)

