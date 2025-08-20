export default function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  
  res.status(200).json({ 
    success: true,
    message: 'API is working!',
    timestamp: new Date().toISOString(),
    method: req.method
  });
}
