import { test, expect } from '../../fixtures/test-fixtures.js';
import { loadTestData } from '../../utils/dataLoader.js';
import stepWithScreenshot from '../../utils/stepHelper.js';

const navigationCases = loadTestData('positive-navigation.json');

test.describe('Positive - Public Navigation @positive @navigation', () => {
  for (const data of navigationCases) {
    test(`[${data.id}] ${data.title}`, async ({ page }, testInfo) => {
      testInfo.annotations.push({ type: 'testId', description: data.id });

      await stepWithScreenshot(`${data.id} - Navigate & validate`, page, testInfo, async () => {
        await page.goto(data.path);
        await expect(page.getByRole('heading', { name: new RegExp(data.expectedHeading, 'i') }).first()).toBeVisible();
      });
    });
  }
});
