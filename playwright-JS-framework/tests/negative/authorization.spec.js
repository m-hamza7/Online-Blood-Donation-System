import { test, expect } from '../../fixtures/test-fixtures.js';
import { loadTestData } from '../../utils/dataLoader.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';

const authCases = loadTestData('negative-authorization.json');

test.describe('Negative - Unauthorized Access @negative @authorization', () => {
  for (const data of authCases) {
    test(`[${data.id}] ${data.title}`, async ({ page }, testInfo) => {
      testInfo.annotations.push({ type: 'testId', description: data.id });

      await page.goto(data.path);
      await expect(page).toHaveURL(new RegExp(data.expectedUrlPattern));

      if (data.path.includes('donor_profile')) {
        //await expect(page.locator('[role="alert"]').filter({ hasText: /invalid username or password|unauthorized/i })).toBeVisible();
        await expect(page).toHaveURL(/\/login/);  
    }

      await captureScreenshot(page, data.id, testInfo);
    });
  }
});
