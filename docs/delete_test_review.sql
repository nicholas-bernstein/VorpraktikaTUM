-- Delete the test review
-- Run this in Supabase SQL Editor

DELETE FROM reviews 
WHERE company = 'Test' 
AND reviewer_name = 'nadjacortez'
AND website = 'https://news.ycombinator.com/item?id=46633488';

-- Verify it's gone
SELECT COUNT(*) as remaining_reviews FROM reviews;
