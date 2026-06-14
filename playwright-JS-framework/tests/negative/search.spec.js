import { test, expect } from '../../fixtures/test-fixtures.js';
import { loadTestData } from '../../utils/dataLoader.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';

const searchCases = loadTestData('negative-search.json');

test.describe('Negative - Donor Search @negative @search', () => {
  for (const data of searchCases) {
    test(`[${data.id}] ${data.title}`, async ({ searchPage, page }, testInfo) => {
      testInfo.annotations.push({ type: 'testId', description: data.id });
      await searchPage.open();

      if (data.validationType === 'html5') {
        await searchPage.searchBySelect.selectOption(data.search_by);
        await searchPage.searchButton.click();
        const isInvalid = await searchPage.searchInput.evaluate((el) => !el.checkValidity());
        expect(isInvalid).toBeTruthy();
        await expect(page).toHaveURL(/\/search/);
      } else {
        await searchPage.search(data.search_by, data.search);
        await expect(searchPage.resultsHeading).toHaveCount(0);
        await expect(searchPage.resultsTable).toHaveCount(0);
      }

      await captureScreenshot(page, data.id, testInfo);
    });
  }
});
