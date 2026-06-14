import { BasePage } from './BasePage.js';

export class AdminDashboardPage extends BasePage {
  constructor(page) {
    super(page);
    this.dashboardHeading = page.getByRole('heading', { name: /Admin Dashboard/i });
    this.viewUsersLink = page.getByRole('link', { name: /VIEW USERS/i });
    this.bloodRequestsLink = page.getByRole('link', { name: /BLOOD REQUESTS/i });
    this.appointmentsLink = page.getByRole('link', { name: /APPOINTMENTS/i });
    this.chatLink = page.getByRole('link', { name: /^CHAT$/i });
    this.searchLink = page.getByRole('link', { name: /SEARCH/i });
  }

  async open(view = 'users') {
    await this.goto(`/admin_dashboard?view=${view}`);
  }

  async openActiveUsers() {
    await this.goto('/admin_dashboard?view=users&status=active');
  }

  async openInactiveUsers() {
    await this.goto('/admin_dashboard?view=users&status=inactive');
  }

  getSectionHeading(name) {
    return this.page.getByRole('heading', { name });
  }

  getUsersTable() {
    return this.page.locator('table').first();
  }
}

export default AdminDashboardPage;
