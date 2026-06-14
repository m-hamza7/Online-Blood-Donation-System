# Blood Donation System

This is a Flask-based blood donation management system for coordinating donors, hospitals, and administrators. It provides registration and login flows, donor and hospital dashboards, blood request handling, appointment booking, notifications, messaging, and admin moderation tools.

## Features

- User registration and authentication for Donor and Hospital roles
- Donor profile management, appointment viewing, and blood request matching
- Hospital dashboard for creating blood requests and managing appointments
- Admin dashboard for user management, request moderation, and chat oversight
- Search for donors by blood type or location
- Session-based access control and flash notifications

## Project Structure

- `app.py` - Main Flask application and routes
- `api/index.py` - Vercel entrypoint that imports the Flask app
- `templates/` - Jinja2 HTML templates
- `static/` - CSS, JavaScript, and static assets
- `sql/` - Database scripts and SQL files
- `playwright-JS-framework/` - Separate Playwright test workspace
- `vercel.json` - Vercel routing configuration

## Requirements

- Python 3.12 or compatible version
- Flask
- mysql-connector-python

Install the Python dependencies with:

```bash
pip install -r requirements.txt
```

## Local Setup

1. Clone or open the project in VS Code.
2. Create and activate a virtual environment.
3. Install dependencies from `requirements.txt`.
4. Update the database configuration in `app.py` to match your local MySQL setup.
5. Make sure the database schema has been imported from the SQL files in `sql/`.

## Running Locally

```bash
python app.py
```

The app runs on `http://127.0.0.1:5000` by default.

## Main Routes

- `/` - Home page
- `/register` - User registration
- `/login` - User login
- `/donor_profile` - Donor dashboard and profile page
- `/hospital_dashboard` - Hospital dashboard
- `/admin` - Admin login
- `/admin_dashboard` - Admin management dashboard
- `/search` - Donor search page
- `/logout` - Clear the session

## Deployment Notes

The project is configured for Vercel through `vercel.json`, with `api/index.py` serving as the entrypoint.

## Notes

- Keep database credentials out of source control when deploying.
- The app uses server-side templates and Bootstrap-based UI components.
