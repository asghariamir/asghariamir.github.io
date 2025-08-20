import { put, list } from '@vercel/blob';

const COUNTER_FILENAME = 'visitor-stats.json';

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  try {
    let stats = {
      count: 0,
      lastUpdated: null,
      dailyStats: {}
    };
    
    // Try to get existing stats
    try {
      const { blobs } = await list({
        prefix: 'visitor-stats',
        limit: 1
      });
      
      if (blobs.length > 0) {
        const response = await fetch(blobs[0].url);
        stats = await response.json();
      }
    } catch (error) {
      console.log('Creating new stats file');
    }
    
    if (req.method === 'POST') {
      // Increment counter
      stats.count++;
      stats.lastUpdated = new Date().toISOString();
      
      // Track daily stats
      const today = new Date().toISOString().split('T')[0];
      stats.dailyStats[today] = (stats.dailyStats[today] || 0) + 1;
      
      // Save updated stats
      await put(COUNTER_FILENAME, JSON.stringify(stats, null, 2), {
        access: 'public',
        addRandomSuffix: false,
        contentType: 'application/json',
      });
      
      return res.status(200).json({ 
        count: stats.count,
        todayCount: stats.dailyStats[today]
      });
      
    } else if (req.method === 'GET') {
      const today = new Date().toISOString().split('T')[0];
      return res.status(200).json({ 
        count: stats.count,
        todayCount: stats.dailyStats[today] || 0
      });
    }
    
    return res.status(405).json({ error: 'Method not allowed' });
    
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Server error' });
  }
}
