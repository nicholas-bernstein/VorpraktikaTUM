-- Test what the anon role can actually see
-- This simulates what your website frontend sees

-- First, let's see what happens when we query as anon
SET ROLE anon;

-- Try to count reviews (what anon role sees)
SELECT COUNT(*) as anon_can_see_reviews FROM reviews;

-- Try to select all columns (what your frontend tries to do)
SELECT id, company, website, reviewer_name, work_description, learning_value, atmosphere, would_recommend, tags, upvotes, created_at
FROM reviews
LIMIT 3;

-- Reset back to postgres role
RESET ROLE;

