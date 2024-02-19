select *from hr_1;
select *from hr_2;


#Average Attrition rate for all Departments

alter table hr_1
add Attrition_Rate int  not null;

update hr_1
set attrition_rate=case
when attrition="yes" then 1
else 0
end;

select department, concat(round(avg(attrition_rate*100),2)," ","%") as Attrition_Rate from hr_1
group by department;

#Average Hourly rate of Male Research Scientist

select JobRole,round(avg(hourlyrate),2) as Average_Hourly_Rate from hr_1
where jobrole='Research Scientist' and gender="Male";

#Attrition rate Vs Monthly income stats

ALTER TABLE hr_2
CHANGE COLUMN `employee_id` Employee_id INT;

select h1.department, round(avg(h2.monthlyincome),2) as Monthly_Income, 
concat(round(avg(h1.attrition_rate*100),2)," ","%") as Attrition_Rate 
from hr_1 h1
left join hr_2 h2 on h1.EmployeeNumber=h2.Employee_id
group by department
order by attrition_rate;

#Average working years for each Department

select department, round(avg(totalworkingyears),2) as Avg_Working_Years
from hr_1 h1
join hr_2 h2 on h1.EmployeeNumber=h2.Employee_id
group by department;


#Job Role Vs Work life balance
select jobrole,avg(worklifebalance) as Work_Life_Balance 
from hr_1 h1
join hr_2 h2 on h1.EmployeeNumber=h2.Employee_id
group by jobrole;


#Attrition rate Vs Year since last promotion relation
select JobRole, concat(round(avg(attrition_rate*100),2)," ","%") as Attrition_Rate, round(avg(yearssincelastpromotion),2) as Years_Since_Last_Promotion
from hr_1 h1
join hr_2 h2 on h1.EmployeeNumber=h2.Employee_id
group by jobrole;