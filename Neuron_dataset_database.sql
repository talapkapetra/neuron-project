CREATE DATABASE neuron_dataset;

CREATE SCHEMA neuron_dataset;

SET search_path TO neuron_dataset;

-- 1. dendrite_data table
DROP TABLE neuron_dataset.dendrite_data
CREATE TABLE neuron_dataset.dendrite_data(
    dendrite_number VARCHAR (256) PRIMARY KEY,
    branch_number INT,
    marker VARCHAR (256),
    lenght_micron DECIMAL,
    surface_area_micron2 DECIMAL,
    as_bouton_number INT,
    ss_bouton_number INT
);

-- 2. cb_den1_before_shrink_bouton table
DROP TABLE neuron_dataset.CB_den1_before_shrink_bouton;
CREATE TABLE neuron_dataset.CB_den1_before_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 3. cb_den1_before_shrink_synapse table
DROP TABLE neuron_dataset.CB_den1_before_shrink_synapse;
CREATE TABLE neuron_dataset.CB_den1_before_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CB_den1_before_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CB_den1_before_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 4. cb_den1_before_shrink_vesicle table
DROP TABLE neuron_dataset.CB_den1_before_shrink_vesicle;
CREATE TABLE neuron_dataset.CB_den1_before_shrink_vesicle(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_type VARCHAR (256),
    vesicle_area_micron2 DECIMAL,
    form_factor DECIMAL,
    nearest_neighbour_distance_micron DECIMAL
);

-- 5. cb_den1_after_shrink_bouton table
DROP TABLE neuron_dataset.CB_den1_after_shrink_bouton;
CREATE TABLE neuron_dataset.CB_den1_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 6. cb_den1_after_shrink_synapse table
DROP TABLE neuron_dataset.CB_den1_after_shrink_synapse;
CREATE TABLE neuron_dataset.CB_den1_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CB_den1_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CB_den1_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 7. cb_den1_after_shrink_vesicle table
DROP TABLE neuron_dataset.CB_den1_after_shrink_vesicle;
CREATE TABLE neuron_dataset.CB_den1_after_shrink_vesicle(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_type VARCHAR (256),
    vesicle_area_micron2 DECIMAL,
    form_factor DECIMAL,
    nearest_neighbour_distance_micron DECIMAL
);

-- 8. cb_den2_before_shrink_bouton table
DROP TABLE neuron_dataset.CB_den2_before_shrink_bouton;
CREATE TABLE neuron_dataset.CB_den2_before_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 9. cb_den2_before_shrink_synapse table
DROP TABLE neuron_dataset.CB_den2_before_shrink_synapse;
CREATE TABLE neuron_dataset.CB_den2_before_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CB_den2_before_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CB_den2_before_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 10. cb_den2_before_shrink_vesicle table
DROP TABLE neuron_dataset.CB_den2_before_shrink_vesicle;
CREATE TABLE neuron_dataset.CB_den2_before_shrink_vesicle(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_type VARCHAR (256),
    vesicle_area_micron2 DECIMAL,
    form_factor DECIMAL,
    nearest_neighbour_distance_micron DECIMAL
);

-- 11. cb_den2_after_shrink_bouton table
DROP TABLE neuron_dataset.CB_den2_after_shrink_bouton;
CREATE TABLE neuron_dataset.CB_den2_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 12. cb_den2_after_shrink_synapse table
DROP TABLE neuron_dataset.CB_den2_after_shrink_synapse;
CREATE TABLE neuron_dataset.CB_den2_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CB_den2_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CB_den2_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 13. cb_den2_after_shrink_vesicle table
DROP TABLE neuron_dataset.CB_den2_after_shrink_vesicle;
CREATE TABLE neuron_dataset.CB_den2_after_shrink_vesicle(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_type VARCHAR (256),
    vesicle_area_micron2 DECIMAL,
    form_factor DECIMAL,
    nearest_neighbour_distance_micron DECIMAL
);

-- 14. cb_den3_after_shrink_bouton table
DROP TABLE neuron_dataset.CB_den3_after_shrink_bouton;
CREATE TABLE neuron_dataset.CB_den3_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 15. cb_den3_after_shrink_synapse table
DROP TABLE neuron_dataset.CB_den3_after_shrink_synapse;
CREATE TABLE neuron_dataset.CB_den3_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CB_den3_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CB_den3_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 16. cr_den1_after_shrink_bouton table
DROP TABLE neuron_dataset.CR_den1_after_shrink_bouton;
CREATE TABLE neuron_dataset.CR_den1_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 17. cr_den1_after_shrink_synapse table
DROP TABLE neuron_dataset.CR_den1_after_shrink_synapse;
CREATE TABLE neuron_dataset.CR_den1_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CR_den1_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CR_den1_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 18. cr_den2_after_shrink_bouton table
DROP TABLE neuron_dataset.CR_den2_after_shrink_bouton;
CREATE TABLE neuron_dataset.CR_den2_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 19. cr_den2_after_shrink_synapse table
DROP TABLE neuron_dataset.CR_den2_after_shrink_synapse;
CREATE TABLE neuron_dataset.CR_den2_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CR_den2_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CR_den2_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 20. cr_den3_after_shrink_bouton table
DROP TABLE neuron_dataset.CR_den3_after_shrink_bouton;
CREATE TABLE neuron_dataset.CR_den3_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 21. cr_den3_after_shrink_synapse table
DROP TABLE neuron_dataset.CR_den3_after_shrink_synapse;
CREATE TABLE neuron_dataset.CR_den3_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CR_den3_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CR_den3_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 22. pv_den1_after_shrink_bouton table
DROP TABLE neuron_dataset.PV_den1_after_shrink_bouton;
CREATE TABLE neuron_dataset.PV_den1_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 23. pv_den1_after_shrink_synapse table
DROP TABLE neuron_dataset.PV_den1_after_shrink_synapse;
CREATE TABLE neuron_dataset.PV_den1_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_PV_den1_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.PV_den1_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 24. pv_den2_after_shrink_bouton table
DROP TABLE neuron_dataset.PV_den2_after_shrink_bouton;
CREATE TABLE neuron_dataset.PV_den2_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 25. pv_den2_after_shrink_synapse table
DROP TABLE neuron_dataset.PV_den2_after_shrink_synapse;
CREATE TABLE neuron_dataset.PV_den2_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_PV_den2_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.PV_den2_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 26. pv_den3_after_shrink_bouton table
DROP TABLE neuron_dataset.PV_den3_after_shrink_bouton;
CREATE TABLE neuron_dataset.PV_den3_after_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 27. pv_den3_after_shrink_synapse table
DROP TABLE neuron_dataset.PV_den3_after_shrink_synapse;
CREATE TABLE neuron_dataset.PV_den3_after_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_PV_den3_after_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.PV_den3_after_shrink_bouton(bouton_number) ON DELETE CASCADE
);

SELECT * FROM neuron_dataset.dendrite_data;

SELECT * FROM neuron_dataset.CB_den1_before_shrink_bouton;
SELECT * FROM neuron_dataset.CB_den1_before_shrink_synapse;
SELECT * FROM neuron_dataset.CB_den1_before_shrink_vesicle;
SELECT * FROM neuron_dataset.CB_den1_after_shrink_bouton;
SELECT * FROM neuron_dataset.CB_den1_after_shrink_synapse;
SELECT * FROM neuron_dataset.CB_den1_after_shrink_vesicle;

SELECT * FROM neuron_dataset.CB_den2_before_shrink_bouton;
SELECT * FROM neuron_dataset.CB_den2_before_shrink_synapse;
SELECT * FROM neuron_dataset.CB_den2_before_shrink_vesicle;
SELECT * FROM neuron_dataset.CB_den2_after_shrink_bouton;
SELECT * FROM neuron_dataset.CB_den2_after_shrink_synapse;
SELECT * FROM neuron_dataset.CB_den2_after_shrink_vesicle;

SELECT * FROM neuron_dataset.CB_den3_after_shrink_bouton;
SELECT * FROM neuron_dataset.CB_den3_after_shrink_synapse;

SELECT * FROM neuron_dataset.CR_den1_after_shrink_bouton;
SELECT * FROM neuron_dataset.CR_den1_after_shrink_synapse;

SELECT * FROM neuron_dataset.CR_den2_after_shrink_bouton;
SELECT * FROM neuron_dataset.CR_den2_after_shrink_synapse;

SELECT * FROM neuron_dataset.CR_den3_after_shrink_bouton;
SELECT * FROM neuron_dataset.CR_den3_after_shrink_synapse;

SELECT * FROM neuron_dataset.PV_den1_after_shrink_bouton;
SELECT * FROM neuron_dataset.PV_den1_after_shrink_synapse;

SELECT * FROM neuron_dataset.PV_den2_after_shrink_bouton;
SELECT * FROM neuron_dataset.PV_den2_after_shrink_synapse;

SELECT * FROM neuron_dataset.PV_den3_after_shrink_bouton;
SELECT * FROM neuron_dataset.PV_den3_after_shrink_synapse;