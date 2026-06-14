import { test, expect } from '../../fixtures/test-fixtures.js';
import { loadTestData } from '../../utils/dataLoader.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';

const adminCases = loadTestData('negative-admin-login.json');

test.describe('Negative - Admin Login @negative @admin', () => {
  for (const data of adminCases) {
    test(`[${data.id}] ${data.title}`, async ({ adminLoginPage, page }, testInfo) => {
      testInfo.annotations.push({ type: 'testId', description: data.id });
      await adminLoginPage.open();

      if (data.validationType === 'html5') {
        await adminLoginPage.loginButton.click();
        const usernameInvalid = await adminLoginPage.usernameInput.evaluate((el) => !el.checkValidity());
        expect(usernameInvalid).toBeTruthy();
        await expect(page).toHaveURL(/\/admin/);
      } else {
        // Attach a one-time dialog handler in case the app uses a native alert
        if (data.expectedMessage) {
          page.once('dialog', async (dialog) => {
            try {
              expect(dialog.message()).toContain(data.expectedMessage);
            } finally {
              await dialog.dismiss();
            }
          });
        }

        await adminLoginPage.login(data.username, data.password);
        await expect(page).toHaveURL(/\/admin/);

        if (data.expectedMessage) {
          const alertLocator = page.locator('div.alert[role="alert"]').filter({ hasText: data.expectedMessage });
          await expect(alertLocator).toBeVisible({ timeout: 10000 });
          await expect(alertLocator).toContainText(data.expectedMessage, { timeout: 10000 });
        }
      }

      await captureScreenshot(page, data.id, testInfo);
    });
  }
});
