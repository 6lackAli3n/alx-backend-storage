DELIMITER //

CREATE PROCEDURE ComputeAverageScoreForUser(IN user_id INT)
BEGIN
	DECLARE avg_score FLOAT;

	-- Compute the average score for the user
SELECT AVG(score) INTO avg_score
FROM corrections
WHERE user_id = user_id;

-- Update the user's average score
UPDATE users
SET average_score = avg_score
WHERE id = user_id;
END;
//

DELIMITER ;
