import { BasePage } from './BasePage.js';

export class RegisterPage extends BasePage {
  constructor(page) {
    super(page);
    this.form = page.locator('#registerForm');
    this.usernameInput = page.locator('input[name="username"]');
    this.emailInput = page.locator('input[name="email"]');
    this.passwordInput = page.locator('input[name="password"]');
    this.roleSelect = page.locator('select[name="role"]');
    this.nameInput = page.locator('input[name="name"]');
    this.contactInput = page.locator('input[name="contact_info"]');
    this.bloodTypeSelect = page.locator('select[name="blood_type"]');
    this.cityInput = page.locator('input[name="city"]');
    this.stateInput = page.locator('input[name="state"]');
    this.zipInput = page.locator('input[name="zip_code"]');
    this.submitButton = page.getByRole('button', { name: 'Register' });
    this.heading = page.getByRole('heading', { name: /Create Account/i });
  }

  async open() {
    await this.goto('/register');
  }

  async fillForm(data) {
    if (data.username !== undefined) await this.usernameInput.fill(data.username);
    if (data.email !== undefined) await this.emailInput.fill(data.email);
    if (data.password !== undefined) await this.passwordInput.fill(data.password);
    if (data.role !== undefined) await this.roleSelect.selectOption(data.role);
    if (data.name !== undefined) await this.nameInput.fill(data.name);
    if (data.contact_info !== undefined) await this.contactInput.fill(data.contact_info);
    if (data.blood_type !== undefined) await this.bloodTypeSelect.selectOption(data.blood_type);
    if (data.city !== undefined) await this.cityInput.fill(data.city);
    if (data.state !== undefined) await this.stateInput.fill(data.state);
    if (data.zip_code !== undefined) await this.zipInput.fill(data.zip_code);
  }

  async register(data) {
    await this.fillForm(data);
    await this.submitButton.click();
  }

  async submitEmpty() {
    await this.submitButton.click();
  }

  async isFieldInvalid(field) {
    return field.evaluate((el) => !el.checkValidity());
  }
}

export default RegisterPage;
