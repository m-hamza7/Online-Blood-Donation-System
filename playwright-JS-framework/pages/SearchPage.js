import { BasePage } from './BasePage.js';

export class SearchPage extends BasePage {
  constructor(page) {
    super(page);
    this.heading = page.getByRole('heading', { name: /Search Donors/i });
    this.searchBySelect = page.locator('select[name="search_by"]');
    this.searchInput = page.locator('input[name="search"]');
    this.searchButton = page.getByRole('button', { name: /Search/i });
    this.resultsTable = page.locator('table.results-table');
    this.resultsHeading = page.getByRole('heading', { name: /Search Results/i });
  }

  async open() {
    await this.goto('/search');
  }

  async search(searchBy, term) {
    await this.searchBySelect.selectOption(searchBy);
    await this.searchInput.fill(term);
    await this.searchButton.click();
  }

  async submitEmptySearch() {
    await this.searchButton.click();
  }
}

export default SearchPage;
