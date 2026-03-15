-- List the total number of civil cases grouped by location.
SELECT cl.address, COUNT(*)
FROM quecourt_db.Case_File cf
JOIN quecourt_db.Court_Building cl ON cf.building_id = cl.building_id
WHERE cf.case_type = 'civil'
GROUP BY cl.address;

-- Find the court location with the most threat incidents.
SELECT cb.address, COUNT(*) 
FROM quecourt_db.Incident_Report ir
JOIN quecourt_db.Court_Building cb ON ir.building_id = cb.building_id
WHERE ir.incident_type = 'threat'
GROUP BY cb.address
ORDER BY COUNT(*) DESC 
LIMIT 1;

-- Find the name of the judge(s) that had the most court hearings on  July 26, 2023
SELECT j.name, COUNT(*) AS hearing_total
FROM quecourt_db.Judge j
JOIN quecourt_db.Presides_Over po ON po.judge_id = j.judge_id
JOIN quecourt_db.Case_File cf ON cf.case_id = po.case_id
WHERE cf.file_date = '2023-07-26'
GROUP BY j.name 
HAVING hearing_total = (SELECT MAX(hearing_total)
						FROM (SELECT COUNT(*) AS hearing_total
							  FROM quecourt_db.Judge j2
							  JOIN quecourt_db.Presides_Over po2 ON po2.judge_id = j2.judge_id
							  JOIN quecourt_db.Case_File cf2 ON cf2.case_id = po2.case_id
							  WHERE cf2.file_date = '2023-07-26'
							  GROUP BY j.name) 
                              AS counts);
                              
-- List the court buildings located in Arizona that have both libraries and detention facilities.
SELECT cb.name
FROM quecourt_db.Court_Building cb
JOIN quecourt_db.Room r ON r.building_id = cb.building_id
WHERE cb.address LIKE '%Arizona%'
	AND EXISTS( SELECT * 
				FROM quecourt_db.Room r
                WHERE r.building_id = cb.building_id AND r.room_type = 'library')
	AND EXISTS( SELECT *
				FROM quecourt_db.Room r
                WHERE r.building_id = cb.building_id AND r.room_type = 'detention');
                
-- Print the payroll from March 4, 2022 to March 10, 2022 displaying employee name, hours worked and total salary for all employees
SELECT e.name AS employee_name,
       SUM(wl.hours_worked) AS total_hours_worked,
       e.hourly_pay,
       SUM(wl.hours_worked) * e.hourly_pay AS total_salary
FROM quecourt_db.Employee e
JOIN quecourt_db.Work_Log wl ON e.employee_id = wl.employee_id
WHERE wl.work_date BETWEEN '2022-03-04' AND '2022-03-10'
GROUP BY e.employee_id, e.name, e.hourly_pay;

-- Design a delete statement to delete employees working less than 5 hours from March 4, 2023 to March 10, 2023.
DELETE FROM quecourt_db.Employee
WHERE employee_id IN (
    SELECT employee_id
    FROM (
        SELECT wl.employee_id, SUM(wl.hours_worked) AS total_hours
        FROM quecourt_db.Work_Log wl
        WHERE wl.work_date BETWEEN '2023-03-04' AND '2023-03-10'
        GROUP BY wl.employee_id
        HAVING total_hours < 5
    ) AS temp
);

-- Design an update statement to give a 23% salary raise to employees working more than 5 hours from March 4, 2023 to March 10, 2023.
UPDATE quecourt_db.Employee
SET hourly_pay = hourly_pay * 1.23
WHERE employee_id IN (
    SELECT employee_id
    FROM (
        SELECT wl.employee_id, SUM(wl.hours_worked) AS total_hours
        FROM quecourt_db.Work_Log wl
        WHERE wl.work_date BETWEEN '2023-03-04' AND '2023-03-10'
        GROUP BY wl.employee_id
        HAVING total_hours > 5
    ) AS temp
);





