-- DIAGNOSTIC QUERIES - Run these in Supabase SQL Editor to diagnose the issue
-- Copy and run these one by one to see what's happening

-- 1. Check if reviews table exists and has data
SELECT COUNT(*) as total_reviews FROM reviews;

-- 2. Check what columns actually exist in the reviews table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'reviews' 
ORDER BY ordinal_position;

-- 3. Check if RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'reviews';

-- 4. List all RLS policies on reviews table
SELECT 
    policyname, 
    cmd as operation,
    qual as using_expression,
    with_check as with_check_expression
FROM pg_policies 
WHERE tablename = 'reviews';

-- 5. Try to see reviews as the anon role (simulate what your app sees)
-- Note: This might not work in SQL editor, but worth trying
SET ROLE anon;
SELECT COUNT(*) as anon_can_see FROM reviews;
RESET ROLE;

-- 6. Check if increment_upvotes function exists and its permissions
SELECT 
    routine_name,
    routine_type,
    security_type
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name = 'increment_upvotes';

-- 7. Check function permissions
SELECT 
    p.proname as function_name,
    pg_get_functiondef(p.oid) as function_definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public' 
AND p.proname = 'increment_upvotes';

-- IMPORTANT: After running these, check:
-- - If total_reviews > 0, data exists!
-- - If RLS policies are missing, that's the problem
-- - If columns don't match what your code expects, that's the problem
