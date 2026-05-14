CREATE DATABASE IF NOT EXISTS security_pipeline;
ALTER USER 'project_user'@'localhost' IDENTIFIED BY 'project123';

GRANT ALL PRIVILEGES ON security_pipeline.* TO 'project_user'@'localhost';

FLUSH PRIVILEGES;

use security_pipeline;
select count(*) as total_rows
from infil2_cleaned;

select label, count(*) as total_records
from infil2_cleaned
group by label;

SELECT 
    label,
    COUNT(*) AS total_records,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM infil2_cleaned), 2) AS percentage
FROM infil2_cleaned
GROUP BY label;


SELECT protocol, COUNT(*) AS total_records
FROM infil2_cleaned
GROUP BY protocol
ORDER BY total_records DESC;

SELECT dst_port, COUNT(*) AS total_records
FROM infil2_cleaned
WHERE label = 'Infilteration'
GROUP BY dst_port
ORDER BY total_records DESC
LIMIT 10;


