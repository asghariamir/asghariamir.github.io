// Simple in-memory counter (resets on deploy)
let count = 0;

export default function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  // Handle preflight
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  // Handle GET
  if (req.method === 'GET') {
    return res.status(200).json({ 
      count: count,
      message: 'Current count'
    });
  }
  
  // Handle POST
  if (req.method === 'POST') {
    count++;
    return res.status(200).json({ 
      count: count,
      message: 'Count incremented'
    });
  }
  
  // Method not allowed
  return res.status(405).json({ 
    error: 'Method not allowed'
  });
}
