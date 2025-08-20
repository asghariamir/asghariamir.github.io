module.exports = (req, res) => {
  res.status(200).json({ 
    message: 'API root working!',
    endpoints: ['/api/test', '/api/visitor-count']
  });
};
