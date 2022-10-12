-- Question a 
select f.username , sk."level" , s.skill_name 
from "Freelancers".Freelancer f 
 inner join "Freelancers".has_skill h on f.id = h.freelancer_id
 inner join "Freelancers".skill_level sk on sk.id = h.skill_level_id  
 inner join "Freelancers".skill s on h.skill_id = s.id
where f.username = 'amirali'

-- Question B
select p.project_name 
FROM "Customers & Projects".project p 
WHERE EXISTS 
	(SELECT op.id
	FROM "Teams".on_project op  
	WHERE op.project_id = p.id);


-- Question C
select count(*) 
from "Customers & Projects".project p 
inner join "Customers & Projects".project_outcome po on po.id = p.project_outcome_id 
where po.is_completed_succesfully = true 

-- Question D
select distinct s.skill_name 
from "Teams".team t 
	inner join "Teams".team_member tm on t.id = tm.team_id
	inner join "Freelancers".freelancer f on f.id = tm.freelancer_id
	inner join "Freelancers".has_skill h on h.freelancer_id = f.id
	inner join "Freelancers".skill s on s.id = h.skill_id

	
-- Question E
select count(*)
from "Freelancers".freelancer f
	inner join "Teams".team_member tm on tm.freelancer_id = f.id
	inner join "Teams".team_member tm2 on tm2.freelancer_id = f.id
where tm.id != tm2.id 


-- Question F
select f.username, count(p.id) as number_of_succesful_projects
from "Customers & Projects".project p 
	inner join "Customers & Projects".project_outcome po on po.id = p.project_outcome_id
	inner join "Teams".on_project op on op.project_id = p.id 
	inner join "Teams".team_member tm on tm.team_id = op.team_id 
	inner join "Freelancers".freelancer f on f.id = tm.freelancer_id 
where po.is_completed_succesfully = true 
group by f.id 
order by number_of_succesful_projects
limit 1


-- Question G
CREATE VIEW succeed_number as
select f.username, count(p.id) as number_of_succesful_projects
from "Customers & Projects".project p 
	inner join "Customers & Projects".project_outcome po on po.id = p.project_outcome_id
	inner join "Teams".on_project op on op.project_id = p.id 
	inner join "Teams".team_member tm on tm.team_id = op.team_id 
	inner join "Freelancers".freelancer f on f.id = tm.freelancer_id 
where po.is_completed_succesfully = true
group by f.id

CREATE VIEW unsucceed_number as
select f.username, count(p.id) as number_of_unsuccesful_projects
from "Customers & Projects".project p 
	inner join "Customers & Projects".project_outcome po on po.id = p.project_outcome_id
	inner join "Teams".on_project op on op.project_id = p.id 
	inner join "Teams".team_member tm on tm.team_id = op.team_id 
	inner join "Freelancers".freelancer f on f.id = tm.freelancer_id 
where po.is_completed_succesfully = false
group by f.id

CREATE VIEW freelancer_points as
select s.username , s.number_of_succesful_projects*3 - d.number_of_unsuccesful_projects*2
from "succeed_number" s, "unsucceed_number" d
where s.username = d.username

	
	
-- Question H
select 
from "Freelancers".freelancer f
	left outer join "Freelancers".has_skill ht on ht.freelancer_id = f.id
where ht.id is null 
	

-- Question I
select f.username , s.skill_name 
from "Freelancers".Freelancer f 
 inner join "Freelancers".has_skill h on f.id = h.freelancer_id
 inner join "Freelancers".skill_level sk on sk.id = h.skill_level_id  
 inner join "Freelancers".skill s on h.skill_id = s.id
where sk."level" = 'perfect'
	
	