
    CREATE TABLE dashboard_analytical_charts
    (
         id INT NOT NULL AUTO_INCREMENT,
         user_id INT DEFAULT NULL,
         chart_id INT DEFAULT NULL,
         width CHAR(10) DEFAULT NULL,
         alignment CHAR(10) DEFAULT NULL,
         modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         PRIMARY KEY (id)
    );