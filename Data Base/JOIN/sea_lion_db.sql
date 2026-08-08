-- Table 1: Habitats
CREATE TABLE habitats (
    habitat_id INT PRIMARY KEY,
    habitat_name VARCHAR(50) NOT NULL,
    water_type VARCHAR(30),
    capacity INT
);

-- Table 2: Sea Lions
CREATE TABLE sea_lions (
    sea_lion_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    species VARCHAR(50),
    habitat_id INT,
    FOREIGN KEY (habitat_id) REFERENCES habitats(habitat_id)
);

CREATE TABLE distance_travel (
    travel_id INT PRIMARY KEY,
    sea_lion_id INT,
    travel_date DATE,
    distance_km DECIMAL(6,2),
    destination VARCHAR(50),
    FOREIGN KEY (sea_lion_id) REFERENCES sea_lions(sea_lion_id)
);


-- Insert Habitats
INSERT INTO habitats (habitat_id, habitat_name, water_type, capacity) VALUES
(1, 'Pacific Cove', 'Saltwater', 5),
(2, 'Lagoon Splash', 'Saltwater', 8),
(3, 'Arctic Bay', 'Chilled Saltwater', 4),
(4, 'Quarantine Bay', 'Freshwater', 2);

-- Insert Sea Lions
INSERT INTO sea_lions (sea_lion_id, name, age, species, habitat_id) VALUES
(101, 'Leo', 6, 'California Sea Lion', 1),
(102, 'Sammie', 4, 'California Sea Lion', 1),
(103, 'Barnaby', 9, 'Steller Sea Lion', 2),
(104, 'Cleo', 3, 'South American Sea Lion', 2),
(105, 'Nico', 2, 'Galapagos Sea Lion', NULL);

INSERT INTO distance_travel (travel_id, sea_lion_id, travel_date, distance_km, destination) VALUES
(1, 101, '2026-08-01', 12.50, 'Outer Reef'),
(2, 101, '2026-08-03', 8.20, 'Kelp Forest'),
(3, 102, '2026-08-02', 15.10, 'Rocky Shoals'),
(4, 103, '2026-08-01', 22.40, 'Deep Trench'),
(5, 105, '2026-08-04', 5.75, 'Sandy Bay'),
(6, 101, '2026-08-05', 18.30, 'Outer Reef');