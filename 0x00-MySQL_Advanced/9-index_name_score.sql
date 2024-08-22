-- Create a composite index on the first letter of the name and the score column
CREATE INDEX idx_name_first_score ON names (name(1), score);
