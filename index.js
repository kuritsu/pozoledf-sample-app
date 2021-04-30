const express = require('express')
const app = express()
const port = 3000

app.get('/health', (req, res) => {
  res.send('OK guys!')
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})