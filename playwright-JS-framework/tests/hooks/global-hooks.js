import { test as base } from '@playwright/test';

/**
 * Global suite hooks shared across all specs via playwright.config import chain.
 * Primary hooks live in fixtures/test-fixtures.js (beforeEach / afterEach).
 */
export const suiteHooks = {
  slowMo: 0,
};

base.beforeAll(async () => {
  const baseURL = process.env.BASE_URL || 'http://127.0.0.1:5000';
  const response = await fetch(baseURL).catch(() => null);
  if (!response?.ok) {
    console.warn(
      `[hooks] Flask app may not be running at ${baseURL}. Start with: python app.py`
    );
  }
});
