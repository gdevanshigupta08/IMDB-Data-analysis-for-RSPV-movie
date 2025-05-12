# IMDB Data Analysis for RSVP Movie Production Strategy
## Project Overview
This project leverages SQL-based analysis of an IMDB dataset to provide data-driven strategic recommendations for RSVP, a movie production house. The goal is to enhance decision-making regarding movie production and release to maximize success.

## Objective
To identify optimal strategies for RSVP concerning:
* Movie release timing.
* Genre selection.
* Ideal movie duration.
* Casting choices (directors, lead and regional actors).
* Potential production house partnerships.

## Methodology

* **Data Source:** An IMDB dataset comprising tables such as `movie`, `genre`, `ratings`, `names`, `director_mapping`, and `role_mapping`.

* **Analysis:** A comprehensive set of SQL queries (detailed in `IMDB+question_sol.sql`) was executed to analyze:
    * Movie release trends (monthly, yearly).
    * Genre popularity, combinations, and performance (ratings, votes).
    * Optimal movie durations.
    * Performance and popularity of directors and actors (including analysis of specific actors like Mammootty and actresses by genre like Parvathy Thiruvothu for Drama).
    * Success metrics of various production houses.

* **Output:** Key insights and actionable recommendations are summarized in the `RSVP_CASE_STUDY_EXECUTIVE_SUMM.pdf`.

## Key Recommendations Summary

Based on the SQL analysis, recommendations were formulated for RSVP, including:
* **Release Strategy:** Target December for releases to potentially avoid heavy competition.
* **Genre Focus:** Prioritize Drama, Comedy, or Thriller genres.
* **Movie Duration:** Aim for an approximate duration of 107 minutes.
* **Talent Acquisition:**
    * **Director:** Consider James Mangold.
    * **Lead Actors:** Consider Mammotty and Mohan Lal.
    * **Regional Appeal:** Consider Vijay Sethupathi and Tapsee Pannu.
    * **Genre-Specific (Drama):** Parvathy Thirvothu.
* **Production Partnerships:** Evaluate partnerships with entities like Dream Warrior Pictures, National Theatre Live, Warner Bros (especially for international reach), or Star Cinema (for multilingual projects).
