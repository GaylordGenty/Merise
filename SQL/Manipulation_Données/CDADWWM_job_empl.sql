--1.	Donner nom, job, numéro et salaire de tous les employés,
--puis seulement des employés du département 10
--SELECT ENAME, JOB, EMPNO, SAL, HIREDATE FROM EMP 
--WHERE HIREDATE >= '01-01-1981'
--
--2.	Donner nom, job et salaire des employés de type MANAGER dont le salaire est supérieur à 2800
--SELECT ENAME, JOB, SAL, DATEDIFF(month, HIREDATE, getdate()) AS [Durée de travail] FROM EMP WHERE JOB = 'MANAGER' AND SAL > 2800 ORDER BY SAL
--
--3.	Donner la liste des MANAGER n'appartenant pas au département 30
--SELECT * FROM EMP WHERE JOB = 'MANAGER' AND DEPTNO <> 30
--
--4.	Liste des employés de salaire compris entre 1200 et 1400
--SELECT * FROM EMP WHERE SAL BETWEEN 1250 AND 1300
--
--5.	Liste des employés des départements 10 et 30 classés dans l'ordre alphabétique
-- SELECT * FROM EMP WHERE DEPTNO IN (10,30) ORDER BY DEPTNO DESC, SAL DESC

-- 6. Liste des employés du département 30 classés dans l'ordre des salaires croissants
-- SELECT * FROM EMP
-- WHERE deptno = 30
-- ORDER BY sal DESC;

-- 7. Liste de tous les employés classés par emploi et salaires décroissants
--SELECT * FROM EMP
--ORDER BY job, sal DESC;

-- 8. Liste des différents emplois
-- SELECT DISTINCT job FROM EMP;

--SELECT COUNT(*) AS [effectif d'employés], job FROM EMP
--GROUP BY job;

-- 9.Donner le nom du département où travaille ALLEN

--SELECT ename, dname, emp.deptno FROM emp, dept 
--WHERE emp.deptno = dept.deptno AND ename = 'ALLEN';

--SELECT ename, dname, emp.deptno FROM emp INNER JOIN dept ON dept.deptno = emp.deptno
--WHERE ename = 'ALLEN';

-- 10. Liste des employés avec nom du département, nom, job, salaire classés par noms de départements et par salaires décroissants.

--SELECT dname, ename, job, sal FROM emp INNER JOIN dept ON dept.deptno = emp.deptno
--ORDER BY dname DESC, sal DESC;

-- 11.	Liste des employés vendeurs (SALESMAN) avec affichage de nom, salaire, commissions, salaire + commissions

--SELECT ename, sal, comm, CASE WHEN comm IS NULL THEN sal ELSE sal + comm END AS total FROM emp
--WHERE job = 'SALESMAN';

-- 12.	Liste des employés du département 20: nom, job, date d'embauche sous forme VEN 28 FEV 1997'

--SELECT ename, job, FORMAT(hiredate, 'ddd dd MMM yyyy') FROM emp
--WHERE deptno = 20;

SELECT ename, job, upper (SUBSTRING(DATENAME(dw, hiredate),1,3))+' '+DATENAME(day, hiredate)+' '+ upper (SUBSTRING(DATENAME(month, hiredate),1,3))+' '+DATENAME(year, hiredate) FROM emp
WHERE deptno = 20;

--13 Donner le salaire le plus élevé par département

select emp.deptno, max(sal) as salaire_Max, dname  from emp inner join dept on emp.deptno = dept.deptno group by emp.deptno, dname

--14	Donner département par département masse salariale, nombre d'employés, salaire moyen par type d'emploi.

select dname,job,  count(empno)as effectif , sum(sal)as masse_salarial ,Avg(sal)as [salaire moyen] from emp inner join dept on emp.deptno = dept.deptno group by job, dname;

--15.	Même question mais on se limite aux sous-ensembles d'au moins 2 employés
SELECT dname,job,  count(empno)as effectif , sum(sal)as masse_salarial ,Avg(sal)as [salaire moyen] from emp inner join dept on emp.deptno = dept.deptno group by dname, job having count(empno) >= 2;

--16.	Liste des employés (Nom, département, salaire) de même emploi que JONES
SELECT ENAME, JOB, DNAME, SAL FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO AND JOB = (SELECT JOB FROM EMP WHERE ENAME = 'JONES') AND ENAME <> 'JONES';

--17.	Liste des employés (nom, salaire) dont le salaire est supérieur à la moyenne globale des salaires
SELECT ENAME, SAL, (SELECT AVG(SAL) FROM EMP) AS [salaire moyen global] FROM EMP WHERE SAL > (SELECT AVG(SAL) AS [moyenne des salaires] FROM EMP);

--18.	Création d'une table PROJET avec comme colonnes numéro de projet (3 chiffres), nom de projet(5 caractères), budget. Entrez les valeurs suivantes:
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

--19.	Ajouter l'attribut numéro de projet à la table EMP et affecter tous les vendeurs du département 30 au projet 101, et les autres au projet 102
ALTER TABLE EMP ADD
					NUMPROJ SMALLINT;
SELECT * FROM EMP;
ALTER TABLE EMP ADD CONSTRAINT FK_PROJET1 FOREIGN KEY (NUMPROJ) REFERENCES PROJET1 (NUMPROJ);
SELECT * FROM EMP;


UPDATE EMP SET NUMPROJ = 101 WHERE DEPTNO = 30 AND JOB = 'SALESMAN';
UPDATE EMP SET NUMPROJ = 102 WHERE EMPNO NOT IN (SELECT EMPNO FROM EMP WHERE DEPTNO = 30 AND JOB = 'SALESMAN');

SELECT * FROM EMP;

--20. Créer une vue comportant tous les employés avec nom, job, nom de département et nom de projet
CREATE VIEW LISTE AS SELECT ENAME, JOB, DNAME, NOMPROJ FROM EMP, DEPT, PROJET1 WHERE EMP.DEPTNO = DEPT.DEPTNO AND EMP.NUMPROJ = PROJET1.NUMPROJ;

SELECT * FROM LISTE;

--21.	A l'aide de la vue créée précédemment, lister tous les employés avec nom, job, nom de département et nom de projet triés sur nom de département et nom de projet

SELECT * FROM LISTE ORDER BY DNAME, NOMPROJ


--22.	Donner le nom du projet associé à chaque manager

SELECT ENAME, NOMPROJ FROM LISTE WHERE JOB LIKE 'MANAGER' 

------------------------------PARTIE 2---------------------------------------------
--1.	Afficher la liste des managers des départements 20 et 30
SELECT * FROM EMP WHERE JOB = 'MANAGER'AND DEPTNO IN (20,30)

--2.	Afficher la liste des employés qui ne sont pas manager et qui ont été embauchés en 81
SELECT * FROM EMP WHERE  NOT JOB = 'MANAGER' AND DATENAME (YEAR,HIREDATE) = 1981
SELECT * FROM EMP WHERE JOB <> 'MANAGER'AND DATENAME (YEAR,HIREDATE) = 1981

--3.	Afficher la liste des employés ayant une commission
SELECT * FROM EMP WHERE COMM > 0 AND COMM IS NOT NULL

--4.Afficher la liste des noms, numéros de département, jobs et date d'embauche triés par Numero de Département et JOB  les derniers embauches d'abord.

SELECT Ename, deptno, job, hiredate from emp order by deptno, JOB, hiredate desc

--5.Afficher la liste des employés travaillant à DALLAS
SELECT ENAME, LOC FROM EMP,DEPT WHERE DEPT.DEPTNO = EMP.DEPTNO AND LOC = 'DALLAS'
SELECT ENAME, LOC FROM EMP INNER JOIN DEPT ON DEPT.DEPTNO = EMP.DEPTNO WHERE LOC LIKE 'DALLAS'	

--6.Afficher les noms et dates d'embauche des employés embauchés avant leur manager, avec le nom et date d'embauche du manager.

SELECT E.ENAME, E.HIREDATE, M.ENAME, M.HIREDATE FROM EMP E, EMP M WHERE E.MGR = M.EMPNO  AND E.HIREDATE < M.HIREDATE

SELECT E.ENAME, E.HIREDATE, E.JOB, M.ENAME, M.HIREDATE, M.JOB FROM EMP E INNER JOIN  EMP M ON E.MGR = M.EMPNO WHERE E.HIREDATE < M.HIREDATE


--7.	Lister les numéros des employés n'ayant pas de subordonné.

SELECT ENAME ,JOB, EMPNO FROM EMP WHERE EMPNO NOT IN (SELECT DISTINCT MGR FROM EMP WHERE MGR IS NOT NULL )
SELECT ENAME, JOB, EMPNO FROM EMP WHERE EMPNO IN ( SELECT  EMPNO FROM EMP 
EXCEPT 
SELECT MGR FROM EMP )

--8.	Afficher les noms et dates d'embauche des employés embauchés avant BLAKE.

SELECT ENAME, HIREDATE FROM EMP WHERE HIREDATE < (SELECT HIREDATE FROM EMP WHERE ENAME = 'BLAKE')

--9.	Afficher les employés embauchés le même jour que FORD.
SELECT ENAME, HIREDATE FROM EMP WHERE HIREDATE = (SELECT HIREDATE FROM EMP WHERE ENAME = 'FORD' ) AND ENAME <> 'FORD'	 

--10.	Lister les employés ayant le même manager que CLARK.
	 
SELECT ENAME, MGR, (SELECT ENAME FROM EMP WHERE EMPNO = (SELECT MGR FROM EMP WHERE ENAME = 'CLARK')) AS [NOM CHEF] FROM EMP WHERE MGR = (SELECT MGR FROM EMP WHERE ENAME = 'CLARK')

--11.	Lister les employés ayant même job et même manager que TURNER.

SELECT Ename , Job FROM EMP WHERE Mgr =(SELECT Mgr FROM EMP WHERE Ename = 'TURNER')AND Job =
(SELECT Job FROM EMP WHERE Ename='TURNER')AND Ename !='TURNER'

--12.	Lister les employés du département RESEARCH embauchés le même jour que quelqu'un du département SALES.

SELECT Dname, Ename, Hiredate
FROM EMP INNER JOIN DEPT ON EMP.DeptNo = DEPT.DeptNo WHERE Dname='RESEARCH' AND Hiredate = ANY 
(SELECT Hiredate FROM EMP INNER JOIN DEPT ON EMP.DeptNo = DEPT.DeptNo WHERE Dname= 'SALES')

--13.	Lister le nom des employés et également le nom du jour de la semaine correspondant à leur date d'embauche.
SELECT Ename,DATENAME(dw,HireDate) AS [Nom du Jour]
FROM EMP


--14.	Donner, pour chaque employé, le nombre de mois qui s'est écoulé entre leur date d'embauche et la date actuelle.
SELECT Ename, DATEDIFF(year,Hiredate,GETDATE())AS[Nombre de mois écoulés depuis l'embauche] FROM EMP

--15.	Afficher la liste des employés ayant un M et un A dans leur nom.

SELECT EmpNo,Ename FROM EMP WHERE Ename LIKE '%M%A%' OR Ename LIKE '%A%M%'
SELECT * FROM EMP WHERE Ename LIKE '%M%' AND Ename LIKE '%A%'

--16.	Afficher la liste des employés ayant deux 'A' dans leur nom.
SELECT * FROM EMP WHERE  Ename LIKE '%A%A%'

--17.	Afficher les employés embauchés avant tous les employés du département 10.
SELECT DeptNo, Ename, Hiredate FROM EMP WHERE Hiredate < ALL(SELECT Hiredate FROM EMP WHERE DeptNo = 10)
ORDER BY Hiredate DESC

--18.	Sélectionner le métier où le salaire moyen est le plus faible
SELECT Job, AVG(Sal)AS [Salaire Moyen]
FROM EMP
GROUP BY Job
--HAVING AVG(Sal)<= ALL(SELECT AVG(Sal)AS [Salaire Moyen] FROM EMP GROUP BY Job)
HAVING AVG(Sal) = 
	(SELECT MIN([Sal-Moy])AS [Salaire Moyen] 
		FROM (SELECT Job, AVG(Sal) AS [Sal-Moy]
		FROM EMP GROUP BY Job)AS [Temporaire])

--19.	Sélectionner le département ayant le plus d'employés.
SELECT Dname, COUNT(*) AS [Nombre d'employés]
FROM DEPT INNER JOIN EMP ON EMP.DeptNo = DEPT.DeptNO GROUP BY Dname 
HAVING COUNT (*) >= ALL 
(SELECT COUNT (*) FROM EMP GROUP BY DeptNo)

-- 20 20.	Donner la répartition en pourcentage du nombre d'employés par département selon le modèle ci-dessous

Département Répartition en % 
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