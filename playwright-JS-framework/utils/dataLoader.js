import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * Loads JSON test data from the test-data directory.
 */
export function loadTestData(fileName) {
  const filePath = path.resolve(__dirname, '..', 'test-data', fileName);
  const raw = fs.readFileSync(filePath, 'utf-8');
  return JSON.parse(raw);
}

// Type definitions from TS were removed; consumers should treat returned objects accordingly.
export default loadTestData;
