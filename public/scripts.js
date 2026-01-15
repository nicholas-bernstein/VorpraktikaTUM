const SUPABASE_URL = "https://fqsuegrrtmazhgjhvsmr.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxc3VlZ3JydG1hemhnamh2c21yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NDYxNDEsImV4cCI6MjA2MzMyMjE0MX0.nyUVXWRlFQcd8Nlp_3K4NXeUfCYROxIG6KJXL9-96Ls";

const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

async function fetchReviews() {
    const { data, error } = await supabase
        .from('reviews')
        .select('id, company, website, reviewer_name, work_description, learning_value, atmosphere, would_recommend, tags, upvotes, created_at')
        .order('upvotes', { ascending: false })
        .order('created_at', { ascending: false });

    if (error) {
        console.error('Error fetching reviews:', error);
        // Show error in page so you can see it
        const container = document.querySelector('.subcontainer');
        if (container) {
            container.innerHTML = `<div style="padding: 20px; background: #ffebee; border: 2px solid red; margin: 20px;">
                <h2>Error Loading Reviews</h2>
                <p><strong>Error:</strong> ${error.message}</p>
                <p><strong>Details:</strong></p>
                <pre>${JSON.stringify(error, null, 2)}</pre>
            </div>`;
        }
        return [];
    }

    console.log('Successfully fetched reviews:', data?.length || 0);
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
