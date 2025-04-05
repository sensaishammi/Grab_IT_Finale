# Dashboard Application

A modern dashboard application with a Node.js/Express backend and a responsive frontend.

## Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or Atlas)

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file in the root directory with the following variables:
   ```
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/dashboard
   ```

## Running the Application

1. Start the backend server:
   ```bash
   npm start
   ```
   For development with auto-reload:
   ```bash
   npm run dev
   ```

2. Open `Dashboard.html` in your web browser

## API Endpoints

- `GET /api/dashboard/stats` - Get dashboard statistics
- `GET /api/dashboard/recent-sales` - Get recent sales data
- `GET /api/dashboard/overview` - Get overview chart data

## Features

- Real-time dashboard statistics
- Dark/Light mode toggle
- Responsive design
- Interactive charts
- Recent sales tracking 