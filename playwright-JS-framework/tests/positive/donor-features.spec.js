import { test, expect } from '../../fixtures/test-fixtures.js';
import { captureScreenshot } from '../../utils/screenshotHelper.js';

test.describe('Positive - Donor Profile Features @positive @donor', () => {
  test.beforeEach(async ({ registerAndLoginDonor }) => {
    await registerAndLoginDonor();
  });

  test('[POS-DONOR-001] Donor dashboard shows welcome header and blood requests section', async ({
    donorProfilePage,
    page,
  }, testInfo) => {
    await donorProfilePage.open();
    await expect(donorProfilePage.welcomeHeader).toBeVisible();
    await expect(donorProfilePage.bloodRequestsHeading).toBeVisible();
    await captureScreenshot(page, 'POS-DONOR-001', testInfo);
  });

  test('[POS-DONOR-002] Donor can view profile details page', async ({ donorProfilePage, page }, testInfo) => {
    await donorProfilePage.openViewProfile();
    await expect(donorProfilePage.profileDetailsHeading).toBeVisible();
    await expect(page.locator('table').filter({ hasText: 'Email' })).toBeVisible();
    await captureScreenshot(page, 'POS-DONOR-002', testInfo);
  });

  test('[POS-DONOR-003] Donor can open appointment history page', async ({ donorProfilePage, page }, testInfo) => {
    await donorProfilePage.openAppointments();
    await expect(donorProfilePage.appointmentHistoryHeading).toBeVisible();
    await captureScreenshot(page, 'POS-DONOR-003', testInfo);
  });

});
