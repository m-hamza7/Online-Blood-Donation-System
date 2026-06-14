export class BasePage {
  constructor(page) {
    this.page = page;
  }

  async goto(path = '/') {
    await this.page.goto(path);
  }

  getFlashMessage() {
    return this.page.locator('[role="alert"]').first();
  }

  async expectFlashContains(text) {
    await this.page.locator('[role="alert"]').filter({ hasText: text }).first().waitFor({ state: 'visible' });
  }

  async clickNavLink(name) {
    await this.page.getByRole('link', { name }).click();
  }
}

export default BasePage;
