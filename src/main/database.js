import sqlite3 from 'sqlite3'
import { join } from 'path'
import { app, ipcMain } from 'electron'

const dbPath = join(app.getPath('userData'), 'database.db')

// Inicializar la conexión a SQLite
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error al conectar con SQLite:', err.message)
  } else {
    console.log('Conexión exitosa a SQLite.')
  }
})

// Crear tablas si no existen
db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS playerStorage (
      id_players INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      age INTEGER NOT NULL
    )
  `)
})

// Función para ejecutar INSERT/UPDATE/DELETE
const runQuery = (query, params = []) => {
  return new Promise((resolve, reject) => {
    db.run(query, params, function (err) {
      if (err) reject(err)
      else resolve({ lastID: this.lastID, changes: this.changes })
    })
  })
}

// Función para obtener un solo registro
const getQuery = (query, params = []) => {
  return new Promise((resolve, reject) => {
    db.get(query, params, (err, row) => {
      if (err) reject(err)
      else resolve(row)
    })
  })
}

// Configurar IPC handlers relacionados con SQLite
export const setupDatabaseHandlers = () => {
  ipcMain.handle('save-player', async (_, player) => {
    const { id_players, name, email, password, age } = player
    const query = `
      INSERT INTO playerStorage (id_players, name, email, password, age)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(id_players) DO UPDATE SET
      name = excluded.name,
      email = excluded.email,
      password = excluded.password,
      age = excluded.age;
    `
    return await runQuery(query, [id_players, name, email, password, age])
  })

  ipcMain.handle('get-player', async () => {
    return await getQuery('SELECT * FROM playerStorage LIMIT 1')
  })

  ipcMain.handle('delete-player', async () => {
    return await runQuery('DELETE FROM playerStorage')
  })
}

console.log('Database handlers and table initialized.')
