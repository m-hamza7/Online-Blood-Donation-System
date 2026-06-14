import { test, expect } from '../../fixtures/test-fixtures.js';
import { loadTestData } from '../../utils/dataLoader.js';
import { uniqueEmail, uniqueUsername } from '../../utils/testDataGenerator.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';
const registrationCases = loadTestData('positive-registration.json');

function resolveRegistrationData(data) {
  return {
    ...data,
    username: data.username === '__UNIQUE__' ? uniqueUsername('pos') : data.username,
    email: data.email === '__UNIQUE_EMAIL__' ? uniqueEmail('pos') : data.email,
  };
}

test.describe('Positive - User Registration @positive @registration', () => {
  for (const raw of registrationCases) {
    test(`[${raw.id}] ${raw.title}`, async ({ registerPage, page }, testInfo) => {
      const data = resolveRegistrationData(raw);
      testInfo.annotations.push({ type: 'testId', description: raw.id });

      await registerPage.open();
      await registerPage.register(data);

      await expect(page).toHaveURL(/\/login/, { timeout: 15_000 });
      await captureScreenshot(page, raw.id, testInfo);
    });
  }
});
