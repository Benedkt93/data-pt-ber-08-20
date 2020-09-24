
SELECT *
FROM piblications.publishers
INNER JOIN piblications.titles
ON publishers.pub_id = titles.pub_id;

SELECT *
FROM piblications.titles
INNER JOIN piblications.publishers
ON titles.pub_id = publishers.pub_id;

SELECT *
FROM piblications.publishers
LEFT JOIN piblications.titles
ON publishers.pub_id = titles.pub_id;

SELECT *
FROM piblications.titles
LEFT JOIN piblications.publishers
ON titles.pub_id = publishers.pub_id;

# pub_name, title_id, title
SELECT publishers.pub_name, COUNT(titles.title_id)
FROM piblications.publishers
INNER JOIN piblications.titles
ON publishers.pub_id = titles.pub_id
GROUP BY publishers.pub_name;

SELECT publishers.pub_name, COUNT(titles.title_id)
FROM piblications.publishers
LEFT JOIN piblications.titles
ON publishers.pub_id = titles.pub_id
GROUP BY publishers.pub_name;

SELECT publishers.pub_name, COUNT(titles.title_id) AS CountTitles
FROM piblications.publishers
LEFT JOIN piblications.titles
ON publishers.pub_id = titles.pub_id
GROUP BY publishers.pub_name;

# Alias a table
SELECT pub.pub_name, COUNT(tit.title_id) AS CountTitles
FROM piblications.publishers pub
LEFT JOIN piblications.titles tit
ON pub.pub_id = tit.pub_id
GROUP BY pub.pub_name;

# Challenge 0
# 0a) Create a table which for each author contains their author id, first name, last name, and the total number 
# of titles they have written according to the titleauthor table. Give each variable an alias, such that the table output is easy to read and interpret.

SELECT authors.au_id, authors.au_fname, authors.au_lname, COUNT(titleauthor.title_id) AS CountTitle
FROM authors
LEFT JOIN titleauthor
USING (au_id)
GROUP BY authors.au_id;
 
 # Alternative 
 
select a.au_id as "AUTHOR ID", au_lname as "LAST NAME", au_fname as "FIRST NAME", COUNT(ta.title_id) as "NUMBER TITLES"
from authors a
left join titleauthor ta 
on a.au_id=ta.au_id
group by a.au_id;

# 0b) Create a table which for each job description contains the first hire date (i.e. the first employee with this job id was hired). 
# Again, name the columns properly to have a nice return table. Sort the results from the job description with the first hire to the one with the last hire.

SELECT jobs.job_desc, MIN(employee.hire_date)
FROM jobs
LEFT JOIN employee
USING (job_id)
GROUP BY jobs.job_desc
ORDER BY MIN(employee.hire_date);

# Alternative 

select j.job_desc as "Job Description", min(e.hire_date) as "First Hire Date"
from jobs j
left join employee e 
on j.job_id=e.job_id 
group by j.job_desc 
order by min(e.hire_date) ASC;

# Challenge 1 - Who Have Published What At Where?
# In this challenge you will write a MySQL SELECT query that joins various tables to figure out what titles each author has published at which publishers. 
# Your output should have at least the following columns:

#AUTHOR ID - the ID of the author
#LAST NAME - author last name
#FIRST NAME - author first name
#TITLE - name of the published title
#PUBLISHER - name of the publisher where the title was published

select a.au_id as "AUTHOR ID", au_lname as "LAST NAME", au_fname as "FIRST NAME", t.title as TITLE, p.pub_name as PUBLISHER
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on ta.title_id=t.title_id
inner join publishers p on t.pub_id=p.pub_id;


# Challenge 2 - Who Have Published How Many At Where?
# Elevating from your solution in Challenge 1, 
# query how many titles each author has published at each publisher. 
# Your output should look something like below:


SELECT authors.au_id, authors.au_lname, authors.au_fname, publishers.pub_name, COUNT(titles.title_id)
FROM authors
INNER JOIN titleauthor
USING (au_id)
INNER JOIN titles
USING (title_id)
INNER JOIN publishers
USING (pub_id)
GROUP BY authors.au_id, publishers.pub_name
ORDER BY COUNT(titles.title_id) DESC;

# Alternative:

select a.au_id as "AUTHOR ID", au_lname as "LAST NAME", au_fname as "FIRST NAME", p.pub_name as PUBLISHER, count(t.title_id) as "TITLE COUNT"
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join titles t on ta.title_id=t.title_id
inner join publishers p on t.pub_id=p.pub_id
group by a.au_id, p.pub_id;

# Challenge 3 - Best Selling Authors
# Who are the top 3 authors who have sold the highest number of titles? 
# Write a query to find out.

SELECT authors.au_id, authors.au_lname, authors.au_fname, SUM(sales.qty)
FROM authors
INNER JOIN titleauthor
USING (au_id)
INNER JOIN titles
USING (title_id)
INNER JOIN sales
USING (title_id)
GROUP BY authors.au_id
ORDER BY SUM(sales.qty) DESC
LIMIT 3;

# Alternative:

select a.au_id as "AUTHOR ID", au_lname as "LAST NAME", au_fname as "FIRST NAME", sum(s.qty) as TOTAL
from authors a
inner join titleauthor ta on ta.au_id = a.au_id
inner join titles t on t.title_id = ta.title_id
inner join sales s on s.title_id = t.title_id
group by a.au_id
order by TOTAL desc
limit 3;

# Challenge 4 - Best Selling Authors Ranking
# Now modify your solution in Challenge 3 so that the output will display all 23 authors instead of the top 3. 
# Note that the authors who have sold 0 titles should also appear in your output (ideally display 0 instead of NULL as the TOTAL). 
# Also order your results based on TOTAL from high to low

SELECT authors.au_id, authors.au_lname, authors.au_fname, COALESCE(SUM(sales.qty), 0)
FROM authors
LEFT JOIN titleauthor
USING (au_id)
LEFT JOIN titles
USING (title_id)
LEFT JOIN sales
USING (title_id)
GROUP BY authors.au_id
ORDER BY SUM(sales.qty) DESC;

# Alternative: 

select a.au_id as "AUTHOR ID", au_lname as "LAST NAME", au_fname as "FIRST NAME", COALESCE(sum(s.qty), 0) as TOTAL
from authors a
left join titleauthor ta on ta.au_id = a.au_id
left join titles t on t.title_id = ta.title_id
left join sales s on s.title_id = t.title_id
group by a.au_id
order by TOTAL desc;

# Bonus Challenge - Most Profiting Authors
# Authors earn money from their book sales in two ways: advance and royalties. 
# An advance is the money that the publisher pays the author before the book comes out. 
# The royalties the author will receive is typically a percentage of the entire book sales. 
# The total profit an author receives by publishing a book is the sum of the advance and the royalties.

select au_id as "AUTHOR ID", au_lname as "LAST NAME", au_fname as "FIRST NAME", sum(advance + ROYALTIES) as PROFITS from (
	select title_id, au_id, au_lname, au_fname, advance, sum(ROYALTIES) as ROYALTIES from (
		select t.title_id, t.price, t.advance * (ta.royaltyper / 100) as advance, t.royalty, s.qty, a.au_id, au_lname, au_fname, ta.royaltyper, (t.price * s.qty * t.royalty * ta.royaltyper / 10000) as ROYALTIES
		from titles t
		inner join sales s on s.title_id = t.title_id
		inner join titleauthor ta on ta.title_id = s.title_id
		inner join authors a on a.au_id = ta.au_id
	) as tmp
	group by au_id, title_id
) as tmp2
group by au_id
order by PROFITS desc
limit 3;

-- Alternative Solution

WITH profit_per_title AS (
    SELECT
        s.title_id,
        t.advance,
        t.price * (t.royalty / 100) AS royalty_per_sale,
        SUM(s.qty)                  AS titles_sold
    FROM sales s
        JOIN titles t
        ON s.title_id = t.title_id
    GROUP BY 1,2,3)
SELECT
    t.au_id,
    a.au_lname,
    a.au_fname,
    SUM((ept.advance * (t.royaltyper / 100)) +
    (ept.royalty_per_sale * ept.titles_sold * (t.royaltyper / 100)))  AS profit
FROM titleauthor t
    JOIN profit_per_title ept
    ON t.title_id = ept.title_id
    JOIN authors a
    ON t.au_id = a.au_id
GROUP BY 1,2,3
ORDER BY profit DESC;