# Quick Setup Guide - Getting Your Google Cloud API Key

## Step-by-Step Instructions

### 1. Create/Access Google Cloud Account
- Go to https://console.cloud.google.com/
- Sign in with your Google account
- Accept the terms of service if this is your first time

### 2. Create or Select a Project
- Click the project dropdown at the top
- Click "New Project"
- Give it a name (e.g., "QR Menu Translation")
- Click "Create"

### 3. Enable Cloud Translation API
- Go to https://console.cloud.google.com/apis/library/translate.googleapis.com
- Click "Enable" button
- Wait for it to be enabled (takes a few seconds)

### 4. Create API Key
- Go to https://console.cloud.google.com/apis/credentials
- Click "+ CREATE CREDENTIALS" at the top
- Select "API key"
- A popup will show your new API key - **COPY IT NOW**

### 5. (Recommended) Restrict Your API Key
For security, restrict the key to only Cloud Translation API:
- Click "Edit API key" (or the pencil icon)
- Under "API restrictions":
  - Select "Restrict key"
  - Check only "Cloud Translation API"
- Click "Save"

### 6. Add API Key to Your Application
Open your `.env` file and update:
```bash
GOOGLE_CLOUD_API_KEY=YOUR_ACTUAL_API_KEY_HERE
```

Replace `YOUR_ACTUAL_API_KEY_HERE` with the key you copied.

### 7. Restart Your Rails Server
```bash
# Stop the server (Ctrl+C if running)
# Then restart:
bin/rails server
```

### 8. Test It!
Create a menu in English or Macedonian and watch it automatically translate!

## Free Tier Information
- **500,000 characters/month** for free
- That's approximately:
  - 2,500 menu items with name + description
  - Or 10,000 menu names only
- Characters are counted for translation input, not storage

## Monitoring Usage
Check your usage at:
https://console.cloud.google.com/apis/api/translate.googleapis.com/quotas

## Troubleshooting

### "API key not valid"
- Make sure you copied the entire key
- Check there are no extra spaces in the `.env` file
- Make sure the Cloud Translation API is enabled

### "Permission denied"
- The Cloud Translation API might not be enabled
- Check at: https://console.cloud.google.com/apis/library/translate.googleapis.com
- Click "ENABLE" if needed

### "Quota exceeded"
- You've used your free 500,000 characters this month
- Either wait until next month or upgrade to paid tier
- Check usage: https://console.cloud.google.com/apis/api/translate.googleapis.com/quotas

## Security Tips
1. **Never commit your API key to git**
   - The `.env` file is already in `.gitignore`
   - Double-check before pushing code

2. **Restrict your API key**
   - Limit it to only Cloud Translation API
   - Add application restrictions if deploying to production

3. **Rotate keys periodically**
   - Create a new key every few months
   - Delete old unused keys

## What's Next?
Once you add your real API key, the translation system will work automatically:
- Create menus in English → auto-translates to Macedonian
- Create menus in Macedonian → auto-translates to English
- Switch languages in the navbar to see translations
