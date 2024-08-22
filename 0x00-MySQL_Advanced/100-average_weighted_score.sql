-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

-- Create the procedure
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
	-- Declare local variables for weighted score and total weight
DECLARE weighted_sum FLOAT DEFAULT 0;
DECLARE total_weight INT DEFAULT 0;

-- Calculate the weighted sum and total weight for the given user
SELECT SUM(c.score * p.weight) INTO weighted_sum
FROM corrections c
JOIN projects p ON c.project_id = p.id
WHERE c.user_id = user_id;

SELECT SUM(p.weight) INTO total_weight
FROM corrections c
JOIN projects p ON c.project_id = p.id
WHERE c.user_id = user_id;

-- Calculate the average weighted score
IF total_weight > 0 THEN
	UPDATE users
	SET average_score = weighted_sum / total_weight
	WHERE id = user_id;
ELSE
	-- Handle the case where no projects are found (optional)
UPDATE users
SET average_score = 0
WHERE id = user_id;
END IF;
END //

DELIMITER ;
