-- Get ALL column names (easier to read)
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'reviews' 
ORDER BY ordinal_position;

