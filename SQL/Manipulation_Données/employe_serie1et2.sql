/*1.	Donner nom, job, num�ro et salaire de tous les employ�s,
puis seulement des employ�s du d�partement 10*/
--SELECT ENAME, JOB, EMPNO, SAL FROM EMP ORDER BY SAL DESC;
--SELECT ENAME, JOB, EMPNO, SAL FROM EMP WHERE DEPTNO = 10 ORDER BY SAL DESC;

/*2.	Donner nom, job et salaire des employ�s de type 
MANAGER dont le salaire est sup�rieur � 2800*/
--SELECT ENAME, JOB, SAL FROM EMP WHERE JOB = 'MANAGER' AND SAL > 2800;

/*3.Donner la liste des MANAGER n'appartenant pas au d�partement 30*/
--SELECT * FROM EMP WHERE DEPTNO <> 30 AND JOB = 'MANAGER';

/*4.	Liste des employ�s de salaire compris entre 1200 et 1400*/
--SELECT * FROM EMP WHERE SAL BETWEEN 1250 AND 1300;

/*5.	Liste des employ�s des d�partements 
10 et 30 class�s dans l'ordre alphab�tique*/

--SELECT * FROM EMP WHERE DEPTNO IN(10, 30) ORDER BY JOB, ENAME;
--6.	Liste des employ�s du d�partement 30 class�s dans l'ordre des salaires croissants
--select * from emp where deptno = 30 ORDER BY SAL 
--7.	Liste de tous les employ�s class�s par emploi et salaires d�croissants
--SELECT * FROM EMP ORDER BY JOB ,SAL DESC
--8.	Liste des diff�rents emplois

--SELECT COUNT(empno) as [effectif],JOB FROM EMP GROUP BY JOB 
--9.	Donner le nom du d�partement o� travaille ALLEN

--select dname,ename from dept inner join emp on dept.deptno=emp.deptno where ename='ALLEN'

--10.	Liste des employ�s avec nom du d�partement, nom, job, salaire
-- class�s par noms de d�partements et par salaires d�croissants.

--select dname, ename,job,sal from emp,dept where emp.deptno=dept.deptno 
--order by dname, sal desc 

--11.	Liste des employ�s vendeurs (SALESMAN) avec 
--affichage de nom, salaire, commissions, salaire + commissions

--select ename, sal, comm, (sal+comm) as [salaire complet] from emp where job='SALESMAN';
--select ename, sal, isnull(comm,0)as comm, (sal)+(isnull(comm,0)) as [salaire complet] from emp

--12.	Liste des employ�s du d�partement 20: nom, job, 
--date d'embauche sous forme VEN 28 FEV 1997'

--select ename, job , substring(datename(dw,hiredate),1,3)+' '
--+datename(day,hiredate)+' '+substring(datename(month,hiredate),1,3)+' '
--+datename(YEAR,hiredate) as [Date d'embauche], dname from emp inner join dept 
--on dept.deptno=emp.deptno where emp.deptno=20

--13.	Donner le salaire le plus �lev� par d�partement

--select dname, max(sal) as [salaire max] from emp, dept where dept.deptno=emp.deptno 
--group by dname

--14.	Donner d�partement par d�partement masse salariale, nombre d'employ�s,
-- salaire moyen par type d'emploi.

--select dname, job, sum(sal)+sum(isnull(comm,0)) as [masse salariale], count(*) as [nb employ�],
-- avg(sal) as [sal moyen] from emp, dept where dept.deptno=emp.deptno group by dname,job order by dname

--15.	M�me question mais on se limite aux sous-ensembles d'au moins 2 employ�s

--select dname, job, sum(sal)+sum(isnull(comm,0)) as [masse salariale], count(*) as [nb employ�],
--avg(sal) as [sal moyen] from emp, dept where dept.deptno=emp.deptno group by dname,job having count(*)>=2

--16.	Liste des employ�s (Nom, d�partement, salaire) de m�me emploi que JONES

--select ename,dname,sal from emp
--inner join dept on dept.deptno=emp.deptno
--where job= ( select job from emp where ename='jones') and ename<>'jones'

--17.	Liste des employ�s (nom, salaire) dont le salaire est sup�rieur � la moyenne globale des salaires
--select ename,sal,(select avg(sal) from emp) as [salaire moyen] from emp where sal>
--(select avg(sal) from emp)  



--18.	Cr�ation d'une table PROJET avec comme colonnes num�ro de projet (3 chiffres),
-- nom de projet(5 caract�res), budget. Entrez les valeurs suivantes:
--create table projet(num_Proj  numeric(3) identity(101,1) primary key,
--					nom_Proj varchar(5) not null, budget money  )


--select * from projet
--alter table emp
--add num_Proj numeric(3)
--alter table emp add constraint fk_num_Proj foreign key (num_Proj) 
--references projet(num_Proj)

--insert into projet(nom_Proj,budget) values ( 'ALPHA',96000),
--( 'BETA',82000),
--('GAMMA',15000)

--19.	Ajouter l'attribut num�ro de projet � la table EMP
-- et affecter tous les vendeurs du d�partement 30 au projet 101, 
--et les autres au projet 102

--update emp set num_Proj=101 where deptno=30 and job='SALESMAN'

--update emp set num_Proj=102 where ename not in (select ename from emp where deptno=30 and job ='SALESMAN')

--20 Cr�er une vue comportant tous les employ�s avec nom, job, nom de d�partement et nom de projet

--select * from emp
--Cr�er une vue comportant tous les employ�s avec nom, job, nom de d�partement et nom de projet

--create view liste as select ename,job,dname,nom_Proj from emp,projet,dept where emp.deptno=dept.deptno and emp.num_Proj=projet.num_Proj; 

--21.A l'aide de la vue cr��e pr�c�demment, lister tous les employ�s avec nom, job, nom de d�partement et nom de projet tri�s
-- sur nom de d�partement et nom de projet

--select * from liste order by dname,nom_Proj

--22.	Donner le nom du projet associ� � chaque manager

--select ename,job,nom_Proj from emp inner join projet on emp.num_Proj=projet.num_Proj 
--where job='manager' 

--select ename,job,nom_Proj from liste where job='manager'

--select ename,job, nom_Proj from emp inner join projet on emp.num_Proj=projet.num_Proj where empno in (select distinct mgr from emp)

/*2e partie*/

--1.	Afficher la liste des managers des d�partements 20 et 30

--select distinct ename from emp where deptno in (20,30) and job='manager'
--select distinct ename from emp where deptno in (20,30) and empno in (select distinct mgr from emp) 

--2.	Afficher la liste des employ�s qui ne sont pas manager et qui ont �t� embauch�s en 81
--select ename, hiredate from emp where empno not in (select distinct mgr from emp where mgr is not null) and datename(yyyy,hiredate)=1981

--3.	Afficher la liste des employ�s ayant une commission
--select ename, comm from emp where comm is not null and comm !=0

--4.	Afficher la liste des noms, num�ros de d�partement, jobs et date d'embauche tri�s par Numero de D�partement et JOB  les derniers embauches d'abord.
--select ename, deptno, job, hiredate from emp order by deptno, job, hiredate desc 


--5.	Afficher la liste des employ�s travaillant � DALLAS
--select ename, emp.deptno, loc from emp, dept where emp.deptno=dept.deptno and loc='dallas'

--6.	Afficher les noms et dates d'embauche des employ�s embauch�s
-- avant leur manager, avec le nom et date d'embauche du manager.
--select e.ename,e.hiredate,m.ename as [nom manager],m.hiredate as [date d'embauche manager] 
--from emp e,emp m where e.mgr = m.empno and e.hiredate < m.hiredate 
--and e.empno not in (select distinct emp.mgr from emp where emp.mgr is not null)
--order by e.deptno;

--7.	Lister les num�ros des employ�s n'ayant pas de subordonn�.
--select ENAME,JOB from EMP where EMPNO not in (select distinct MGR from EMP where MGR is not null)

--select e1.ename,e1.mgr from emp e1 left outer join emp e2 on e2.mgr=e1.empno 
--where e2.ename is null

--8.	Afficher les noms et dates d'embauche des employ�s embauch�s avant BLAKE.

--select ENAME,HIREDATE from EMP where HIREDATE <= ( select HIREDATE from EMP where ENAME='BLAKE')

--9.	Afficher les employ�s embauch�s le m�me jour que FORD.

--select ENAME,HIREDATE from EMP where HIREDATE = ( select HIREDATE from EMP where ENAME='FORD')
 --and ENAME !='FORD'

 --10.	Lister les employ�s ayant le m�me manager que CLARK
 --select ENAME,JOB from EMP where MGR = ( select MGR from EMP where ENAME='CLARK') and ENAME!='CLARK'
 
 --11.Lister les employ�s ayant m�me job et m�me manager que TURNER
--select * from emp where job = (select job from emp where ename ='TURNER') and mgr = (select mgr from emp where ename = 'TURNER')
  
-- -- 12.	Lister les employ�s du d�partement RESEARCH embauch�s le m�me jour que quelqu'un du d�partement SALES.
-- select ename, hiredate, job, dname from emp inner join dept on dept.deptno = emp.deptno where dname = 'RESEARCH' and hiredate = any (select distinct hiredate from emp, dept where dept.deptno = emp.deptno and dname = 'SALES');
 
-- -- 13.	Lister le nom des employ�s et �galement le nom du jour de la semaine correspondant � leur date d'embauche.
-- select ename, datename (weekday, hiredate)  as [jour d'embauche] from emp;

-- --14.	Donner, pour chaque employ�, le nombre de mois qui s'est �coul� entre leur date d'embauche et la date actuelle.
-- select ename, DATEDIFF ( MONTH,hiredate,getdate()) as [nombre de mois] from emp order by 2 desc;

----15. Afficher la liste des employ�s ayant un M et un A dans leur nom.
--select * from emp where ename like '%M%A%' or ename like '%A%M%' order by ename;
--select * from emp where ename like '%A%' and ename like '%M%' order by ename;

--16.	Afficher la liste des employ�s ayant deux 'A' dans leur nom.
--select * from emp where ename like '%A%A%'

--17.	Afficher les employ�s embauch�s avant tous les employ�s du d�partement 10.
--select * from emp where hiredate < all (select hiredate from emp where deptno = 10);	
--select * from emp where hiredate < (select min(hiredate) from emp where deptno = 10);


----18.	S�lectionner le m�tier o� le salaire moyen est le plus faible.
--select distinct job from emp where sal <= all (select avg(sal) from emp group by job);
--select job, avg(sal) as [salaireMoy] from emp group by job having avg (sal) <= all (select avg(sal) from emp group by job);

--19.	S�lectionner le d�partement ayant le plus d'employ�s.
--select dname, count(*) as effectif from emp,dept where emp.deptno=dept.deptno group by dname 
--having count(*) >= all (select count(*) from emp,dept where emp.deptno=dept.deptno group by dname);

--20.	Donner la r�partition en pourcentage du nombre d'employ�s par d�partement selon le mod�le ci-dessous
--D�partement R�partition en % 
-------------       ---------------- 
--10                  21.43            
--20			        35.71            
--30					42.86 


--select deptno, convert(decimal(5,2),count(*)*100/(select convert(real, count(*)) from emp)) as [repartition en %] from emp group by deptno;