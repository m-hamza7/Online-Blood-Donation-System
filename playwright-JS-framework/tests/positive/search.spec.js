import { test, expect } from '../../fixtures/test-fixtures.js';
import { loadTestData } from '../../utils/dataLoader.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';

const searchCases = loadTestData('positive-search.json');

test.describe('Positive - Donor Search @positive @search', () => {
  for (const data of searchCases) {
    test(`[${data.id}] ${data.title}`, async ({ searchPage, page }, testInfo) => {
      testInfo.annotations.push({ type: 'testId', description: data.id });

      await searchPage.open();
      await searchPage.search(data.search_by, data.search);

      await expect(searchPage.resultsHeading).toBeVisible();
      await expect(searchPage.resultsTable).toBeVisible();
      await expect(searchPage.resultsTable.locator('tbody tr').first()).toBeVisible();
      await captureScreenshot(page, data.id, testInfo);
    });
  }
});
