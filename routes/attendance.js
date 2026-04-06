const router = require('express').Router()
const pool   = require('../db/connection')

// GET /api/attendance/history  –  all records newest-first
router.get('/history', async (req, res) => {
  try {
    const [records] = await pool.query(
      'SELECT * FROM attendance_records ORDER BY created_at DESC'
    )
    const [details] = await pool.query(
      'SELECT * FROM attendance_details ORDER BY id'
    )

    const result = records.map(record => ({
      id:          record.id,
      timestamp:   record.created_at,
      houseId:     record.house_id,
      houseName:   record.house_name,
      airdropType: record.airdrop_type,
      present:     record.present_count,
      leave:       record.leave_count,
      absent:      record.absent_count,
      members:     details
        .filter(d => d.record_id === record.id)
        .map(d => ({ name: d.member_name, status: d.status })),
    }))

    res.json(result)
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Database error' })
  }
})

// POST /api/attendance  –  save one attendance record
router.post('/', async (req, res) => {
  const {
    id, houseId, houseName, airdropType,
    members, present, leave, absent, timestamp,
  } = req.body

  if (!id || !houseId || !houseName || !airdropType || !Array.isArray(members)) {
    return res.status(400).json({ error: 'Missing required fields' })
  }

  const conn = await pool.getConnection()
  try {
    await conn.beginTransaction()

    await conn.query(
      `INSERT INTO attendance_records
         (id, house_id, house_name, airdrop_type, present_count, leave_count, absent_count, created_at)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        id, houseId, houseName, airdropType,
        present || 0, leave || 0, absent || 0,
        timestamp ? new Date(timestamp) : new Date(),
      ]
    )

    for (const member of members) {
      await conn.query(
        'INSERT INTO attendance_details (record_id, member_name, status) VALUES (?, ?, ?)',
        [id, member.name, member.status || null]
      )
    }

    await conn.commit()
    res.status(201).json({ message: 'Saved', id })
  } catch (err) {
    await conn.rollback()
    console.error(err)
    res.status(500).json({ error: 'Database error' })
  } finally {
    conn.release()
  }
})

// DELETE /api/attendance/:id  –  remove a record
router.delete('/:id', async (req, res) => {
  const conn = await pool.getConnection()
  try {
    await conn.beginTransaction()
    await conn.query('DELETE FROM attendance_details WHERE record_id = ?',  [req.params.id])
    await conn.query('DELETE FROM attendance_records  WHERE id = ?',         [req.params.id])
    await conn.commit()
    res.json({ message: 'Deleted' })
  } catch (err) {
    await conn.rollback()
    console.error(err)
    res.status(500).json({ error: 'Database error' })
  } finally {
    conn.release()
  }
})

module.exports = router
