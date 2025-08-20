import { put, get, list } from '@vercel/blob';

const COUNTER_KEY = 'visitor-counter.txt';

export default async function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  try {
    let currentCount = 0;
    
    // Try to get the current count
    try {
      // List all blobs to find our counter
      const { blobs } = await list({
        prefix: 'visitor-counter',
        limit: 1
      });
      
      if (blobs.length > 0) {
        // Fetch the current count
        const response = await fetch(blobs[0].url);
        const text = await response.text();
        currentCount = parseInt(text) || 0;
      }
    } catch (error) {
      console.log('Counter not found, starting at 0');
    }
    
    if (req.method === 'POST') {
      // Increment counter
      currentCount++;
      
      // Save the new count (overwrite the file)
      const blob = await put(COUNTER_KEY, String(currentCount), {
        access: 'public',
        addRandomSuffix: false, // Important: keep the same filename
        contentType: 'text/plain',
      });
      
      console.log('Counter updated to:', currentCount);
      return res.status(200).json({ count: currentCount });
      
    } else if (req.method === 'GET') {
      // Just return current count without incrementing
      return res.status(200).json({ count: currentCount });
    }
    
    return res.status(405).json({ error: 'Method not allowed' });
    
  } catch (error) {
    console.error('Blob Storage Error:', error);
    return res.status(500).json({ 
      error: 'Failed to access counter',
      details: error.message 
    });
  }
}
