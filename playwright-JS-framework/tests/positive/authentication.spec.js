import { test, expect } from '../../fixtures/test-fixtures.js';
import { credentials } from '../../utils/testDataGenerator.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';
import { uniqueEmail, uniqueUsername } from '../../utils/testDataGenerator.js';

test.describe('Positive - Authentication @positive @auth', () => {
  test('[POS-AUTH-001] Admin login with valid credentials redirects to admin dashboard', async ({
    adminLoginPage,
    adminDashboardPage,
    page,
  }, testInfo) => {
    await adminLoginPage.open();
    await adminLoginPage.login(credentials.adminUsername, credentials.adminPassword);
    await expect(page).toHaveURL(/\/admin_dashboard/);
    await expect(adminDashboardPage.dashboardHeading).toBeVisible();
    await captureScreenshot(page, 'POS-AUTH-001', testInfo);
  });

  test('[POS-AUTH-002] New donor registration and login redirects to donor profile', async ({
    registerPage,
    loginPage,
    donorProfilePage,
    page,
  }, testInfo) => {
    const username = uniqueUsername('donorlogin');
    const password = 'DonorLogin123';

    await registerPage.open();
    await registerPage.register({
      username,
      email: uniqueEmail('donorlogin'),
      password,
      role: 'Donor',
      name: 'Donor Login Test',
      contact_info: '0300999888',
      blood_type: 'B+',
      city: 'Karachi',
      state: 'Sindh',
      zip_code: '753000',
    });

    await expect(page).toHaveURL(/\/login/, { timeout: 15_000 });
    await loginPage.login(username, password);
    await expect(page).toHaveURL(/\/donor_profile/);
    await expect(donorProfilePage.welcomeHeader).toBeVisible();
    await captureScreenshot(page, 'POS-AUTH-002', testInfo);
  });

  test('[POS-AUTH-003] New hospital registration and login redirects to hospital dashboard', async ({
    registerPage,
    loginPage,
    hospitalDashboardPage,
    page,
  }, testInfo) => {
    const username = uniqueUsername('hosplogin');
    const password = 'HospitalLogin123';

    await registerPage.open();
    await registerPage.register({
      username,
      email: uniqueEmail('hosplogin'),
      password,
      role: 'Hospital',
      name: 'Hospital Login Test',
      contact_info: '0300777666',
      city: 'Karachi',
      state: 'Sindh',
      zip_code: '753002',
    });

    await expect(page).toHaveURL(/\/login/, { timeout: 15_000 });
    await loginPage.login(username, password);
    await expect(page).toHaveURL(/\/hospital_dashboard/);
    await expect(hospitalDashboardPage.dashboardHeading).toBeVisible();
    await captureScreenshot(page, 'POS-AUTH-003', testInfo);
  });

});
