import { test, expect } from '../../fixtures/test-fixtures.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';
import { uniqueEmail, uniqueUsername } from '../../utils/testDataGenerator.js';

async function registerAndLoginHospital(registerPage, loginPage, page) {
  const username = uniqueUsername('hospitalfeat');
  const password = 'HospitalFeat123';

  await registerPage.open();
  await registerPage.register({
    username,
    email: uniqueEmail('hospitalfeat'),
    password,
    role: 'Hospital',
    name: 'Hospital Feature Test',
    contact_info: '0300555444',
    city: 'Karachi',
    state: 'Sindh',
    zip_code: '753003',
  });

  await expect(page).toHaveURL(/\/login/, { timeout: 15_000 });
  await loginPage.login(username, password);
  await expect(page).toHaveURL(/\/hospital_dashboard/);
}

test.describe('Positive - Hospital Dashboard Features @positive @hospital', () => {
  test.beforeEach(async ({ registerPage, loginPage, page }) => {
    await registerAndLoginHospital(registerPage, loginPage, page);
  });

  test('[POS-HOSP-001] Hospital dashboard shows blood request form', async ({
    hospitalDashboardPage,
    page,
  }, testInfo) => {
    await hospitalDashboardPage.open();
    await expect(hospitalDashboardPage.bloodRequestHeading).toBeVisible();
    await expect(hospitalDashboardPage.bloodTypeSelect).toBeVisible();
    await expect(hospitalDashboardPage.quantityInput).toBeVisible();
    await captureScreenshot(page, 'POS-HOSP-001', testInfo);
  });

  test('[POS-HOSP-002] Hospital can view profile page', async ({ hospitalDashboardPage, page }, testInfo) => {
    await hospitalDashboardPage.openProfile();
    await expect(hospitalDashboardPage.profileHeading).toBeVisible();
    await captureScreenshot(page, 'POS-HOSP-002', testInfo);
  });

  test('[POS-HOSP-003] Hospital can submit a new blood request', async ({
    hospitalDashboardPage,
    page,
  }, testInfo) => {
    await hospitalDashboardPage.open();
    await hospitalDashboardPage.submitBloodRequest('A+', '5');
    await expect(hospitalDashboardPage.existingRequestsHeading).toBeVisible();
    await expect(page.locator('table').filter({ hasText: 'A+' }).first()).toBeVisible();
    await captureScreenshot(page, 'POS-HOSP-003', testInfo);
  });
});
