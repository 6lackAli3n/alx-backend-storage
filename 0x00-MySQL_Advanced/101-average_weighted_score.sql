-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

-- Create the procedure
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
	-- Declare variables for user ID, weighted score, and total weight
DECLARE done INT DEFAULT 0;
DECLARE current_user_id INT;
DECLARE weighted_sum FLOAT;
DECLARE total_weight INT;

-- Declare a cursor to iterate over all users
DECLARE user_cursor CURSOR FOR 
SELECT id FROM users;

-- Declare a continue handler for the cursor
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

-- Open the cursor
OPEN user_cursor;

-- Loop through each user
read_loop: LOOP
-- Fetch the user ID into the variable
FETCH user_cursor INTO current_user_id;

-- Exit loop if no more rows are found
IF done THEN
	LEAVE read_loop;
END IF;

-- Initialize variables for current user
SET weighted_sum = 0;
SET total_weight = 0;

-- Calculate the weighted sum and total weight for the current user
SELECT SUM(c.score * p.weight) INTO weighted_sum
FROM corrections c
JOIN projects p ON c.project_id = p.id
WHERE c.user_id = current_user_id;

SELECT SUM(p.weight) INTO total_weight
FROM corrections c
JOIN projects p ON c.project_id = p.id
WHERE c.user_id = current_user_id;

-- Update the average score for the current user
IF total_weight > 0 THEN
	UPDATE users
	SET average_score = weighted_sum / total_weight
	WHERE id = current_user_id;
ELSE
	UPDATE users
	SET average_score = 0
	WHERE id = current_user_id;
END IF;

END LOOP;

-- Close the cursor
CLOSE user_cursor;
END //

DELIMITER ;
