import { test as playwrightTest } from '@playwright/test';
import { captureScreenshot } from './screenshotHelper.js';

/**
 * Run a Playwright step and capture a screenshot attached to `testInfo` for that step.
 *
 * Usage:
 * await stepWithScreenshot('Fill form', page, testInfo, async () => {
 *   // actions
 * });
 */
export async function stepWithScreenshot(name, page, testInfo, fn) {
  await playwrightTest.step(name, async () => {
    try {
      await fn();
      await captureScreenshot(page, `step-${name}`, testInfo);
    } catch (err) {
      await captureScreenshot(page, `step-failure-${name}`, testInfo);
      throw err;
    }
  });
}

export default stepWithScreenshot;
