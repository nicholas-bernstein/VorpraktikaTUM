-- FIX: Ensure SELECT policy exists and works for anon role
-- Run this in Supabase SQL Editor

-- First, drop the existing SELECT policy if it exists (in case it's broken)
DROP POLICY IF EXISTS "Allow anon select" ON reviews;

-- Recreate the SELECT policy - this allows anonymous users to read all reviews
CREATE POLICY "Allow anon select" ON reviews
    FOR SELECT 
    TO anon
    USING (true);

-- Verify it was created
SELECT policyname, cmd as operation, qual as using_expression
FROM pg_policies 
WHERE tablename = 'reviews' AND policyname = 'Allow anon select';

-- Test: Check if anon can see reviews
-- (This might not work in SQL editor, but the policy should be fixed now)
-- SET ROLE anon;
-- SELECT COUNT(*) FROM reviews;
-- RESET ROLE;

