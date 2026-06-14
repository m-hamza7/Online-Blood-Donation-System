import { BasePage } from './BasePage.js';

export class DonorProfilePage extends BasePage {
  constructor(page) {
    super(page);
    this.welcomeHeader = page.getByRole('heading', { name: /Welcome/i }).first();
    this.viewProfileLink = page.getByRole('link', { name: /View Profile/i });
    this.appointmentsLink = page.getByRole('link', { name: /My Appointment History/i });
    this.contactAdminLink = page.getByRole('link', { name: /Contact Admin/i });
    this.bloodRequestsHeading = page.getByRole('heading', { name: /Available Blood Requests/i });
    this.profileDetailsHeading = page.getByRole('heading', { name: /Your Profile Details/i });
    this.chatHeading = page.getByRole('heading', { name: /Chat with Admin/i });
    this.appointmentHistoryHeading = page.getByRole('heading', { name: /My Appointment History/i });
  }

  async open() {
    await this.goto('/donor_profile');
  }

  async openViewProfile() {
    await this.goto('/donor_profile?view_profile=true');
  }

  async openAppointments() {
    await this.goto('/donor_profile?view_appointments=true');
  }

  async openContactAdmin() {
    await this.goto('/donor_profile?contact_admin=true');
  }

  async openEditProfile() {
    await this.goto('/donor_profile?edit_profile=true');
  }

  async sendAdminMessage(message) {
    await this.page.locator('textarea[name="message"]').fill(message);
    await this.page.getByRole('button', { name: /Send Message/i }).click();
  }
}

export default DonorProfilePage;
