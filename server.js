const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public')); // Serve static files

// Database connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/dashboard')
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('MongoDB connection error:', err));

// Routes
app.get('/api/dashboard/stats', async (req, res) => {
  try {
    const stats = {
      totalRevenue: 45231,
      subscriptions: 2350,
      sales: 12234,
      activeUsers: 573
    };
    res.json(stats);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/api/dashboard/recent-sales', async (req, res) => {
  try {
    const recentSales = [
      { name: 'Olivia Martin', amount: 1999.00 },
      { name: 'Jackson Lee', amount: 39.00 },
      { name: 'Isabella Nguyen', amount: 299.00 },
      { name: 'William Kim', amount: 99.00 },
      { name: 'Sofia Davis', amount: 39.00 }
    ];
    res.json(recentSales);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.get('/api/dashboard/overview', async (req, res) => {
  try {
    const overviewData = [120, 50, 140, 140, 40, 90, 170, 100, 180, 130, 70, 90];
    res.json(overviewData);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
}); 