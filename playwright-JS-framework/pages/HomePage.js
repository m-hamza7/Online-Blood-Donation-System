import { BasePage } from './BasePage.js';

export class HomePage extends BasePage {
  constructor(page) {
    super(page);
    this.heading = page.getByRole('heading', { name: /Blood Donation System/i }).first();
    this.loginLink = page.getByRole('link', { name: /Login/i }).first();
    this.registerLink = page.getByRole('link', { name: /Register/i }).first();
    this.adminLink = page.getByRole('link', { name: /Admin/i }).first();
  }

  async open() {
    await this.goto('/');
  }

  async goToLogin() {
    await this.loginLink.click();
  }

  async goToRegister() {
    await this.registerLink.click();
  }

  async goToAdminLogin() {
    await this.adminLink.click();
  }
}

export class AboutPage extends BasePage {
  constructor(page) {
    super(page);
    this.heading = page.getByRole('heading', {
      name: /Blood Donation Management System|Welcome to the Blood Donation/i,
    });
  }

  async open() {
    await this.goto('/index');
  }
}

export default HomePage;
