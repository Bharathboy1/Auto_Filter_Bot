#!/bin/bash

# ==========================================
# 🚀 Filmztube Bot Deployment Script
# ==========================================

# 1. Update and install basic dependencies
echo "🔄 Updating system and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip git nodejs npm

# 2. Install PM2 globally if not present
if ! command -v pm2 &> /dev/null
then
    echo "📦 PM2 not found, installing via npm..."
    sudo npm install -g pm2
fi

# 3. Setup project directory
cd "$(dirname "$0")"
mkdir -p logs

# 4. Create and use Virtual Environment
echo "🐍 Setting up Virtual Environment..."
python3 -m venv venv
source venv/bin/activate

# 5. Install Python requirements
echo "📦 Installing Python requirements inside venv..."
pip install --upgrade pip
pip install -r requirements.txt

# 6. Handle environment file check
if [ ! -f .env ]; then
    echo "⚠️ WARNING: .env file not found! Please create it before starting."
fi

# 7. Start the bot with PM2
echo "🚀 Starting bot with PM2..."
pm2 start ecosystem.config.js

# 8. Enable persistence
echo "💾 Saving PM2 process list and setting up startup..."
pm2 save
pm2 startup

echo "✅ Deployment complete! Check logs with: pm2 logs AutoFilterBot"
