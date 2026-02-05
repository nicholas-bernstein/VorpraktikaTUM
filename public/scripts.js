const SUPABASE_URL = "https://fqsuegrrtmazhgjhvsmr.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxc3VlZ3JydG1hemhnamh2c21yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NDYxNDEsImV4cCI6MjA2MzMyMjE0MX0.nyUVXWRlFQcd8Nlp_3K4NXeUfCYROxIG6KJXL9-96Ls";

// Create Supabase client - use var to avoid redeclaration error with CDN's global supabase
if (!window.supabaseClient) {
    window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
}
var supabase = window.supabaseClient;

async function fetchReviews() {
    const { data, error } = await supabase
        .from('reviews')
        .select('id, company, website, reviewer_name, work_description, learning_value, atmosphere, would_recommend, tags, upvotes, created_at')
        .order('upvotes', { ascending: false })
        .order('created_at', { ascending: false });

    if (error) {
        console.error('Error fetching reviews:', error);
        return [];
    }

    return data;
}

// ... existing code ...

async function upvoteReview(reviewId) {
    const { data, error } = await supabase
        .rpc('increment_upvotes', { review_id: reviewId });
    
    if (error) {
        console.error('Error upvoting:', error);
        return;
    }
    
    // Refresh the page to show updated upvotes
    location.reload();
}
