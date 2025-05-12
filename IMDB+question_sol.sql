USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    'movie'  as 'Table Name', COUNT(*)  as 'Total Rows'
FROM
    movie 
UNION SELECT 
    'names'  as 'Table Name', COUNT(*)  as 'Total Rows'
FROM
    names 
UNION SELECT 
    'genre'  as 'Table Name', COUNT(*)  as 'Total Rows'
FROM
    genre 
UNION SELECT 
    'role_mapping'  as 'Table Name', COUNT(*)  as 'Total Rows'
FROM
    role_mapping 
UNION SELECT 
    'director_mapping'  as 'Table Name', COUNT(*)  as 'Total Rows'
FROM
    director_mapping 
UNION SELECT 
    'ratings'  as 'Table Name', COUNT(*)  as 'Total Rows'
FROM
    ratings;

/*

Table Name			Total Rows
movies				7997
names				25735
genre				14662
role_mapping		15615
director_mapping	3867
ratings				7997

*/




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select 
sum(case when id is null then 1 else 0 end) id_null_count,
sum(case when title is null then 1 else 0 end) title_null_count,
sum(case when year is null then 1 else 0 end) year_null_count,
sum(case when date_published is null then 1 else 0 end) date_published_null_count,
sum(case when duration is null then 1 else 0 end) duration_null_count,
sum(case when country is null then 1 else 0 end) country_null_count,
sum(case when worlwide_gross_income is null then 1 else 0 end) worlwide_gross_income_null_count,
sum(case when languages is null then 1 else 0 end) languages_null_count,
sum(case when production_company is null then 1 else 0 end) production_company_null_count
from movie;

-- Ans. country,worlwide_gross_income,languages,production_company have nulls in movie table.





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Part 1:

SELECT 
    movie.Year 'Year', COUNT(movie.id) number_of_movies
FROM
    movie
GROUP BY movie.year
order by movie.year;

-- Ans. The output shows that the number of movies released reduced year by year from  2017 to 2019

-- Part 2:
SELECT 
    MONTH(movie.date_published) month_num,
    COUNT(movie.id) number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;

-- Ans. More movies are released in March and less movies are released in December.So December is less competitive month and RSVP can plan for a December release.




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(id) movies_produced
FROM
    movie
WHERE
    year = 2019
        AND (country LIKE '%India%'
        OR country LIKE '%USA%');


        
-- Ans. 1059 movies were produced in USA/India in 2019.





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre;

-- Ans. Total 13 Genres: Drama,Fantasy,Thriller,Comedy,Horror,Family,Romance,Adventure,Action,Sci-Fi,Crime,Mystery,Others.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

with genre_cnt_tbl as (
SELECT 
    genre, COUNT(movie_id) genre_count
FROM
    genre
GROUP BY genre)
select genre from genre_cnt_tbl 
	where genre_count=(
    SELECT 
    MAX(genre_count)
FROM
    genre_cnt_tbl);
    
-- Ans. Drama



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
with one_genre_movie as  (SELECT 
    movie_id
FROM
    movie
        INNER JOIN
    genre ON (movie.id = genre.movie_id)
GROUP BY movie_id
HAVING COUNT(genre) = 1)
SELECT 
    COUNT(movie_id) single_genre_cnt
FROM
    one_genre_movie;
    
-- Ans. 3289 movies belong to single genre.



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    genre, round(AVG(duration)) avg_duration
FROM
    movie
        INNER JOIN
    genre ON (movie.id = genre.movie_id)
GROUP BY genre;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_cnt_tbl as (
select genre,count(movie_id) movie_count,
rank() over(order by count(movie_id) desc) genre_rank 
from genre group by genre)
 select * from genre_cnt_tbl where genre='thriller';

-- Ans. Thriller genre is in 3rd Rank in terms of number of movies produced.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT 
    MIN(avg_rating) min_avg_rating,
    MAX(avg_rating) max_avg_rating,
    MIN(total_votes) min_total_votes,
    MAX(total_votes) max_total_votes,
    MIN(median_rating) min_median_rating,
    MAX(median_rating) max_median_rating
FROM
    ratings;



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
-- using rank
with movie_ranking as (select
title,
avg_rating, 
rank() over(order by avg_rating desc) movie_rank 
from movie
inner join ratings
on(movie.id=ratings.movie_id))
select * from movie_ranking where movie_rank <= 10;

-- using dense_rank
with movie_ranking as (select
title,
avg_rating, 
dense_rank() over(order by avg_rating desc) movie_rank 
from movie
inner join ratings
on(movie.id=ratings.movie_id))
select * from movie_ranking where movie_rank <= 10;




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, COUNT(movie_id) movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;





/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with top_prod_com as(select 
production_company,
count(id) movie_count,
rank() over(order by count(id) desc) prod_company_rank from movie
inner join ratings
on(movie.id=ratings.movie_id)
where avg_rating>8 and production_company is not null
group by production_company)
select * from top_prod_com where prod_company_rank=1;


-- Ans. 'Dream Warrior Pictures' and 'National Theatre Live' are the top production houses with 3 hit movies each



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both



-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    genre, COUNT(id) movie_count
FROM
    movie
        INNER JOIN
    genre ON (movie.id = genre.movie_id)
        INNER JOIN
    ratings ON (genre.movie_id = ratings.movie_id)
WHERE
    country LIKE '%USA%' AND year = 2017
        AND MONTH(date_published) = '03'
        AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC; 




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, 
    avg_rating, 
    group_concat(genre) genre
FROM
    movie
        INNER JOIN
    ratings ON (movie.id = ratings.movie_id)
        INNER JOIN
    genre ON (movie.id = genre.movie_id)
WHERE
    title LIKE 'The%' AND avg_rating > 8
    group by title, avg_rating;





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    median_rating, COUNT(*) movie_count
FROM
    movie
        INNER JOIN
    ratings ON (movie.id = ratings.movie_id)
WHERE
    date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND median_rating = 8
GROUP BY median_rating; 

-- Ans. 361 movies were given the median rating of 8.





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


with german_italian_vote as (select 
sum(case when languages like '%German%' then total_votes else 0 end) german_lang_movie_count,
sum(case when languages like '%Italian%' then total_votes else 0 end) Italian_lang_movie_count
from movie
inner join ratings
on(movie.id=ratings.movie_id))
select german_lang_movie_count,
Italian_lang_movie_count,
(case when german_lang_movie_count > Italian_lang_movie_count then 'Yes' else 'No' end) IS_GER_GT_ITA
from german_italian_vote;

-- Ans. Yes.German movies get more votes than Italian movies




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) known_for_movies_nulls
FROM
    names;

-- Ans. height,date_of_birth,known_for_movies





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:




with top3_genres as (
select 
genre,rank() over(order by count(id) desc) genre_rank
from movie
inner join ratings
on(movie.id=ratings.movie_id)
inner join genre
on(ratings.movie_id=genre.movie_id)
where 
avg_rating>8
group by genre) /* Top 3 genres*/

select director_ranks.director_name, director_ranks.movie_count from(select names.name director_name,
count(movie.id) movie_count,
rank() over (order by count(movie.id) desc) director_rank
 from movie
inner join ratings
on(movie.id=ratings.movie_id)
inner join director_mapping
on(movie.id=director_mapping.movie_id)
inner join names
on(director_mapping.name_id=names.id)
inner join genre
on(ratings.movie_id=genre.movie_id)
where avg_rating>8
and genre in (select genre from top3_genres where genre_rank<=3)
group by director_name) director_ranks 
where director_ranks.director_rank<=3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select actor_ranks.actor_name,actor_ranks.movie_count from (select names.name actor_name,
count(movie.id) movie_count,
rank() over (order by count(movie.id) desc) actor_rank
 from movie
inner join ratings
on(movie.id=ratings.movie_id)
inner join role_mapping
on(movie.id=role_mapping.movie_id)
inner join names
on(role_mapping.name_id=names.id)
where median_rating>=8
group by actor_name) actor_ranks where actor_ranks.actor_rank<=2;

-- Ans. Mammootty and Mohanlal





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select 
Prod_Comp_Ranks.production_company, 
Prod_Comp_Ranks.vote_count,
Prod_Comp_Ranks.prod_comp_rank from(
select 
production_company,
sum(total_votes) vote_count,
rank() over (order by sum(total_votes) desc) prod_comp_rank
from movie
inner join ratings
on(movie.id=ratings.movie_id)
group by production_company)Prod_Comp_Ranks where prod_comp_rank<=3;

-- Ans: '1st Marvel Studios', 2nd 'Twentieth Century Fox', 3rd.'Warner Bros'




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actors_info as (
select names.id actor_id, count(movie.id) movie_count from movie
inner join role_mapping
on (movie.id=role_mapping.movie_id)
inner join names
on (role_mapping.name_id=names.id)
where movie.country like '%India%'
and role_mapping.category='actor'
group by actor_id
having movie_count>=5
) /* Actor's info */
select 
names.name actor_name,
sum(ratings.total_votes) total_votes,
count(movie.id) movie_count,
round(sum(round(ratings.avg_rating*total_votes,2))/sum(round(total_votes,2)),2) actor_avg_rating,
rank() over(order by sum(ratings.avg_rating*total_votes)/sum(total_votes) desc) actor_rank
from movie
inner join role_mapping
on (movie.id=role_mapping.movie_id)
inner join ratings
on(movie.id=ratings.movie_id)
inner join names
on (role_mapping.name_id=names.id)
and names.id in(select actor_id from actors_info)
group by actor_name;

-- Ans: Vijay Sethupathi





-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actress_info as (
select names.id actress_id, count(movie.id) movie_count from movie
inner join role_mapping
on (movie.id=role_mapping.movie_id)
inner join names
on (role_mapping.name_id=names.id)
where movie.country like '%India%'
and role_mapping.category='actress'
group by actress_id
having movie_count>=3
)
select actress_rank_info.* from (select 
names.name actor_name,
sum(ratings.total_votes) total_votes,
count(movie.id) movie_count,
round(sum(round(ratings.avg_rating*total_votes,2))/sum(round(total_votes,2)),2) actress_avg_rating,
rank() over(order by sum(ratings.avg_rating*total_votes)/sum(total_votes) desc) actress_rank
from movie
inner join role_mapping
on (movie.id=role_mapping.movie_id)
inner join ratings
on(movie.id=ratings.movie_id)
inner join names
on (role_mapping.name_id=names.id)
where names.id in(select actress_id from actress_info)
and movie.languages like '%hindi%'
group by actor_name) actress_rank_info where actress_rank<=5;

-- Ans: Taapsee Pannu with avg rating of 7.74






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
select 
(case 
when avg_rating > 8 then 'Superhit movies' 
when avg_rating between 7 and 8 then 'Hit movies'
when avg_rating >=5 and avg_rating < 7 then 'One-time-watch movies'
when avg_rating < 5 then 'Flop movies'
end) movie_category,count(*) movie_count from movie
inner join genre
on(movie.id=genre.movie_id)
inner join ratings
on(movie.id=ratings.movie_id)
where genre.genre like '%Thriller%'
group by movie_category;




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
with avg_duration_dtls as (
select 
genre.genre genre,
avg(movie.duration) avg_duration
 from movie
inner join genre
on(movie.id=genre.movie_id)
group by genre) /* each genre's avg duration */
select genre,
round(avg_duration,2) avg_duration,
sum(round(avg_duration,2)) over (order by genre) running_total_duration,
round(avg(round(avg_duration,2)) over (order by genre),2) moving_avg_duration
from avg_duration_dtls;

/* Output Table
genre		avg_duration	running_total_duration	moving_avg_duration
Action			112.88			112.88					112.88
Adventure		101.87			214.75					107.38
Comedy			102.62			317.37					105.79
Crime			107.05			424.42					106.11
Drama			106.77			531.19					106.24
Family			100.97			632.16					105.36
Fantasy			105.14			737.3					105.33
Horror			92.72			830.02					103.75
Mystery			101.8			931.82					103.54
Others			100.16			1031.98					103.2
Romance			109.53			1141.51					103.77
Sci-Fi			97.94			1239.45					103.29
Thriller		101.58			1341.03					103.16

*/



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

/* Since data has both $ and INR ,but desired output shows amount in $, converting the INR amounts to $.
$ value as of 28-AUG-2023 is Rs.82.7938 Hence Re.1 = $(1/82.7938)
*/

with top3_genres as(select genre.genre,
row_number() over (order by count(movie.id) desc)  genre_rank
from movie 
inner join genre
on(movie.id=genre.movie_id)
group by genre.genre), /* top 3 genres */

movies_with_curr as (select 
genre,
movie.year year,
movie.title title,
round((case when movie.worlwide_gross_income like 'INR%' then 1/82.7938 else 1 end)*
(cast(replace(replace(ifnull(movie.worlwide_gross_income,0),'INR ',''),'$ ','') as decimal(38,0))),2) worldwide_gross_income_in_dollars
from movie
inner join genre
on(movie.id=genre.movie_id)
where genre.genre in(select genre from top3_genres where top3_genres.genre_rank<=3)), /* movies detials with gross_income converted to Dollars */

movie_rankings as(select 
group_concat(genre) as genre,
year,title,
concat('$ ',worldwide_gross_income_in_dollars) as worldwide_gross_income,
dense_rank() over (partition by year order by worldwide_gross_income_in_dollars desc) movie_rank
from movies_with_curr
group by year,title,worldwide_gross_income_in_dollars) /* Ranking based on gross income in desc order */
select * from movie_rankings where movie_rank<=5;





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:



with hit_movies_prod_companies as (select
 movie.production_company,
 count(movie.id) movie_count,
 rank()over(order by count(movie.id) desc) prod_comp_rank
 from movie inner join ratings
on(movie.id=ratings.movie_id)
where median_rating>=8
and position(',' in languages)>0
and production_company is not null
group by  movie.production_company) /* ranking the production companies based on hit movies*/
select * from hit_movies_prod_companies where prod_comp_rank <=2;

-- Ans. 1st 'Star Cinema', 2nd 'Twentieth Century Fox'






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with top_actress_ranking as 
(select 
names.name 'actress_name',
sum(total_votes) 'total_votes',
count(movie.id)  'movie_count',
round(sum(ratings.avg_rating*ratings.total_votes)/sum(total_votes),2) 'actress_avg_rating',
rank() over(order by count(movie.id) desc) 'actress_rank'
from
movie
inner join ratings
on(movie.id=ratings.movie_id)
inner join role_mapping
on(movie.id=role_mapping.movie_id)
inner join names
on(role_mapping.name_id=names.id)
inner join genre
on(movie.id=genre.movie_id)
where ratings.avg_rating> 8
and category='actress'
and genre.genre='drama'
group by names.name)/* actress in super hit movies with ranks*/
select * from top_actress_ranking where actress_rank<=3;

-- Ans: Parvathy Thiruvothu,Susan Brown,Amanda Lawrence,Denise Gough



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
with dir_ranks as (
select
director_mapping.name_id director_id,
names.name director_name,
count(movie_id) number_of_movies,
rank() over(order by count(movie_id) desc) director_rank
from movie
inner join director_mapping
on(movie.id=director_mapping.movie_id)
inner join names
on(director_mapping.name_id=names.id)
group by name_id),  /* Director Ranking based on number of movies */

top9_dir_movies_next_release as 
(select 
dir_ranks.director_id,
dir_ranks.director_name director_name,
dir_ranks.number_of_movies number_of_movies,
dir_ranks.director_rank,
movie.date_published,
movie.id movie_id,
movie.duration,
LEAD(movie.date_published, 1) OVER(PARTITION BY dir_ranks.Director_id ORDER BY movie.date_published, movie.id) AS next_movie_date
 from  movie
inner join director_mapping
on(movie.id=director_mapping.movie_id)
inner join dir_ranks
on(director_mapping.name_id=dir_ranks.Director_id)
where dir_ranks.director_rank<=9), /* Movie information of top9 directors along with next_release date column */

release_date_diff as(
select top9_dir_movies_next_release.*,
 datediff(top9_dir_movies_next_release.next_movie_date,top9_dir_movies_next_release.date_published) release_days_diff
 from top9_dir_movies_next_release) 
 
/* Inter movies release dates difference in days*/

select 
release_date_diff.director_id,
release_date_diff.director_name director_name,
release_date_diff.number_of_movies number_of_movies,
round(avg(release_days_diff)) avg_inter_movie_days,
round(sum(ratings.avg_rating*ratings.total_votes)/sum(total_votes),2) avg_rating,
sum(ratings.total_votes) total_votes,
min(ratings.avg_rating) min_rating,
max(ratings.avg_rating) max_rating,
sum(release_date_diff.duration) total_duration
from release_date_diff
inner join ratings
on(release_date_diff.movie_id=ratings.movie_id)
group by 
release_date_diff.director_id,
release_date_diff.director_name,
release_date_diff.number_of_movies
order by director_rank;

-- A.L Vijay is the No. 1 director.