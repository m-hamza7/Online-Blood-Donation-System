import { test, expect } from '../../fixtures/test-fixtures.js';
import { loadTestData } from '../../utils/dataLoader.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';

const loginCases = loadTestData('negative-login.json');

test.describe('Negative - User Login @negative @login', () => {
  for (const data of loginCases) {
    test(`[${data.id}] ${data.title}`, async ({ loginPage, page }, testInfo) => {
      testInfo.annotations.push({ type: 'testId', description: data.id });
      await loginPage.open();

      if (data.validationType === 'html5' && data.username === '') {
        await loginPage.passwordInput.fill(data.password);
        await loginPage.loginButton.click();
        await expect(loginPage.usernameInput).toBeVisible();
        const isInvalid = await loginPage.usernameInput.evaluate((el) => !el.checkValidity());
        expect(isInvalid).toBeTruthy();
        await expect(page).toHaveURL(/\/login/);
      } else if (data.validationType === 'html5' && data.password === '') {
        await loginPage.usernameInput.fill(data.username);
        await loginPage.loginButton.click();
        const isInvalid = await loginPage.passwordInput.evaluate((el) => !el.checkValidity());
        expect(isInvalid).toBeTruthy();
        await expect(page).toHaveURL(/\/login/);
      } else {
        await loginPage.login(data.username, data.password);
        await expect(page).toHaveURL(/\/login/);
        await expect(page).toHaveURL(/\/login/);
      }

      await captureScreenshot(page, data.id, testInfo);
    });
  }
});
