-- Create a trigger to reset valid_email when the email changes
DELIMITER //

CREATE TRIGGER reset_valid_email_on_email_change
BEFORE UPDATE ON users
FOR EACH ROW
	BEGIN
		IF OLD.email <> NEW.email THEN
			SET NEW.valid_email = 0;
END IF;
END;
//

DELIMITER ;
