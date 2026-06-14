import { test, expect } from '../../fixtures/test-fixtures.js';
import { loadTestData } from '../../utils/dataLoader.js';
import { captureScreenshot, acceptNextDialog } from '../../utils/screenshotHelper.js';

const registrationCases = loadTestData('negative-registration.json');

test.describe('Negative - User Registration @negative @registration', () => {
  for (const data of registrationCases) {
    test(`[${data.id}] ${data.title}`, async ({ registerPage, page }, testInfo) => {
      testInfo.annotations.push({ type: 'testId', description: data.id });
      await registerPage.open();

      if (data.validationType === 'html5') {
        acceptNextDialog(page);
        await registerPage.fillForm(data);
        await registerPage.submitButton.click();
        await expect(page).toHaveURL(/\/register/);
      } else if (data.expectedMessage) {
        await registerPage.register(data);
        //await expect(page.locator('[role="alert"]').filter({ hasText: data.expectedMessage })).toBeVisible();
        await expect(page).toHaveURL(/\/register/);
      }

      await captureScreenshot(page, data.id, testInfo);
    });
  }
});
