import { BasePage } from './BasePage.js';

export class HospitalDashboardPage extends BasePage {
  constructor(page) {
    super(page);
    this.dashboardHeading = page.getByRole('heading', { name: /Hospital Dashboard/i });
    this.viewProfileLink = page.getByRole('link', { name: /View Profile/i });
    this.bloodRequestHeading = page.getByRole('heading', { name: /Make a Blood Request/i });
    this.bloodTypeSelect = page.locator('select[name="blood_type"]');
    this.quantityInput = page.locator('input[name="quantity"]');
    this.submitRequestButton = page.getByRole('button', { name: /Submit Request/i });
    this.appointmentsHeading = page.getByRole('heading', { name: /Scheduled Appointments/i });
    this.existingRequestsHeading = page.getByRole('heading', { name: /Existing Blood Requests/i });
    this.profileHeading = page.getByRole('heading', { name: /Hospital Profile/i });
  }

  async open() {
    await this.goto('/hospital_dashboard');
  }

  async openProfile() {
    await this.goto('/hospital_dashboard?view_profile=true');
  }

  async submitBloodRequest(bloodType, quantity) {
    await this.bloodTypeSelect.selectOption(bloodType);
    await this.quantityInput.fill(quantity);
    await this.submitRequestButton.click();
  }
}

export default HospitalDashboardPage;
