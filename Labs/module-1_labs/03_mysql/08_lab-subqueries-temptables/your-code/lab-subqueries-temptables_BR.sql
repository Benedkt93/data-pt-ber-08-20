#In this challenge, please create a table which for each author contains their author ID, last name, 
#first name, number of total titles and the sum of royalties they have received,
#In a second step, we from this table would then like to calculate the average royalty per title each author has received. 
#The final table should contain for each author their author ID, last name, first name and average royalty calculated as sum of royalties divided by title count.
#Solve this challenge in two ways: first, by using a subquery. Then, by creating a temporary table.

#Temporary Table:

CREATE TEMPORARY TABLE piblications.titles_count_royalties_sum_new
SELECT authors.au_id, authors.au_lname, authors.au_fname, COUNT(titleauthor.title_id) AS CountTitle, SUM(titles.royalty) AS SumRoyalty
FROM authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
GROUP BY authors.au_id;

#average royalty calculated as sum of royalties divided by title count.

SELECT au_id, au_lname, au_fname, SumRoyalty/CountTitle AS AverageRoyalty
FROM piblications.titles_count_royalties_sum_new;

#Subquerry
SELECT au_id, au_lname, au_fname, SumRoyalty/CountTitle AS AverageRoyalty
FROM
(SELECT authors.au_id, authors.au_lname, authors.au_fname, COUNT(titleauthor.title_id) AS CountTitle, SUM(titles.royalty) AS SumRoyalty
FROM authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
GROUP BY authors.au_id) FinalSolution;

# Alternative:

-- using a subquery
SELECT Author_ID, LastName, FirstName, SumRoyalty / TitleCount as AvgRoyalty
FROM (
select a.au_id as Author_ID, au_lname as LastName, au_fname as FirstName, COUNT(ta.title_id) as TitleCount, SUM(ta.royaltyper) as SumRoyalty
from authors a
left join titleauthor ta on a.au_id=ta.au_id
group by a.au_id) royalties;


-- using a temporary table
CREATE TEMPORARY TABLE publications.total_royalty
select a.au_id as Author_ID, au_lname as LastName, au_fname as FirstName, COUNT(ta.title_id) as TitleCount, SUM(ta.royaltyper) as SumRoyalty
from authors a
left join titleauthor ta on a.au_id=ta.au_id
group by a.au_id;
SELECT Author_ID, LastName, FirstName, SumRoyalty / TitleCount as AvgRoyalty
FROM total_royalty;


# Solution Daniel:

# Subquery
select
	au_id as AuthorID,
	au_lname as LastName,
	au_fname as FirstName,
	RoyaltySum/TitleCount as AvgRoyaltyPerTitle
from
	(select
	au.au_id,
	au.au_lname,
	au.au_fname,
	count(distinct ti.title_id) as TitleCount,
	truncate(sum(
				(ta.royaltyper / 100) * 
					(	(ti.royalty / 100) * 
						sa.qty * 
						ti.price 
					)
				)
			,2) as RoyaltySum
from
	authors as au
left join
	titleauthor as ta on au.au_id = ta.au_id
left join
	titles as ti on ta.title_id = ti.title_id
left join
	sales as sa on ti.title_id = sa.title_id
group by 1,2,3) as atr;
# Common Table Expression
with authors_titles_royalties as (
select
	au.au_id,
	au.au_lname,
	au.au_fname,
	count(distinct ti.title_id) as TitleCount,
	truncate(sum(
				(ta.royaltyper / 100) * 
					(	(ti.royalty / 100) * 
						sa.qty * 
						ti.price
					)
				)
			,2) as RoyaltySum
from
	authors as au
left join
	titleauthor as ta on au.au_id = ta.au_id
left join
	titles as ti on ta.title_id = ti.title_id
left join
	sales as sa on ti.title_id = sa.title_id
group by 1,2,3
)
select
	au_id as AuthorID,
	au_lname as LastName,
	au_fname as FirstName,
	RoyaltySum/TitleCount as AvgRoyaltyPerTitle
from
	authors_titles_royalties as atr
order by AvgRoyaltyPerTitle desc;
# Temporary table
create temporary table publications.authors_titles_royalties as
select
	au.au_id,
	au.au_lname,
	au.au_fname,
	count(distinct ti.title_id) as TitleCount,
	truncate(sum(
				(ta.royaltyper / 100) * 
					(	(ti.royalty / 100) * 
						sa.qty * 
						ti.price 
					)
				)
			,2) as RoyaltySum
from
	authors as au
left join
	titleauthor as ta on au.au_id = ta.au_id
left join
	titles as ti on ta.title_id = ti.title_id
left join
	sales as sa on ti.title_id = sa.title_id
group by 1,2,3;
select
	au_id as AuthorID,
	au_lname as LastName,
	au_fname as FirstName,
	RoyaltySum/TitleCount as AvgRoyaltyPerTitle
from
	publications.authors_titles_royalties as atr;