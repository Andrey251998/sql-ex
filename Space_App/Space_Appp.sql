--1
--Найдите номер модели, скорость и размер жесткого диска 
--для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
select  model,speed,hd from PC
where price<500
--/2
--Найдите производителей принтеров. Вывести: maker

Select maker  from  Product 
where Product.type = 'printer'
group by maker

--/3
--Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.

Select model,ram,screen from Laptop
where price>1000


--/4
--Найдите все записи таблицы Printer для цветных принтеров.

select * from Printer
where color='y'


--/5
--Найдите номер модели, скорость и размер жесткого 
--диска ПК, имеющих 12x или 24x CD и цену менее 600 дол

Select model,speed,hd from PC
where (cd='12x' or cd='24x') and price<600


--/6
--Для каждого производителя, выпускающего ПК-блокноты c объёмом 
--жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов.
-- Вывод: производитель, скорость.

select distinct maker,speed from Product
inner join Laptop on Product.model = Laptop.model
where hd>=10


--/7
--Найдите номера моделей и цены всех имеющихся в продаже
-- продуктов (любого типа) производителя B (латинская буква).

Select product.model,price from PC
join Product on Product.model = PC.model
where product.maker='B'
union
Select product.model,price from Laptop
join Product on Product.model = Laptop.model
where product.maker='B'
union
Select product.model,price from Printer
join Product on Product.model = Printer.model
where product.maker='B'


--/8
--Найдите производителя, выпускающего ПК, но не ПК-блокноты.

Select maker from Product
where type='PC' and maker not in(select maker from Product where type='Laptop')
group by maker


--/9
--Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

Select maker from PC
join Product on pc.model = product.model
where speed>=450
group by maker


--/10
--Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price

Select model,price from Printer
where price = (select max(price) from Printer)


--/11
--Найдите среднюю скорость ПК.

Select avg(speed) from PC


--/12
--Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

select avg(speed) from Laptop
where price>1000


--/13
--Найдите среднюю скорость ПК, выпущенных производителем A.

Select avg(speed) from PC
join Product on PC.model = Product.model
where maker='A'


--/14

--Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

select Ships.class,name,country from Ships
join Classes on Classes.class = Ships.class
where numGuns>=10


--/15
--Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

select hd from PC
group by hd
Having  Count(hd)>=2


--16
--Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая 
--пара указывается только один раз, т.е. (i,j), но не (j,i), 
--Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.

SELECT DISTINCT p1.model, p2.model, p1.speed, p1.ram
FROM pc p1, pc p2
WHERE p1.speed = p2.speed AND p1.ram = p2.ram AND p1.model > p2.model

--17
--Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
--Вывести: type, model, speed\

Select distinct type,Laptop.model,speed from Laptop,Product
where speed< ALL(select speed from PC) and type='Laptop'

--18
--Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price

select distinct maker,price from Product
join Printer on Printer.model = Product.model
where color='y' and price = (select min(price) from Printer where color='y')

--19
--Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
--Вывести: maker, средний размер экрана.


Select maker,AVG(screen)  from Laptop
join Product on Product.model = Laptop.model
group by maker

--20
--Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

select maker,COUNT(model) from Product
where type='pc'
group by maker
Having COUNT(model)>=3


--20
--Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
--Вывести: maker, максимальная цена.

Select maker,MAX(price) from Product
join  PC on PC.model = Product.model
group by maker

--21
--Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
--Вывести: maker, максимальная цена.

Select maker,MAX(price) from Product
join  PC on PC.model = Product.model
group by maker

--22
--Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.

Select speed,AVG(price) from PC
where speed>600
group by speed

--23
--Найдите производителей, которые производили бы как ПК
--со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
--Вывести: Maker

Select distinct maker from product
join PC on Product.model = PC.model
where PC.speed>=750 
INTERSECT
select maker from Product
join Laptop on Product.model = Laptop.model
where Laptop.speed>=750


--24
--Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.


Select model from 
(
select model,price from PC 
UNION
select model,price from Laptop
UNION
select model,price from Printer
)
Product
where price = 
(
select MAX(price) from

(select price from PC
Union
select price from Laptop
Union
select price from Printer
) 
Product
)


--25
--Найдите производителей принтеров, которые производят ПК с 
--наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, 
--имеющих наименьший объем RAM. Вывести: Maker

Select distinct maker from Product
join PC on Product.model = PC.model
where ram = (select MIN(ram) from PC)
and speed = (select MAX(speed) from PC
where ram = (select MIN(ram) from PC))
and maker IN  (select maker from product
where type='Printer')

--26
--Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.

select sum(price)/Count(*) from
(SELECT price FROM pc
join Product on pc.model = product.model
 WHERE product.maker='A'
UNION all
 SELECT price FROM laptop
join product on laptop.model = product.model
 WHERE  product.maker='A') PC

 --27
 --Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
 
 Select maker,AVG(hd) from PC
join Product on PC.model = Product.model
where maker IN
(
Select maker from Product
where type='Printer'
)
group by maker

--28
--Используя таблицу Product, определить количество производителей, выпускающих по одной модели.

Select Count(maker) as qty from 
(select maker from Product
group by maker
Having Count(model)=1
)
Product


--29
--В предположении, что приход и расход денег на каждом пункте приема фиксируется не 
--чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос с 
--выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.

select Income_o.point,Income_o.date,inc,out from Income_o
left join Outcome_o on Income_o.point = Outcome_o.point
and Income_o.date = Outcome_o.date
union
select Outcome_o.point,Outcome_o.date,inc,out from Income_o
right join Outcome_o on Income_o.point = Outcome_o.point
and Income_o.date = Outcome_o.date


--Задание: 30 (Serge I: 2003-02-14)
--В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное
-- число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, 
-- в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
--Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc).
-- Отсутствующие значения считать неопределенными (NULL).
   


   ??

--31
--Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.

Select class,country from Classes
where bore>=16


--32
--Одной из характеристик корабля является половина куба калибра его главных орудий (mw). 
--С точностью до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны, 
--у которой есть корабли в базе данных.

??

--Задание: 33 (Serge I: 2002-11-02)
--Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.

select ship
from outcomes
where result = 'sunk'
and battle = 'North Atlantic'

--Задание: 34 (Serge I: 2002-11-04)
--По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли
-- водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли 
-- c известным годом спуска на воду). Вывести названия кораблей.

select name from Ships
join Classes on Classes.class=Ships.class
where type='bb' and displacement>35000 and launched>=1922

--Задание: 35 (qwrqwr: 2012-11-23)
--В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
--Вывод: номер модели, тип модели.

Select model,type from Product
where model not Like '%[^A-Z]%' or model not Like'%[^0-9]%'

--Задание: 36 (Serge I: 2003-02-17)
--Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).

select Name from Ships
where class=name
union
select ship from Classes
join Outcomes on Outcomes.ship = Classes.class


--Задание: 37 (Serge I: 2003-02-17)
--Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).

select Classes.class from Classes

join(
 
select class,name from Ships

union 

select Classes.class as class ,Outcomes.ship as name from Outcomes
join Classes on Outcomes.ship = Classes.class) 
Ships on Classes.class = Ships.class
group by Classes.class
Having Count(Ships.name)=1

--38
--Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').

Select  country  from Classes
where type='bb'
intersect 
select  country from Classes
where type='bc'


--39
--Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), 
--они участвовали в другой, произошедшей позже.

Select distinct a1.ship from Outcomes a1,Battles b1
where a1.battle = b1.name and a1.ship IN
(
select a2.ship from Outcomes a2,Battles b2
where a2.result='damaged' and b1.date>b2.date and a2.battle = b2.name )

--40
--Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
--Вывести: maker, type


Select maker,max(type) from Product
group by maker
having Count(model)>1 and COUNT(distinct type) = 1

--41
--Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
--определить максимальную цену на его продукцию.
--Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, то выводить для этого производителя NULL,
--иначе максимальную цену.

with test as (
select model,price,iif(price is null,1,0) p from PC
union 
select model,price,iif(price is null,1,0) p from Laptop
union 
select model,price,iif(price is null,1,0) p from Printer
)

select maker,
Case 
 when  sum(p)>0 then NULL
 else max(price) 
end as max_price 
from Product
join test on test.model = Product.model
group by maker


--42
--Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.

select ship,battle from Outcomes
where result = 'sunk'

--43 
--Yкажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

Select name from Battles
where year(date) not in
(
select launched from Ships
where launched  is not null
)


--44
--Найдите названия всех кораблей в базе данных, начинающихся с буквы R.

select name from Ships
where name Like 'R%'
union 
select ship from Outcomes
where ship Like 'R%'

--45
--Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
--Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.

select name from Ships
where name Like '_% _% _%'
union 
select ship from Outcomes
where ship Like '_% _% _%'

--46
--Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий.

Select  ship,displacement,numGuns from Outcomes
left join Ships on Outcomes.ship = Ships.name
left join Classes on Ships.class = Classes.class or Classes.class = Outcomes.ship
where battle = 'Guadalcanal'

--47
--Определить страны, которые потеряли в сражениях все свои корабли.



--Задание: 48 (Serge I: 2003-02-16)
--Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении

select distinct Classes.class from Outcomes
left join Ships on Outcomes.ship = Ships.name
join Classes on Ships.class=Classes.class or Outcomes.ship=Classes.class
where result='sunk'


--Задание: 49 (Serge I: 2003-02-17)
--Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).

Select name from Ships
join Classes on Ships.class = Classes.class
where Classes.bore=16
union
select ship from Outcomes
 join Classes on Outcomes.ship = Classes.class
where Classes.bore=16


--50
--Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

Select distinct battle from Outcomes
join Ships on Ships.name = Outcomes.ship
join Classes on Classes.class = Ships.class
where Classes.class='Kongo'
