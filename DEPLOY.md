# Quick Deploy to Fly.io

## Prerequisites ✅

- Fly CLI installed (you have this already!)
- Logged in: `flyctl auth login`

## Deploy in 5 Steps

### 1️⃣ Launch App

```bash
flyctl launch --no-deploy
```

When prompted:
- App name: `artifact-demo` (or your choice)
- Region: `sjc` (San Jose) or your preference
- Don't deploy yet: **No**

### 2️⃣ Create Volume (for SQLite persistence)

```bash
flyctl volumes create artifact_demo_data --region sjc --size 1
```

### 3️⃣ Set Secrets

```bash
flyctl secrets set SECRET_KEY_BASE=$(openssl rand -hex 64)
```

### 4️⃣ Deploy! 🚀

```bash
flyctl deploy
```

This will:
- Build Docker image
- Compile SCSS with Dart Sass
- Precompile assets (CSS, JS)
- Deploy to Fly.io
- Run database migrations

Takes ~2-3 minutes for first deploy.

### 5️⃣ Open Your App

```bash
flyctl apps open
```

## Verify Assets Are Working

Visit your app and check:
1. Page loads with styling
2. Open DevTools → Network
3. Look for `application-[hash].css` and `application-[hash].js`
4. Both should return `200 OK`

## Test Build Locally (Optional)

Before deploying, test asset compilation:

```bash
./bin/test-build
```

This verifies:
- SCSS compiles correctly
- Assets precompile successfully  
- Docker builds without errors

## Useful Commands

```bash
# View logs
flyctl logs

# SSH to machine
flyctl ssh console

# Rails console
flyctl ssh console -C 'bin/rails console'

# Restart app
flyctl apps restart

# Check status
flyctl status

# Scale resources
flyctl scale memory 1024

# Re-deploy (after changes)
flyctl deploy
```

## Asset Pipeline Flow

**During Docker Build:**
1. Install gems (including `dartsass-rails`)
2. Copy app code
3. Run `rails assets:precompile`
   - Compiles SCSS → CSS
   - Fingerprints all assets
   - Copies to `public/assets/`
4. Assets baked into Docker image

**In Production:**
- Thruster serves static assets
- No runtime compilation needed
- Assets cached for 1 year (fingerprinted filenames)

## Troubleshooting

### Assets Not Loading?

```bash
# Check if assets exist in image
flyctl ssh console
$ ls -la public/assets/
$ ls -la app/assets/builds/
```

### Build Fails?

```bash
# Test locally first
./bin/test-build

# Check Fly logs
flyctl logs
```

### App Won't Start?

```bash
# Check secrets are set
flyctl secrets list

# View detailed logs
flyctl logs --app artifact-demo
```

## Cost

With default config:
- **0 machines when idle** (auto-stop)
- **Starts on traffic** (auto-start)
- **~$0-2/month** (just volume storage)

Free tier includes:
- 3 shared-cpu machines with 256MB
- 3GB volume storage
- 160GB transfer

## Files Created

- `fly.toml` - Fly.io configuration
- `Dockerfile` - Multi-stage build (production stage used)
- `.dockerignore` - Optimize build size
- `bin/fly-deploy` - Helper script
- `bin/test-build` - Test assets locally

## Architecture

```
┌─────────────────────────────────────────┐
│  Fly.io Machine                         │
│                                         │
│  ┌────────────────────────────────┐    │
│  │  Thruster (HTTP/2 Server)      │    │
│  │  ├─ Static assets (public/)    │    │
│  │  └─ Proxies to Rails           │    │
│  └────────────────────────────────┘    │
│                                         │
│  ┌────────────────────────────────┐    │
│  │  Rails App                      │    │
│  │  (Puma server)                  │    │
│  └────────────────────────────────┘    │
│                                         │
│  ┌────────────────────────────────┐    │
│  │  SQLite Databases (volume)      │    │
│  │  /app/storage/                  │    │
│  │  ├─ production.sqlite3          │    │
│  │  ├─ production_cache.sqlite3    │    │
│  │  ├─ production_queue.sqlite3    │    │
│  │  └─ production_cable.sqlite3    │    │
│  └────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

## Next Steps

After deploying:

1. **Custom Domain** (optional):
   ```bash
   flyctl certs create yourdomain.com
   ```

2. **Environment Variables**:
   ```bash
   flyctl secrets set KEY=value
   ```

3. **Monitoring**: Set up [Fly.io Metrics](https://fly.io/docs/metrics-and-logs/)

4. **Backups**: Regular SQLite backups via `flyctl ssh sftp`

## More Info

- Full guide: `FLY_DEPLOYMENT.md`
- Asset pipeline: `ASSET_PIPELINE.md`
- Fly.io docs: https://fly.io/docs/rails/

