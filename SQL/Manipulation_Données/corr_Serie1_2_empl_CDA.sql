

----8.	Liste des diff�rents emplois et le nombre d'employ�(s)
----SELECT JOB, count(empno) as [nombre d'employe(s)] from emp GROUP BY JOB;

----9.	Donner le nom du d�partement o� travaille ALLEN
--SELECT DNAME, ENAME from DEPT INNER JOIN EMP ON emp.deptno = dept.deptno WHERE emp.ENAME = 'ALLEN';

----10.	Liste des employ�s avec nom du d�partement, nom, job,
-- --salaire class�s par noms de d�partements et par salaires d�croissants.
-- SELECT ENAME, DNAME, JOB, SAL from EMP, DEPT WHERE emp.deptno = dept.deptno ORDER BY DNAME DESC, SAL DESC;

-- 11.	Liste des employ�s vendeurs (SALESMAN) avec affichage de nom,
--  salaire, commissions, salaire + commissions
--SELECT ENAME, SAL, COMM, (SAL + COMM) AS [SALAIRE GLOBAL] FROM EMP WHERE JOB = 'SALESMAN';
--VARIANTE AVEC TOUS LES SALARIES
--SELECT ENAME, SAL, COMM,
--CASE WHEN COMM IS NULL THEN SAL ELSE (SAL + COMM) 
--END AS [SALAIRE GLOBAL]
-- FROM EMP;

---- 12.	Liste des employ�s du d�partement 20: nom, job, date d'embauche sous forme VEN 28 FEV 1997'
--SELECT ENAME, JOB, FORMAT(hiredate, 'ddd dd MMM yyyy') AS [DATE D'EMBAUCHE] FROM EMP WHERE DEPTNO = 20;

SELECT ENAME, JOB, [dbo].[fct_displaydate] (hiredate) AS [DATE D'EMBAUCHE] FROM EMP WHERE DEPTNO = 20;
GO
CREATE FUNCTION fct_displaydate (
	@toconvert AS DATETIME
	)
	RETURNS VARCHAR(MAX)
AS
BEGIN 
	DECLARE @weekday AS VARCHAR (2)
	DECLARE @month AS VARCHAR(3)
	SET @weekday = DATEPART(WEEKDAY,@toconvert)
	SET @month = MONTH (@toconvert)
	RETURN CASE 
			WHEN @weekday = 1 THEN 'LUN'
			WHEN @weekday = 2 THEN 'MAR'
			WHEN @weekday = 3 THEN 'MER'
			WHEN @weekday = 4 THEN 'JEU'
			WHEN @weekday = 5 THEN 'VEN'
			WHEN @weekday = 6 THEN 'SAM'
			WHEN @weekday = 7 THEN 'DIM'
		END
		+ ' ' + CONVERT ( CHAR(2),DAY (@toconvert))+ ' '
		+ CASE 
			WHEN @month = 1 THEN 'JAN'
			WHEN @month = 2 THEN 'FEV'
			WHEN @month = 3 THEN 'MAR'
			WHEN @month = 4 THEN 'AVR'
			WHEN @month = 5 THEN 'MAI'
			WHEN @month = 6 THEN 'JUIN'
			WHEN @month = 7 THEN 'JUIL'
			WHEN @month = 8 THEN 'AOU'
			WHEN @month = 9 THEN 'SEP'
			WHEN @month = 10 THEN 'OCT'
			WHEN @month = 11 THEN 'NOV'
			WHEN @month = 12 THEN 'DEC'
		END
		+ ' ' + CONVERT ( CHAR (4), YEAR (@toconvert)) 
END


----13.	Donner le salaire le plus �lev� par d�partement
--SELECT max(SAL) AS [SALAIRE LE PLUS ELEVE], DNAME FROM EMP RIGHT JOIN DEPT ON dept.deptno = emp.deptno GROUP BY DNAME;

--14.	Donner d�partement par d�partement masse salariale, nombre d'employ�s,
 --salaire moyen par type d'emploi.
--SELECT  DNAME,  JOB, SUM(SAL) AS [MASSE SALARIALE], COUNT(ENAME) AS [Nombre d'employ�(s)], AVG(SAL) AS [SALAIRE MOYEN] FROM EMP INNER JOIN DEPT ON dept.deptno = emp.deptno GROUP BY DNAME, JOB;

--15.	M�me question mais on se limite aux sous-ensembles d'au moins 2 employ�s
--SELECT  DNAME,  JOB, SUM(SAL) + SUM(
--CASE WHEN COMM IS NULL THEN 0 ELSE COMM
--END) AS [MASSE SALARIALE], COUNT(ENAME) AS [Nombre d'employ�(s)], AVG(SAL) AS [SALAIRE MOYEN] FROM EMP INNER JOIN DEPT ON dept.deptno = emp.deptno GROUP BY DNAME, JOB HAVING COUNT(*) >= 2;


--16.	Liste des employ�s (Nom, d�partement, salaire) de m�me emploi que JONES
--SELECT JOB FROM EMP WHERE SOUNDEX(ENAME) = SOUNDEX ('jaunes');

--SELECT ENAME, DNAME, SAL, JOB FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO AND JOB =
--(SELECT JOB FROM EMP WHERE ENAME LIKE 'JONES') AND ENAME <> 'JONES';

--17 Liste des employ�s (nom, salaire) dont le salaire est sup�rieur � la moyenne globale des salaires

--SELECT ENAME, SAL FROM EMP WHERE SAL>
--(SELECT AVG(SAL) FROM EMP);


--SELECT count(*) AS NbrSalSupMoy,(SELECT count(*)  FROM EMP) AS NBRTotalEmp FROM EMP WHERE SAL>
--(SELECT AVG(SAL) FROM EMP);

--ALTER TABLE EMP DROP CONSTRAINT FK_NUMPROJET

--DROP TABLE PROJET

--alter table EMP DROP COLUMN [NUMPROJET]


--18.	Cr�ation d'une table PROJET avec comme colonnes 
--num�ro de projet (3 chiffres), nom de projet(5 caract�res), budget. Entrez les valeurs suivantes:
--101, ALPHA,	96000
--102, BETA,	82000
--103, GAMMA,	15000

--CREATE TABLE PROJET(NUMPROJ INT IDENTITY(101,1) PRIMARY KEY,
-- NOMPROJ VARCHAR(30) NOT NULL,
-- BUDGETPROJ MONEY NOT NULL);

--INSERT INTO PROJET VALUES('ALPHA',96000),('BETA',82000),('GAMMA',15000);

--ALTER TABLE EMP ADD NUMPROJ INT 

--19.	Ajouter l'attribut num�ro de projet � la table EMP et affecter tous les
-- vendeurs du d�partement 30 au projet 101, et les autres au projet 102

--UPDATE EMP SET NUMPROJ = 101 WHERE JOB = 'SALESMAN' AND DEPTNO = 30

--UPDATE EMP 
--SET  
--NUMPROJ = 102 
--WHERE EMPNO 
--NOT IN 
--(SELECT EMPNO FROM EMP 
--WHERE JOB = 'SALESMAN'
-- AND DEPTNO = 30) 

--20.Cr�er une vue comportant tous les employ�s avec nom, job, nom de d�partement et nom de projet

--CREATE VIEW vueCda1 AS
--SELECT EMP.ENAME, EMP.JOB, DEPT.DNAME, PROJET.NOMPROJ 
--FROM EMP,DEPT,PROJET 
--WHERE EMP.DEPTNO = DEPT.DEPTNO AND EMP.NUMPROJ = PROJET.NUMPROJ ;

--CREATE VIEW vueCda2 AS 
--SELECT E.ENAME, E.JOB, DEPT.DNAME, PROJET.NOMPROJ, MANAGER.ENAME AS [SUP HIERARCHIQUE]
--from EMP E, EMP MANAGER, DEPT, PROJET 
--WHERE  E.DEPTNO = DEPT.DEPTNO AND E.NUMPROJ = PROJET.NUMPROJ AND E.MGR = MANAGER.EMPNO

--21.	A l'aide de la vue cr��e pr�c�demment, lister tous les employ�s avec nom, job, nom 
--de d�partement et nom de projet tri�s sur nom de d�partement et nom de projet

--SELECT * FROM vueCda1 
--ORDER BY DNAME ASC , NOMPROJ ASC;

--22.	Donner le nom du projet associ� � chaque manager
--SELECT * FROM vueCda1 
--WHERE JOB LIKE 'MANAGER';

--Deuxi�me partie
--1.	Afficher la liste des managers des d�partements 20 et 30
--SELECT ENAME, JOB, DEPTNO FROM EMP 
--WHERE JOB LIKE 'MANAGER' AND DEPTNO  IN(20,30);


--2.	Afficher la liste des employ�s qui ne sont pas manager et qui ont �t� embauch�s en 81
--SELECT ENAME, JOB, HIREDATE FROM EMP 
--WHERE JOB NOT IN ('MANAGER','PRESIDENT') AND YEAR(HIREDATE) = 1981 ;


--3.	Afficher la liste des employ�s ayant une commission

--SELECT ENAME, JOB, HIREDATE FROM EMP 
--WHERE COMM != 0 AND COMM IS NOT NULL ;

--4.	Afficher la liste des noms, num�ros de d�partement, 
--jobs et date d'embauche tri�s par Numero de D�partement et JOB  les derniers embauches d'abord.

--SELECT ENAME, EMP.DEPTNO, JOB, HIREDATE 
--DNAME FROM EMP 
--ORDER BY DEPTNO ASC, JOB ASC, HIREDATE DESC;

--5.	Afficher la liste des employ�s travaillant � DALLAS

--SELECT ENAME, LOC  FROM EMP, DEPT
--WHERE EMP.DEPTNO = DEPT.DEPTNO AND LOC = 'DALLAS';


--6.	Afficher les noms et dates d'embauche des employ�s 
--embauch�s avant leur manager, avec le nom et date d'embauche du manager.

--SELECT EMPLOY.ENAME AS [EMPLOY�]
--, EMPLOY.HIREDATE AS [EMPLOY� Date Embauche]
--, MANAGER.ENAME AS [MANAGER]
--, MANAGER.HIREDATE AS[MANAGER Date Embauche]  
--FROM EMP EMPLOY, EMP MANAGER 
--WHERE EMPLOY.MGR = MANAGER.EMPNO 
--AND EMPLOY.HIREDATE < MANAGER.HIREDATE;

--7.	Lister les num�ros des employ�s n'ayant pas de subordonn�.
--select EMPNO, ENAME, JOB from EMP 
--where EMPNO not in (select distinct mgr from EMP where mgr is not null)

--8.	Afficher les noms et dates d'embauche des employ�s embauch�s avant BLAKE.
--select ENAME, format(HIREDATE, 'ddd dd MMM yyyy') as [Date embauche employer], 
--(select format(HIREDATE, 'ddd dd MMM yyyy') from EMP where ENAME = 'BLAKE') 
--as [Date embauche Blake] from EMP
--where HIREDATE < (select HIREDATE from EMP where ENAME = 'BLAKE')

--9.	Afficher les employ�s embauch�s le m�me jour que FORD
--select* from EMP
--where HIREDATE = (select HIREDATE from EMP where ENAME = 'FORD')
--and ENAME != 'FORD'
----(Jour de la semaine)
--select* from EMP
--where format(HIREDATE, 'ddd') = (select format(HIREDATE, 'ddd') from EMP where ENAME = 'FORD')
--and ENAME != 'FORD'

--10.	Lister les employ�s ayant le m�me manager que CLARK
--select ENAME, EMPNO, 
--(select ENAME from EMP where EMPNO = (select MGR from EMP where ENAME ='CLARK')) as [Nom Manager] 
--from EMP
--where MGR = (select MGR from EMP where ENAME = 'CLARK')
--and ENAME != 'CLARK'

--11.	Lister les employ�s ayant m�me job et m�me manager que TURNER
--select ENAME, JOB, 
--(select ENAME from EMP where EMPNO = (select MGR from EMP where ENAME = 'TURNER')) as [Nom Manager]
-- from EMP
--where JOB = (select JOB from EMP where ENAME = 'TURNER')
--and MGR = (select MGR from EMP where ENAME = 'TURNER')
--and ENAME != 'TURNER'

--12	Lister les employ�s du d�partement RESEARCH embauch�s le m�me 
--		jour que quelqu'un du d�partement SALES.
--select ENAME, DEPT.DNAME, HIREDATE from EMP, DEPT
--where EMP.DEPTNO = DEPT.DEPTNO
--and DEPT.DNAME = 'RESEARCH'
--and HIREDATE =any
--(select HIREDATE from EMP, DEPT where EMP.DEPTNO = DEPT.DEPTNO and DEPT.DNAME = 'SALES') 

--13	Lister le nom des employ�s et �galement le nom du 
--		jour de la semaine correspondant � leur date d'embauche.
--select ENAME, format(HIREDATE, 'ddddddd')as [Jour] from EMP

--14.	Donner, pour chaque employ�, le nombre de mois qui s'est �coul� entre leur date d'embauche et la date actuelle

--SELECT ENAME, DATEDIFF( YEAR,hiredate,GETDATE())as [Anciennet� en ann�e]
--FROM emp
--order by [Anciennet� en ann�e] desc

--15.	Afficher la liste des employ�s ayant un M et un A dans leur nom.

--SELECT ENAME FROM EMP
--where ENAME LIKE '%M%A%' or  ENAME LIKE '%A%M%'

--SELECT ENAME FROM EMP
--where ENAME LIKE '%M%' and  ENAME LIKE '%A%'

--16.	Afficher la liste des employ�s ayant deux 'A' dans leur nom.

--SELECT ENAME FROM EMP
--where ENAME LIKE '%A%A%' 
--17.	Afficher les employ�s embauch�s avant tous les employ�s du d�partement 10

--Select Ename from emp where hiredate
-- <all(select hiredate from emp  where deptno=10)
-- and deptno!=10

--17.bis Afficher les employ�s ayant une date embauche inf�rieur ou �gale au plus ancien du d�partement 10
--Select Ename, deptno from emp where hiredate
-- <=(select min(hiredate) from emp  where deptno=10)
--and deptno!=10

--18.	S�lectionner le m�tier o� le salaire moyen est le plus faible.

--SELECT  avg(sal) as [salaire moyen bas]  , job from emp
--group by job 
--having AVG(sal)<=all
--(SELECT avg(SAL)  from EMP group by Job) 

--select top 1 job, avg(sal) as moyenne from emp 
--group by job 
--order by moyenne asc 

--19.	S�lectionner le d�partement ayant le plus d'employ�s

--Select count(*)as [ effectif] , Dname 
--from EMP em ,DEPT de
--where em.DEPTNO=de.DEPTNO
--group by DNAME
--having count(*)>=all (Select count(*)as [ effectif] 
--	from EMP em ,DEPT de
--	where em.DEPTNO=de.DEPTNO
--	group by DNAME)

--20.Donner la r�partition en pourcentage du nombre d'employ�s par d�partement selon le mod�le ci-dessous

--Select deptno ,convert (decimal(5,2),  convert (Real,count(*)) *100/(select count(*) from emp )) as [�ffectif par departement en %]
--from emp
--group by DEPTNO

--Select deptno ,convert (decimal(5,2), count(*) *100.0/(select count(*) from emp )) as [�ffectif par departement en %]
--from emp
--group by DEPTNO
