-- FIXED SUPABASE RLS POLICIES FOR VorpraktikaTUM PLATFORM
-- This fixes the security alerts while maintaining functionality
-- Run this in your Supabase SQL Editor

-- STEP 1: Drop the old overly-permissive policies
DROP POLICY IF EXISTS "Allow anon insert" ON reviews;
DROP POLICY IF EXISTS "Allow anon update" ON reviews;

-- STEP 2: Create more secure INSERT policy
-- This still allows anonymous inserts, but adds basic validation
-- Supabase will still flag this, but it's more secure than WITH CHECK (true)
CREATE POLICY "Allow anon insert with validation" ON reviews
    FOR INSERT TO anon
    WITH CHECK (
        -- Ensure required field is present (basic validation)
        company IS NOT NULL AND length(trim(company)) > 0
    );

-- STEP 3: Remove direct UPDATE policy (we'll use the function instead)
-- This prevents anonymous users from modifying review content
-- Upvotes will go through the secure function only

-- STEP 4: Fix the increment_upvotes function security issue
-- Add explicit search_path to prevent security vulnerabilities
CREATE OR REPLACE FUNCTION increment_upvotes(review_id uuid)
RETURNS void 
LANGUAGE plpgsql 
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    UPDATE reviews
    SET upvotes = upvotes + 1
    WHERE id = review_id;
END;
$$;

-- STEP 5: Grant execute permission on the function to anonymous users
GRANT EXECUTE ON FUNCTION increment_upvotes(uuid) TO anon;

-- NOTES:
-- - SELECT policy remains as-is (USING (true) is acceptable for public read)
-- - Anonymous users can still read all reviews
-- - Anonymous users can still insert reviews (with basic validation)
-- - Anonymous users can only update via the secure function (upvotes only)
-- - The function now has a fixed search_path to prevent security issues

