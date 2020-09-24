# Lab | Action Queries
# 1. Please create a new table in the publications database called total_royalties which for each author contains their author ID, 
# last name, first name, number of total titles and the sum of royalties they have received.

CREATE TABLE publications.total_royalties
select a.au_id as Author_ID, au_lname as LastName, au_fname as FirstName, COUNT(ta.title_id) as TitleCount, SUM(ta.royaltyper) as SumRoyalty
from authors a
left join titleauthor ta on a.au_id=ta.au_id
group by a.au_id;

SELECT * from publications.total_royalties;

# 2. Delete every author which has received total royalties of less than 100.
DELETE FROM publications.total_royalties
WHERE SumRoyalty < 100;

# 3. Create a new column of type float called AvgRoyalty (this is an ALTER TABLE statement).
ALTER TABLE publications.total_royalties
ADD AvgRoyalty float;

# 4. Update the new column AvgRoyalty to equal the average royalty per title for each author.
UPDATE publications.total_royalties
SET AvgRoyalty = SumRoyalty / TitleCount;

# 5. Empty all of the values in the table.
DELETE from publications.total_royalties;

# 6. Repopulate the table to contain the same values as it did after step (4), in one single query (you have to use a subquery here)!
INSERT INTO publications.total_royalties
SELECT Author_ID, LastName, FirstName, TitleCount, SumRoyalty, SumRoyalty / TitleCount as AvgRoyalty
FROM (
select a.au_id as Author_ID, au_lname as LastName, au_fname as FirstName, COUNT(ta.title_id) as TitleCount, SUM(ta.royaltyper) as SumRoyalty
from authors a
left join titleauthor ta on a.au_id=ta.au_id
group by a.au_id) royalties WHERE SumRoyalty >= 100;

# 7. Delete the table total_royalties.
DROP TABLE total_royalties;