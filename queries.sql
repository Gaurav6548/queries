create database subqry;
use subqry;
show tables;
select * from doctors;
select * from Patients;
select * from Timetable;
select * from Ward;
select * from Medicines;

select Patient_name  from Patients where Doctor_name='Dr.Simran';

select count(Patient_ID) as Number_of_patients,Doctor_name,Ward_No from Patients group by Doctor_name,Ward_No order by Ward_No;

select Doctor_name,ROUND(avg(Fees),0) as AVG_FEES from Patients group by Doctor_name order by Doctor_name;

select d.Specialty,max(m.Injections) from Medicines m  join doctors d on m.Doctor_name=d.Doctor_name where Date='01-02-22' group by d.Specialty;

select sum(d.Nurses),t.Doctor_name from Timetable t join Ward d on d.Ward_no=t.Ward_no 
where t.Doctor_name='Dr.Rutuja' and t.Day='Wednesday' group by t.Doctor_name ;

select Doctor_name,Time from Timetable where Doctor_name='Dr.Rutuja';

select Doctor_name,count(Patient_name) from Patients where cond='Good' group by Doctor_name order by Doctor_name;

select w.Floor,min(m.Medicines) as medicine from ward w join Medicines m on w.Ward_no=m.Ward_no where m.Date= '02-02-22' group by w.Floor order by medicine limit 1;

select Ward_no,Beds from Ward  order by Beds limit 1;

select Specialty,sum(Experience) as Total_experience from doctors where Specialty='Cardiologist' group by Specialty;

select t.Doctor_name,w.Floor from Timetable t join ward w on t.Ward_no=w.Ward_no;

select Floor,floor(avg(Beds)) as avg_beds from Ward group by(Floor);

SELECT Doctor_name, Ward_no
FROM Patients
UNION 
SELECT Doctor_name, Ward_no
FROM Timetable;

select Treatment_date,count(Patient_ID) from Patients group by Treatment_date;

Select cond,count(Patient_ID) from Patients group by cond order by cond;

SELECT m.Doctor_name, SUM(m.Injections) AS Total_Injections, SUM(m.Medicines) AS Total_Medicines
FROM Medicines m
JOIN Doctors d ON m.Doctor_name = d.Doctor_name
WHERE d.Doctor_ID > 3
GROUP BY m.Doctor_name;

Select Date,sum(Medicines) as total from Medicines group by(Date) order by total desc;

select Ward_no,count(Patient_ID) from Patients where cond='Good' group by(Ward_no);

select d.Specialty,t.Time from doctors d join Timetable t on d.Doctor_name=t.Doctor_name where t.Time='10am';

select w.Ward_no,w.Nurses,m.Injections from Ward w join Medicines m on w.Ward_no=m.Ward_no where m.Injections>20;

select count(p.Patient_ID) as num_patients,d.Experience from Patients p join doctors d on d.Doctor_name=p.Doctor_name where d.Experience >3 group by d.Experience;

select p.Patient_name,d.Contact_No from Patients p join doctors d on p.Doctor_name=d.Doctor_name;

select count(Doctor_name) as Number_of_doctors,Time from Timetable group by(Time) order by Time;

select d.Doctor_ID,d.Doctor_name,p.Patient_name from doctors d join Patients p on p.Doctor_name=d.Doctor_name where p.Patient_name like 's%';

select Day_Available,Doctor_name from doctors  where Day_Available in(select Day_Available from doctors where Doctor_name='Dr.Simran') and Doctor_name<>'Dr.Simran';
