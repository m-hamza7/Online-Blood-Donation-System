import { test, expect } from '../../fixtures/test-fixtures.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';

test.describe('Positive - Admin Dashboard Views @positive @admin', () => {
  test.beforeEach(async ({ loginAsAdmin }) => {
    await loginAsAdmin();
  });

  test('[POS-ADMIN-001] Admin dashboard displays active users view', async ({
    adminDashboardPage,
    page,
  }, testInfo) => {
    await adminDashboardPage.openActiveUsers();
    await expect(adminDashboardPage.getSectionHeading(/Active Users/i)).toBeVisible();
    await expect(adminDashboardPage.getUsersTable()).toBeVisible();
    await captureScreenshot(page, 'POS-ADMIN-001', testInfo);
  });

  test('[POS-ADMIN-002] Admin dashboard displays blood requests view', async ({
    adminDashboardPage,
    page,
  }, testInfo) => {
    await adminDashboardPage.open('blood_requests');
    await expect(adminDashboardPage.getSectionHeading(/All Blood Requests/i)).toBeVisible();
    await expect(page.locator('table').first()).toBeVisible();
    await captureScreenshot(page, 'POS-ADMIN-002', testInfo);
  });

});
