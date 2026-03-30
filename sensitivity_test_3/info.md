## Q1: Of the contacts answered within our service-level target, what share were closed by the customer compared to those closed by the agent?
- Query 1, count 2
- Query 2, count 8
Notes: Query 1 is incorrectish, gives pecentage as client/(client+peer) rather than client/all i.e. doesn't include transfer, null, error, endpoint in the denominator.
Query 2 is correct

## Q2: For interactions resolved within the service level target, what percentage wre customer-closed versus agent-clsoed?
- Query 1, count 10, correct

## Q3: Within our service level target, how is the closure split: what percent of contacts were closed by customers versus agents?
- Query 1, count 6, incorrect
- Query 2, coutn 4, incorrect
Note: with this prompt the model didn't apply the filter direction = 'inbound', which we should assume when we are filtering by service level. The different queries only differ in that one of the counts using the distinct keyword.

## Q4: Among contacts answered within SLA, what proportion ended with customer closure versus agent closure?
- Query 1, count 7, correct
- Query 2, count 1, correct
- Query 3, count 1, incorrect a bit
- Query 4, count 1, incorrect a bit
