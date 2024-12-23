import { app, shell, BrowserWindow, ipcMain  } from 'electron'
import { join } from 'path'
import { electronApp, optimizer, is } from '@electron-toolkit/utils'
import icon from '../../resources/icon.png?asset'
import { setupDatabaseHandlers } from './database'
import { setupPlayerServiceHandlers } from './ipc/playerService'; 
import { setupStandardServiceHandlers } from './ipc/standardService';
import { setupFintualServiceHandlers } from './ipc/fintualService';
import { setupProfileServiceHandlers } from './ipc/profileService';
import { setupSensorServiceHandlers } from './ipc/sensorService';

// Configurar los handlers de SQLite
setupDatabaseHandlers()

// Configurar los handlers
setupPlayerServiceHandlers();
setupStandardServiceHandlers();
setupFintualServiceHandlers();
setupProfileServiceHandlers();
setupSensorServiceHandlers();

function createWindow() {
  const mainWindow = new BrowserWindow({
    show: false,
    autoHideMenuBar: true,
    fullscreenable: true,
    ...(process.platform === 'linux' ? { icon } : {}),
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true, 
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false, 
      nodeIntegration: true, 
      contextIsolation: false
    }
  })

  mainWindow.once('ready-to-show', () => {
    mainWindow.maximize()
    mainWindow.show()
  })

  mainWindow.webContents.setWindowOpenHandler((details) => {
    shell.openExternal(details.url)
    return { action: 'deny' }
  })

  if (is.dev && process.env['ELECTRON_RENDERER_URL']) {
    mainWindow.loadURL(process.env['ELECTRON_RENDERER_URL'])
  } else {
    mainWindow.loadFile(join(__dirname, '../renderer/index.html'))
  }
}

app.whenReady().then(() => {
  electronApp.setAppUserModelId('com.electron')
  app.on('browser-window-created', (_, window) => {
    optimizer.watchWindowShortcuts(window)
  })

  createWindow()

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})