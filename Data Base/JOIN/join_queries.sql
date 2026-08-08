select * from sea_lions;

select * from habitats;

select * from distance_travel;

-- JOIN  / INNER_JOIN STARTS

select * from sea_lions JOIN habitats ON sea_lions.habitat_id = habitats.habitat_id

-- Left Join (Prioritizing Left Table)

select * from sea_lions LEFT JOIN habitats on sea_lions.habitat_id = habitats.habitat_id

-- Right Join (Prioritizing Right Table)
select * from sea_lions RIGHT JOIN habitats on sea_lions.habitat_id = habitats.habitat_id

-- Full Join (We will get all the rows)

select * from sea_lions FULL JOIN habitats on sea_lions.habitat_id = habitats.habitat_id
