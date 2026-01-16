-- CRITICAL DIAGNOSTIC QUERIES - Run these one by one and share results

-- Query 1: Check if any reviews exist
SELECT COUNT(*) as total_reviews FROM reviews;

-- Query 2: Check what columns exist in reviews table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'reviews' 
ORDER BY ordinal_position;

-- Query 3: Check what RLS policies exist
SELECT 
    policyname, 
    cmd as operation,
    qual as using_expression,
    with_check as with_check_expression
FROM pg_policies 
WHERE tablename = 'reviews';

-- Query 4: Check if RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'reviews';

