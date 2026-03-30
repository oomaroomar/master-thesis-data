## Q1: For each weekday, what were our peak contact hours, and how are contacts distributed across the day (by hour)?
- Query 1, count 4, doesn't filter by direction_original = 'inbound'
- Query 2, count 6, does filter by direction_original = 'inbound'
Notes: Both are in some sense incorrect. We want direction = inbound when considering peak contact hours.

## Q2: Show the hourly contact-arrival distribution for every day of the week, highlighting which hours were highest on each weekday.
- Query 1, count 10, same as Q1q2.

## Q3: What times during the day (hour-by-hour) drive the most contacts, split by weekday—please summarize peak hours and the overall distribution.
- Query 1, count 6, same as Q1q2
- Query 2, count 4
Notes: query 2 has both a counter for filtering with direction_original = 'inbound' and a counter for no filter.

## Q4: Across the week, when do contacts arrive most often? Provide an hour-by-hour breakdown for each weekday and identify the peak contact hours.
- Query 1, count 3, same as Q1q1
- Query 2, count 7, same as Q1q2