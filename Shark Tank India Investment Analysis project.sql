create database project;

use project;


                                      /*total episodes*/

select count(distinct epno) from project.data;

                                        -- number of pitches 

select count(distinct brand) from project.data;

                                      -- pitches converted

ALTER TABLE project.data CHANGE `Amount Invested lakhs` amount_invested_lakhs BIGINT;

select count(amount_invested_lakhs) from data;
select cast(sum(a.converted_not_converted) as float) /cast(count(*) as float) from (
select amount_invested_lakhs , case when amount_invested_lakhs>0 then 1 else 0 end as converted_not_converted from project.data) a;



                                   -- total number of male

select sum(male) from project.data;

                                   -- total number of female

select sum(female) from project.data;

									-- gender ratio

select sum(female)/sum(male) from project.data;

									-- total invested amount

select sum(amountinvestedlakhs) from project.data;

								-- avg equity taken 

alter table project.data change `equity_taken_per` equity_taken_percent bigint;
select avg(a.equity_taken_percent) from
(select * from project.data where equity_taken_percent>0) a;


										-- highest deal taken

select max(amount_invested_lakhs) from project.data;


										-- higheest equity taken

select max(equity_taken_percent) from project.data;

										-- startups having at least women

SELECT COUNT(*) AS startups_having_at_least_one_woman
FROM project.data
WHERE female > 0;


								-- pitches converted having atleast one women


select sum(b.female_count) from(

select case when a.female>0 then 1 else 0 end as female_count ,a.*from (
(select * from project.data where deal!='No Deal')) a)b;

									-- avg team members

alter table project.data change `Team members` team_members int;
select avg(team_members) from project.data;

								-- amount invested per deal

select avg(a.amount_invested_lakhs) amount_invested_per_deal from
(select * from project.data where deal!='No Deal') a;


-- avg age group of contestants

-- Transform the range data to average integer values

UPDATE project.data
SET `Avg age` = (CAST(SUBSTRING_INDEX(`Avg age`, '-', 1) AS UNSIGNED) + 
                 CAST(SUBSTRING_INDEX(`Avg age`, '-', -1) AS UNSIGNED)) / 2;


                      -- avg age group of contestants
select avg_age,count(avg_age) cnt from project.data group by avg_age order by cnt desc;
	
							 -- location group of contestants

select location,count(location) cnt from project.data group by location order by cnt desc;

							-- sector group of contestants

select sector,count(sector) cnt from project.data group by sector order by cnt desc;


											-- partner deals

select partners,count(partners) cnt from project.data  where partners!='-' group by partners order by cnt desc;



										-- making the matrix

select * from project.data;

alter table project.data change `Ashneer Amount Invested` ashneer_amount_invested bigint;
select 'Ashnner' as keyy,count(ashneer_amount_invested) from project.data where ashneer_amount_invested is not null;


select 'Ashnner' as keyy,count(ashneer_amount_invested) from project.data where ashneer_amount_invested is not null AND ashneer_amount_invested!=0;

alter table project.data change `Ashneer Equity Taken %` ashneer_equity_taken_percent bigint;

SELECT 'Ashneer' as keyy,SUM(C.ashneer_amount_invested),AVG(C.ashneer_equity_taken_percent) 
FROM (SELECT * FROM PROJECT.DATA  WHERE ashneer_equity_taken_percent!=0 AND ashneer_equity_taken_percent IS NOT NULL) C;



select m.keyy,m.total_deals_present,m.total_deals,n.total_amount_invested,n.avg_equity_taken from

(select a.keyy,a.total_deals_present,b.total_deals from(

select 'Ashneer' as keyy,count(ashneer_amount_invested) total_deals_present from project.data where ashneer_amount_invested is not null) a

inner join (
select 'Ashneer' as keyy,count(ashneer_amount_invested) total_deals from project.data 
where ashneer_amount_invested is not null AND ashneer_amount_invested!=0) b 

on a.keyy=b.keyy) m

inner join 

(SELECT 'Ashneer' as keyy,SUM(C.ashneer_amount_invested) total_amount_invested,
AVG(C.ashneer_equity_taken_percent) avg_equity_taken
FROM (SELECT * FROM PROJECT.DATA  WHERE ashneer_equity_taken_percent!=0 AND ashneer_equity_taken_percent IS NOT NULL) C) n

on m.keyy=n.keyy;




-- which is the startup in which the highest amount has been invested in each domain/sector


select c.* from 
(select brand,sector,amount_invested_lakhs,rank() over(partition by sector order by amount_invested_lakhs desc) rnk 

from project.data) c

where c.rnk=1;
