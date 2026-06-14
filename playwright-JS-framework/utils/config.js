import path from 'path';
import fs from 'fs';

/**
 * Simple configuration reader that uses environment variables with sane defaults.
 * Keeps config access centralized for tests and utilities.
 */
export function getConfig() {
  const baseURL = process.env.BASE_URL || 'http://127.0.0.1:5000';
  const adminUsername = process.env.ADMIN_USERNAME || 'admin';
  const adminPassword = process.env.ADMIN_PASSWORD || 'admin';
  const screenshotAll = (process.env.SCREENSHOT_ALL || 'false').toLowerCase() === 'true';

  return { baseURL, adminUsername, adminPassword, screenshotAll };
}

/**
 * Optional helper to write a local .env file (used rarely in CI-light workflows).
 */
export function writeEnvFileIfMissing(targetDir = process.cwd()) {
  const envPath = path.resolve(targetDir, '.env');
  if (!fs.existsSync(envPath)) {
    const example = `# Local environment for Playwright tests\nBASE_URL=${getConfig().baseURL}\n`;
    fs.writeFileSync(envPath, example, 'utf-8');
  }
}

export default getConfig;
