--1.	Donner nom, job, num�ro et salaire de tous les employ�s,
--puis seulement des employ�s du d�partement 10
--SELECT ENAME, JOB, EMPNO, SAL, HIREDATE FROM EMP 
--WHERE HIREDATE >= '01-01-1981'
--
--2.	Donner nom, job et salaire des employ�s de type MANAGER dont le salaire est sup�rieur � 2800
--SELECT ENAME, JOB, SAL, DATEDIFF(month, HIREDATE, getdate()) AS [Dur�e de travail] FROM EMP WHERE JOB = 'MANAGER' AND SAL > 2800 ORDER BY SAL
--
--3.	Donner la liste des MANAGER n'appartenant pas au d�partement 30
--SELECT * FROM EMP WHERE JOB = 'MANAGER' AND DEPTNO <> 30
--
--4.	Liste des employ�s de salaire compris entre 1200 et 1400
--SELECT * FROM EMP WHERE SAL BETWEEN 1250 AND 1300
--
--5.	Liste des employ�s des d�partements 10 et 30 class�s dans l'ordre alphab�tique
-- SELECT * FROM EMP WHERE DEPTNO IN (10,30) ORDER BY DEPTNO DESC, SAL DESC

-- 6. Liste des employ�s du d�partement 30 class�s dans l'ordre des salaires croissants
-- SELECT * FROM EMP
-- WHERE deptno = 30
-- ORDER BY sal DESC;

-- 7. Liste de tous les employ�s class�s par emploi et salaires d�croissants
--SELECT * FROM EMP
--ORDER BY job, sal DESC;

-- 8. Liste des diff�rents emplois
-- SELECT DISTINCT job FROM EMP;

--SELECT COUNT(*) AS [effectif d'employ�s], job FROM EMP
--GROUP BY job;

-- 9.Donner le nom du d�partement o� travaille ALLEN

--SELECT ename, dname, emp.deptno FROM emp, dept 
--WHERE emp.deptno = dept.deptno AND ename = 'ALLEN';

--SELECT ename, dname, emp.deptno FROM emp INNER JOIN dept ON dept.deptno = emp.deptno
--WHERE ename = 'ALLEN';

-- 10. Liste des employ�s avec nom du d�partement, nom, job, salaire class�s par noms de d�partements et par salaires d�croissants.

--SELECT dname, ename, job, sal FROM emp INNER JOIN dept ON dept.deptno = emp.deptno
--ORDER BY dname DESC, sal DESC;

-- 11.	Liste des employ�s vendeurs (SALESMAN) avec affichage de nom, salaire, commissions, salaire + commissions

--SELECT ename, sal, comm, CASE WHEN comm IS NULL THEN sal ELSE sal + comm END AS total FROM emp
--WHERE job = 'SALESMAN';

-- 12.	Liste des employ�s du d�partement 20: nom, job, date d'embauche sous forme VEN 28 FEV 1997'

--SELECT ename, job, FORMAT(hiredate, 'ddd dd MMM yyyy') FROM emp
--WHERE deptno = 20;

SELECT ename, job, upper (SUBSTRING(DATENAME(dw, hiredate),1,3))+' '+DATENAME(day, hiredate)+' '+ upper (SUBSTRING(DATENAME(month, hiredate),1,3))+' '+DATENAME(year, hiredate) FROM emp
WHERE deptno = 20;

--13 Donner le salaire le plus �lev� par d�partement

select emp.deptno, max(sal) as salaire_Max, dname  from emp inner join dept on emp.deptno = dept.deptno group by emp.deptno, dname

--14	Donner d�partement par d�partement masse salariale, nombre d'employ�s, salaire moyen par type d'emploi.

select dname,job,  count(empno)as effectif , sum(sal)as masse_salarial ,Avg(sal)as [salaire moyen] from emp inner join dept on emp.deptno = dept.deptno group by job, dname;

--15.	M�me question mais on se limite aux sous-ensembles d'au moins 2 employ�s
SELECT dname,job,  count(empno)as effectif , sum(sal)as masse_salarial ,Avg(sal)as [salaire moyen] from emp inner join dept on emp.deptno = dept.deptno group by dname, job having count(empno) >= 2;

--16.	Liste des employ�s (Nom, d�partement, salaire) de m�me emploi que JONES
SELECT ENAME, JOB, DNAME, SAL FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO AND JOB = (SELECT JOB FROM EMP WHERE ENAME = 'JONES') AND ENAME <> 'JONES';

--17.	Liste des employ�s (nom, salaire) dont le salaire est sup�rieur � la moyenne globale des salaires
SELECT ENAME, SAL, (SELECT AVG(SAL) FROM EMP) AS [salaire moyen global] FROM EMP WHERE SAL > (SELECT AVG(SAL) AS [moyenne des salaires] FROM EMP);

--18.	Cr�ation d'une table PROJET avec comme colonnes num�ro de projet (3 chiffres), nom de projet(5 caract�res), budget. Entrez les valeurs suivantes:
--101, ALPHA,	96000
--102, BETA,	82000
--103, GAMMA,	15000

CREATE TABLE PROJET1 (
						NUMPROJ SMALLINT IDENTITY(101, 1) PRIMARY KEY,
						NOMPROJ VARCHAR(5) NOT NULL,
						BUDGET MONEY NOT NULL);
ALTER TABLE PROJET1 DROP COLUMN NUMPROJET;
INSERT INTO PROJET1 (NOMPROJ, BUDGET) VALUES ('GAMMA', 15000);
											
ALTER TABLE PROJET1 ALTER COLUMN NUMPROJ INT;
--ALTER TABLE PROJET1 ADD
--					NUMPROJET SMALLINT NOT NULL;
SELECT * FROM PROJET1;
DROP TABLE PROJET1;

--19.	Ajouter l'attribut num�ro de projet � la table EMP et affecter tous les vendeurs du d�partement 30 au projet 101, et les autres au projet 102
ALTER TABLE EMP ADD
					NUMPROJ SMALLINT;
SELECT * FROM EMP;
ALTER TABLE EMP ADD CONSTRAINT FK_PROJET1 FOREIGN KEY (NUMPROJ) REFERENCES PROJET1 (NUMPROJ);
SELECT * FROM EMP;


UPDATE EMP SET NUMPROJ = 101 WHERE DEPTNO = 30 AND JOB = 'SALESMAN';
UPDATE EMP SET NUMPROJ = 102 WHERE EMPNO NOT IN (SELECT EMPNO FROM EMP WHERE DEPTNO = 30 AND JOB = 'SALESMAN');

SELECT * FROM EMP;

--20. Cr�er une vue comportant tous les employ�s avec nom, job, nom de d�partement et nom de projet
CREATE VIEW LISTE AS SELECT ENAME, JOB, DNAME, NOMPROJ FROM EMP, DEPT, PROJET1 WHERE EMP.DEPTNO = DEPT.DEPTNO AND EMP.NUMPROJ = PROJET1.NUMPROJ;

SELECT * FROM LISTE;

--21.	A l'aide de la vue cr��e pr�c�demment, lister tous les employ�s avec nom, job, nom de d�partement et nom de projet tri�s sur nom de d�partement et nom de projet

SELECT * FROM LISTE ORDER BY DNAME, NOMPROJ


--22.	Donner le nom du projet associ� � chaque manager

SELECT ENAME, NOMPROJ FROM LISTE WHERE JOB LIKE 'MANAGER' 

------------------------------PARTIE 2---------------------------------------------
--1.	Afficher la liste des managers des d�partements 20 et 30
SELECT * FROM EMP WHERE JOB = 'MANAGER'AND DEPTNO IN (20,30)

--2.	Afficher la liste des employ�s qui ne sont pas manager et qui ont �t� embauch�s en 81
SELECT * FROM EMP WHERE  NOT JOB = 'MANAGER' AND DATENAME (YEAR,HIREDATE) = 1981
SELECT * FROM EMP WHERE JOB <> 'MANAGER'AND DATENAME (YEAR,HIREDATE) = 1981

--3.	Afficher la liste des employ�s ayant une commission
SELECT * FROM EMP WHERE COMM > 0 AND COMM IS NOT NULL

--4.Afficher la liste des noms, num�ros de d�partement, jobs et date d'embauche tri�s par Numero de D�partement et JOB  les derniers embauches d'abord.

SELECT Ename, deptno, job, hiredate from emp order by deptno, JOB, hiredate desc

--5.Afficher la liste des employ�s travaillant � DALLAS
SELECT ENAME, LOC FROM EMP,DEPT WHERE DEPT.DEPTNO = EMP.DEPTNO AND LOC = 'DALLAS'
SELECT ENAME, LOC FROM EMP INNER JOIN DEPT ON DEPT.DEPTNO = EMP.DEPTNO WHERE LOC LIKE 'DALLAS'	

--6.Afficher les noms et dates d'embauche des employ�s embauch�s avant leur manager, avec le nom et date d'embauche du manager.

SELECT E.ENAME, E.HIREDATE, M.ENAME, M.HIREDATE FROM EMP E, EMP M WHERE E.MGR = M.EMPNO  AND E.HIREDATE < M.HIREDATE

SELECT E.ENAME, E.HIREDATE, E.JOB, M.ENAME, M.HIREDATE, M.JOB FROM EMP E INNER JOIN  EMP M ON E.MGR = M.EMPNO WHERE E.HIREDATE < M.HIREDATE


--7.	Lister les num�ros des employ�s n'ayant pas de subordonn�.

SELECT ENAME ,JOB, EMPNO FROM EMP WHERE EMPNO NOT IN (SELECT DISTINCT MGR FROM EMP WHERE MGR IS NOT NULL )
SELECT ENAME, JOB, EMPNO FROM EMP WHERE EMPNO IN ( SELECT  EMPNO FROM EMP 
EXCEPT 
SELECT MGR FROM EMP )

--8.	Afficher les noms et dates d'embauche des employ�s embauch�s avant BLAKE.

SELECT ENAME, HIREDATE FROM EMP WHERE HIREDATE < (SELECT HIREDATE FROM EMP WHERE ENAME = 'BLAKE')

--9.	Afficher les employ�s embauch�s le m�me jour que FORD.
SELECT ENAME, HIREDATE FROM EMP WHERE HIREDATE = (SELECT HIREDATE FROM EMP WHERE ENAME = 'FORD' ) AND ENAME <> 'FORD'	 

--10.	Lister les employ�s ayant le m�me manager que CLARK.
	 
SELECT ENAME, MGR, (SELECT ENAME FROM EMP WHERE EMPNO = (SELECT MGR FROM EMP WHERE ENAME = 'CLARK')) AS [NOM CHEF] FROM EMP WHERE MGR = (SELECT MGR FROM EMP WHERE ENAME = 'CLARK')

--11.	Lister les employ�s ayant m�me job et m�me manager que TURNER.

SELECT Ename , Job FROM EMP WHERE Mgr =(SELECT Mgr FROM EMP WHERE Ename = 'TURNER')AND Job =
(SELECT Job FROM EMP WHERE Ename='TURNER')AND Ename !='TURNER'

--12.	Lister les employ�s du d�partement RESEARCH embauch�s le m�me jour que quelqu'un du d�partement SALES.

SELECT Dname, Ename, Hiredate
FROM EMP INNER JOIN DEPT ON EMP.DeptNo = DEPT.DeptNo WHERE Dname='RESEARCH' AND Hiredate = ANY 
(SELECT Hiredate FROM EMP INNER JOIN DEPT ON EMP.DeptNo = DEPT.DeptNo WHERE Dname= 'SALES')

--13.	Lister le nom des employ�s et �galement le nom du jour de la semaine correspondant � leur date d'embauche.
SELECT Ename,DATENAME(dw,HireDate) AS [Nom du Jour]
FROM EMP


--14.	Donner, pour chaque employ�, le nombre de mois qui s'est �coul� entre leur date d'embauche et la date actuelle.
SELECT Ename, DATEDIFF(year,Hiredate,GETDATE())AS[Nombre de mois �coul�s depuis l'embauche] FROM EMP

--15.	Afficher la liste des employ�s ayant un M et un A dans leur nom.

SELECT EmpNo,Ename FROM EMP WHERE Ename LIKE '%M%A%' OR Ename LIKE '%A%M%'
SELECT * FROM EMP WHERE Ename LIKE '%M%' AND Ename LIKE '%A%'

--16.	Afficher la liste des employ�s ayant deux 'A' dans leur nom.
SELECT * FROM EMP WHERE  Ename LIKE '%A%A%'

--17.	Afficher les employ�s embauch�s avant tous les employ�s du d�partement 10.
SELECT DeptNo, Ename, Hiredate FROM EMP WHERE Hiredate < ALL(SELECT Hiredate FROM EMP WHERE DeptNo = 10)
ORDER BY Hiredate DESC

--18.	S�lectionner le m�tier o� le salaire moyen est le plus faible
SELECT Job, AVG(Sal)AS [Salaire Moyen]
FROM EMP
GROUP BY Job
--HAVING AVG(Sal)<= ALL(SELECT AVG(Sal)AS [Salaire Moyen] FROM EMP GROUP BY Job)
HAVING AVG(Sal) = 
	(SELECT MIN([Sal-Moy])AS [Salaire Moyen] 
		FROM (SELECT Job, AVG(Sal) AS [Sal-Moy]
		FROM EMP GROUP BY Job)AS [Temporaire])

--19.	S�lectionner le d�partement ayant le plus d'employ�s.
SELECT Dname, COUNT(*) AS [Nombre d'employ�s]
FROM DEPT INNER JOIN EMP ON EMP.DeptNo = DEPT.DeptNO GROUP BY Dname 
HAVING COUNT (*) >= ALL 
(SELECT COUNT (*) FROM EMP GROUP BY DeptNo)

-- 20 20.	Donner la r�partition en pourcentage du nombre d'employ�s par d�partement selon le mod�le ci-dessous

D�partement R�partition en % 
-----------       ---------------- 
10                  21.43            
20                 35.71            
30					42.86 

SELECT DeptNo, CONVERT(DECIMAL(5,2),CONVERT(REAL,COUNT(*)*100) /
(SELECT COUNT(*) FROM EMP)) as [pourcentage effectif]
FROM EMP
GROUP BY DeptNo

--SELECT DeptNo, CONVERT(REAL,COUNT(*)*100) /
--(SELECT COUNT(*) FROM EMP)
--FROM EMP
--GROUP BY DeptNo 