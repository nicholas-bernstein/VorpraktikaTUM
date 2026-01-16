-- COMPREHENSIVE FIX: Restore everything after Supabase project pause/resume
-- Run this ENTIRE script in Supabase SQL Editor
-- This fixes issues that can happen when projects are paused/resumed

-- STEP 1: Ensure RLS is enabled (it might have been disabled)
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- STEP 2: Drop ALL existing policies and recreate them fresh
DROP POLICY IF EXISTS "Allow anon select" ON reviews;
DROP POLICY IF EXISTS "Allow anon insert" ON reviews;
DROP POLICY IF EXISTS "Allow anon update" ON reviews;
DROP POLICY IF EXISTS "Allow anon insert with validation" ON reviews;

-- STEP 3: Recreate SELECT policy (most critical - allows reading reviews)
CREATE POLICY "Allow anon select" ON reviews
    FOR SELECT 
    TO anon
    USING (true);

-- STEP 4: Recreate INSERT policy
CREATE POLICY "Allow anon insert" ON reviews
    FOR INSERT 
    TO anon
    WITH CHECK (true);

-- STEP 5: Grant explicit permissions (sometimes needed after pause/resume)
GRANT SELECT ON reviews TO anon;
GRANT INSERT ON reviews TO anon;

-- STEP 6: Verify policies were created
SELECT 
    policyname, 
    cmd as operation,
    qual as using_expression,
    with_check as with_check_expression
FROM pg_policies 
WHERE tablename = 'reviews'
ORDER BY policyname;

-- STEP 7: Verify table permissions
SELECT 
    grantee, 
    privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name = 'reviews' 
AND grantee = 'anon';

-- After running this, your reviews should be visible again!

