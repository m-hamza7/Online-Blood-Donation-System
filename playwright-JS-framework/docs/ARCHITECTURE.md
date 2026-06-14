# Framework Architecture

The diagram below describes the Playwright framework structure and how components interact.

```mermaid
flowchart TD
  A[Test Runner\n(Playwright Test CLI)] --> B[Test Suites]
  B --> C[Test Cases / Specs]
  C --> D[Fixtures & Hooks\n(beforeEach/afterEach, beforeAll/afterAll)]
  C --> E[Page Objects (POM)]
  E --> F[Pages/* (BasePage, LoginPage, HomePage, ...)]
  C --> G[Test Data]\n(test-data/*.json)
  C --> H[Utilities]\n(utils/*)
  H --> I[Logging (utils/logger.js)]
  H --> J[Config (utils/config.js)]
  H --> K[Screenshots (utils/screenshotHelper.js)]
  C --> L[Reporters]\n(Allure via allure-playwright)
  L --> M[allure-results/ -> allure-report/]
  style A fill:#f9f,stroke:#333,stroke-width:1px
  style L fill:#ffd,stroke:#333
```

**Component Mapping (files)**
- **Test Suites / Cases**: `tests/positive/*`, `tests/negative/*`
- **Fixtures & Hooks**: `fixtures/test-fixtures.js`, `tests/hooks/global-hooks.js`
- **Page Objects (POM)**: `pages/*` (e.g., `BasePage.js`, `LoginPage.js`)
- **Test Data**: `test-data/*.json` (data-driven tests loaded by `utils/dataLoader.js`)
- **Utilities**: `utils/*` — includes `dataLoader.js`, `screenshotHelper.js`, `testDataGenerator.js`, `config.js`, `logger.js`
- **Reporting**: configured in `playwright.config.js` via `allure-playwright`; results written to `allure-results/` and HTML to `allure-report/`

**Practices enforced**
- Page Object Model (POM) for maintainable page interactions.
- Data-driven testing using JSON files under `test-data/`.
- Centralized configuration via `utils/config.js`.
- Hooks and fixtures for setup/teardown and screenshot-on-failure.
- Allure reporting with screenshots and logs attached on failures.

Refer to the repository README for run and report generation commands.
