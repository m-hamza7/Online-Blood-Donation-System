import { BasePage } from './BasePage.js';

export class AdminLoginPage extends BasePage {
  constructor(page) {
    super(page);
    this.usernameInput = page.locator('input[name="username"]');
    this.passwordInput = page.locator('input[name="password"]');
    this.loginButton = page.getByRole('button', { name: /Login/i });
    this.heading = page.getByRole('heading', { name: /Admin Login/i });
  }

  async open() {
    await this.goto('/admin');
  }

  async login(username, password) {
    await this.usernameInput.fill(username);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }
}

export default AdminLoginPage;
