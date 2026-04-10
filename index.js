require('dotenv').config()
const express    = require('express')
const cors       = require('cors')

const housesRouter     = require('./routes/houses')
const attendanceRouter = require('./routes/attendance')
const practiceRouter   = require('./routes/practice')

const app = express()

// ── Middleware ────────────────────────────────────────────────
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  methods: ['GET', 'POST', 'DELETE'],
}))
app.use(express.json())

// ── Routes ────────────────────────────────────────────────────
app.use('/api/houses',     housesRouter)
app.use('/api/attendance', attendanceRouter)
app.use('/api/practice',   practiceRouter)

app.get('/api/health', (_req, res) => res.json({ status: 'ok' }))

// ── Start ─────────────────────────────────────────────────────
const PORT = process.env.PORT || 5000
app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`)
})
