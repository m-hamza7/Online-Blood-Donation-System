# Blood Donation System — Playwright E2E Tests

40 automated end-to-end tests (20 positive, 20 negative) for the Flask Blood Donation app running on localhost.

## Prerequisites

1. **XAMPP MySQL** running with database `bd` imported from `sql/bd (1).sql`
2. **Flask app** running locally:
   ```bash
   cd "F:\F\PROJECTS\BLOOD DONATION"
   python app.py
   ```
3. **Node.js 18+**

## Setup

```bash
cd playwright-JS-framework
npm install
npm run install:browsers
copy .env.example .env
```

Optional `.env` values:

| Variable | Default | Description |
|----------|---------|-------------|
| `BASE_URL` | `http://127.0.0.1:5000` | Flask app URL |
| `ADMIN_USERNAME` | `admin` | Admin login username |
| `ADMIN_PASSWORD` | `admin` | Admin login password |

## Run Tests

```bash
# All 40 tests
npm test

# Positive only (20)
npm run test:positive

# Negative only (20)
npm run test:negative

# Headed mode
npm run test:headed
```

## Allure Report

```bash
npm test
npm run report:generate
npm run report
```

Results are written to `allure-results/` and HTML report to `allure-report/`.

## Framework Structure

```
playwright-JS-framework/
├── fixtures/test-fixtures.js   # Custom fixtures + beforeEach/afterEach hooks
├── pages/                      # Page Object Model
├── test-data/                  # JSON data-driven test cases
├── tests/
│   ├── positive/               # 20 positive tests
│   └── negative/               # 20 negative tests
├── utils/                      # Data loader, screenshots, generators
└── screenshots/                # Captured on failure (and pass if SCREENSHOT_ALL=true)
```

## Test Case Summary

### Positive (20)

| ID | Area | Description |
|----|------|-------------|
| POS-NAV-001–004 | Navigation | Home, About, Login, Register pages load |
| POS-REG-001–002 | Registration | Valid donor and hospital registration |
| POS-SEARCH-001–003 | Search | Search by blood type and location |
| POS-AUTH-001–003 | Auth | Admin, donor, hospital login flows |
| POS-DONOR-001–003 | Donor | Dashboard, profile, appointments |
| POS-HOSP-001–003 | Hospital | Dashboard, profile, blood request |
| POS-ADMIN-001–002 | Admin | Users and blood requests views |

### Negative (20)

| ID | Area | Description |
|----|------|-------------|
| NEG-LOGIN-001–004 | Login | Invalid credentials, empty fields |
| NEG-REG-001–007 | Registration | Validation errors, duplicate username |
| NEG-AUTH-001–003 | Authorization | Protected routes without login |
| NEG-ADMIN-001–003 | Admin | Invalid admin credentials |
| NEG-SEARCH-001–003 | Search | Empty search, no results |

## Notes

- Registration tests create **unique usernames** automatically to avoid DB conflicts.
- Negative login tests use username `hamza` from seed data with wrong passwords (user must exist in DB).
- Duplicate username test expects existing user `hamza` in database.
- Search positive tests require donor seed data in database.

## Architecture Diagram & Docs

See the architecture overview and component mapping in `docs/ARCHITECTURE.md` for the diagram and file mapping.

## Word Documentation

The requested Word document is available at `docs/Blood_Donation_Playwright_Test_Documentation.docx`. It includes the architecture diagram, test plan, and test case tables.

## Attaching screenshots per step

Use the helper `utils/stepHelper.js` to run a named Playwright step and automatically attach a screenshot to the current test for that step. Example usage inside a spec:

```ts
import { test, expect } from '@playwright/test';
import stepWithScreenshot from '../utils/stepHelper';

test('example with per-step screenshots', async ({ page }, testInfo) => {
   await stepWithScreenshot('Open home', page, testInfo, async () => {
      await page.goto('/');
      await expect(page).toHaveTitle(/Blood Donation/);
   });

   await stepWithScreenshot('Open login and capture', page, testInfo, async () => {
      await page.getByRole('link', { name: /Login/ }).click();
      await expect(page).toHaveURL(/\/login/);
   });
});
```

Each call to `stepWithScreenshot` runs a `test.step` and attaches a screenshot to that step (pass or failure). Screenshots appear in Allure as attachments created during the step execution.
