-- Check if the specific columns your frontend needs actually exist
SELECT 
    column_name,
    CASE 
        WHEN column_name IN ('id', 'company', 'website', 'reviewer_name', 'work_description', 'learning_value', 'atmosphere', 'would_recommend', 'tags', 'upvotes', 'created_at') 
        THEN '✅ NEEDED BY FRONTEND'
        ELSE '❌ Not in frontend query'
    END as status
FROM information_schema.columns 
WHERE table_name = 'reviews' 
ORDER BY 
    CASE 
        WHEN column_name IN ('id', 'company', 'website', 'reviewer_name', 'work_description', 'learning_value', 'atmosphere', 'would_recommend', 'tags', 'upvotes', 'created_at') 
        THEN 0 
        ELSE 1 
    END,
    ordinal_position;
