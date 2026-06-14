import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * Captures a full-page screenshot and attaches it to Allure via testInfo when provided.
 */
export async function captureScreenshot(page, name, testInfo) {
  const dir = path.resolve(__dirname, '..', 'screenshots');
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  const safeName = name.replace(/[^a-zA-Z0-9-_]/g, '_');
  const filePath = path.join(dir, `${safeName}_${Date.now()}.png`);

  await page.screenshot({ path: filePath, fullPage: true });

  if (testInfo && typeof testInfo.attach === 'function') {
    await testInfo.attach(`screenshot-${safeName}`, {
      path: filePath,
      contentType: 'image/png',
    });
  }

  return filePath;
}

/**
 * Dismisses native alert dialogs triggered by HTML5 form validation on register page.
 */
export async function acceptNextDialog(page) {
  page.once('dialog', async (dialog) => {
    await dialog.accept();
  });
}

export default captureScreenshot;
