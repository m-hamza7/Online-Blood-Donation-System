import { test as base, expect } from '@playwright/test';
import { HomePage, AboutPage } from '../pages/HomePage.js';
import { LoginPage } from '../pages/LoginPage.js';
import { RegisterPage } from '../pages/RegisterPage.js';
import { AdminLoginPage } from '../pages/AdminLoginPage.js';
import { DonorProfilePage } from '../pages/DonorProfilePage.js';
import { HospitalDashboardPage } from '../pages/HospitalDashboardPage.js';
import { AdminDashboardPage } from '../pages/AdminDashboardPage.js';
import { SearchPage } from '../pages/SearchPage.js';
import { captureScreenshot } from '../utils/screenshotHelper.js';
import { credentials, uniqueEmail, uniqueUsername } from '../utils/testDataGenerator.js';
import '../tests/hooks/global-hooks.js';

export const test = base.extend({
  homePage: async ({ page }, use) => {
    await use(new HomePage(page));
  },
  aboutPage: async ({ page }, use) => {
    await use(new AboutPage(page));
  },
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },
  registerPage: async ({ page }, use) => {
    await use(new RegisterPage(page));
  },
  adminLoginPage: async ({ page }, use) => {
    await use(new AdminLoginPage(page));
  },
  donorProfilePage: async ({ page }, use) => {
    await use(new DonorProfilePage(page));
  },
  hospitalDashboardPage: async ({ page }, use) => {
    await use(new HospitalDashboardPage(page));
  },
  adminDashboardPage: async ({ page }, use) => {
    await use(new AdminDashboardPage(page));
  },
  searchPage: async ({ page }, use) => {
    await use(new SearchPage(page));
  },
  registerAndLoginDonor: async ({ page, registerPage, loginPage }, use) => {
    const registerDonor = async () => {
      const username = uniqueUsername('donor');
      const password = 'TestPass123';
      const data = {
        username,
        email: uniqueEmail('donor'),
        password,
        role: 'Donor',
        name: 'Auto Donor Test',
        contact_info: '0300123456',
        blood_type: 'A+',
        city: 'Karachi',
        state: 'Sindh',
        zip_code: '753000',
      };

      await registerPage.open();
      await registerPage.register(data);
      await expect(page).toHaveURL(/\/login/, { timeout: 15_000 });
      await loginPage.login(username, password);
      await expect(page).toHaveURL(/\/donor_profile/);

      return { username, password };
    };

    await use(registerDonor);
  },
  loginAsAdmin: async ({ page, adminLoginPage }, use) => {
    const loginAdmin = async () => {
      await adminLoginPage.open();
      await adminLoginPage.login(credentials.adminUsername, credentials.adminPassword);
      await expect(page).toHaveURL(/\/admin_dashboard/);
    };
    await use(loginAdmin);
  },
});

export { expect };

test.beforeEach(async ({ page }, testInfo) => {
  testInfo.annotations.push({
    type: 'baseURL',
    description: process.env.BASE_URL || 'http://127.0.0.1:5000',
  });
});

test.afterEach(async ({ page }, testInfo) => {
  if (testInfo.status !== testInfo.expectedStatus) {
    await captureScreenshot(page, `failure-${testInfo.title}`, testInfo);
  } else if (process.env.SCREENSHOT_ALL === 'true') {
    await captureScreenshot(page, `pass-${testInfo.title}`, testInfo);
  }
});
