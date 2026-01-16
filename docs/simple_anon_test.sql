-- Simple test: Can anon role see the reviews?
SET ROLE anon;
SELECT COUNT(*) as anon_sees_count FROM reviews;
SELECT * FROM reviews LIMIT 1;
RESET ROLE;

