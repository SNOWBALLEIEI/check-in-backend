const router = require('express').Router()
const pool   = require('../db/connection')

// GET /api/houses  –  all houses with their members
router.get('/', async (req, res) => {
  try {
    const [houses]  = await pool.query('SELECT * FROM houses ORDER BY id')
    const [members] = await pool.query(
      'SELECT * FROM members ORDER BY house_id, order_index'
    )

    const result = houses.map(house => ({
      id:      house.id,
      name:    house.name,
      members: members
        .filter(m => m.house_id === house.id)
        .map(m => m.name),
    }))

    res.json(result)
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Database error' })
  }
})

module.exports = router
