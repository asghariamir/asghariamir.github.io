export default function handler(req, res) {
  res.status(200).json({
    message: 'API root is working',
    availableEndpoints: [
      '/api/test',
      '/api/visitor-count'
    ]
  });
}
