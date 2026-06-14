import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const logsDir = path.resolve(__dirname, '..', 'logs');
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

function writeLog(level, message) {
  const line = `${new Date().toISOString()} [${level}] ${message}\n`;
  const file = path.join(logsDir, `${new Date().toISOString().slice(0, 10)}.log`);
  try {
    fs.appendFileSync(file, line);
  } catch (e) {
    console.error('Failed to write log:', e);
  }
}

export const logger = {
  info: (msg) => {
    console.log(`INFO: ${msg}`);
    writeLog('INFO', msg);
  },
  warn: (msg) => {
    console.warn(`WARN: ${msg}`);
    writeLog('WARN', msg);
  },
  error: (msg) => {
    console.error(`ERROR: ${msg}`);
    writeLog('ERROR', msg);
  },
};

export default logger;
