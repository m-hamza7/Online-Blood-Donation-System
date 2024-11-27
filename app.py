#admin

from datetime import datetime
from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
app = Flask(__name__)
app.secret_key = 'your_secret_key'

    # Database connection details
db_config = {
        'user': 'root',
        'password': '42692',
        'host': 'localhost',
        'database': 'bd'
    }

    # Helper function to get a database connection
def get_db_connection():
    return mysql.connector.connect(**db_config)

    # Home Page
@app.route('/')
def home():
    return render_template('home.html')


@app.route('/index')
def index():
    return render_template('index.html')




# Registration Page
#@app.route('/register', methods=['GET', 'POST'])
#def register():
#    if request.method == 'POST':
#        # Fetch form data
#        username = request.form['username']
#        password = generate_password_hash(request.form['password'])
#        email = request.form['email']
#        role = request.form['role']  # Donor or Hospital
#        name = request.form['name']
#        contact_info = request.form.get('contact_info')
#        city = request.form['city']
#        state = request.form['state']
#        zip_code = request.form['zip_code']
#
#        # Database connection
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#
#        # Check if location exists
#        cursor.execute(
#            "SELECT location_id FROM Locations WHERE city=%s AND state=%s AND zip_code=%s",
#            (city, state, zip_code)
#        )
#        location = cursor.fetchone()
#
#        if not location:
#            # Insert new location
#            cursor.execute(
#                "INSERT INTO Locations (city, state, zip_code) VALUES (%s, %s, %s)",
#                (city, state, zip_code)
#            )
#            conn.commit()
#            location_id = cursor.lastrowid
#        else:
#            location_id = location['location_id']
#
#        # Insert user into Users table
#        cursor.execute(
#            "INSERT INTO Users (username, password, role, email) VALUES (%s, %s, %s, %s)",
#            (username, password, role, email)
#        )
#        conn.commit()
#        user_id = cursor.lastrowid
#
#        # Insert into Donors or Hospitals table
#        if role == 'Donor':
#            blood_type = request.form['blood_type']
#            cursor.execute(
#                "INSERT INTO Donors (donor_id, name, contact_info, location_id, blood_type) VALUES (%s, %s, %s, %s, %s)",
#                (user_id, name, contact_info, location_id, blood_type)
#            )
#        elif role == 'Hospital':
#            cursor.execute(
#                "INSERT INTO Hospitals (hospital_id, hospital_name, contact_info, location_id) VALUES (%s, %s, %s, %s)",
#                (user_id, name, contact_info, location_id)
#            )
#        conn.commit()
#
#        cursor.close()
#        conn.close()
#
#        flash('Registration successful! Please login.', 'success')
#        return redirect('/login')
#
#    return render_template('register.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        # Fetch form data
        username = request.form['username']
        password = generate_password_hash(request.form['password'])
        email = request.form['email']
        role = request.form['role']  # Donor or Hospital
        name = request.form['name']
        contact_info = request.form.get('contact_info')
        city = request.form['city']
        state = request.form['state']
        zip_code = request.form['zip_code']

        # Debugging: Print form data
        print(f"Username: {username}, Email: {email}, Role: {role}, Name: {name}, Contact Info: {contact_info}")
        print(f"City: {city}, State: {state}, Zip Code: {zip_code}")

        # Database connection
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Check if location exists
        cursor.execute(
            "SELECT LOCATION_ID FROM LOCATIONS WHERE CITY=%s AND STATE=%s AND ZIP_CODE=%s",
            (city, state, zip_code)  # Adjusted for correct variables
        )
        location = cursor.fetchone()

        # Debugging: Print the location check result
        print(f"Location found: {location}")

        if not location:
            # Insert new location if it doesn't exist
            cursor.execute(
                "INSERT INTO LOCATIONS (CITY, STATE, ZIP_CODE) VALUES (%s, %s, %s)",
                (city, state, zip_code)
            )
            conn.commit()
            location_id = cursor.lastrowid
            # Debugging: Print new location ID
            print(f"New Location ID: {location_id}")
        else:
            location_id = location['LOCATION_ID']
            # Debugging: Print existing location ID
            print(f"Existing Location ID: {location_id}")

        # Insert into Users table
        cursor.execute(
            "INSERT INTO USERS (USERNAME, PASSWORD, ROLE, EMAIL) VALUES (%s, %s, %s, %s)",
            (username, password, role, email)
        )
        conn.commit()
        user_id = cursor.lastrowid
        # Debugging: Print user ID
        print(f"New User ID: {user_id}")

        # Insert into Donors or Hospitals table based on role
        if role == 'Donor':
            blood_type = request.form['blood_type']
            cursor.execute(
                "INSERT INTO DONORS (USER_ID, NAME, CONTACT_INFO, LOCATION_ID, BLOOD_TYPE) VALUES (%s, %s, %s, %s, %s)",
                (user_id, name, contact_info, location_id, blood_type)
            )
            conn.commit()
            # Debugging: Confirm Donor insertion
            print(f"Donor record inserted with user_id: {user_id}, blood_type: {blood_type}")
        elif role == 'Hospital':
            cursor.execute(
                "INSERT INTO HOSPITALS (USER_ID, NAME, CONTACT_INFO, LOCATION_ID) VALUES (%s, %s, %s, %s)",
                (user_id, name, contact_info, location_id)
            )
            conn.commit()
            # Debugging: Confirm Hospital insertion
            print(f"Hospital record inserted with user_id: {user_id}")

        cursor.close()
        conn.close()

        flash('Registration successful! Please login.', 'success')
        return redirect('/login')

    return render_template('register.html')




# Login Page
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Database connection
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Authenticate user
        cursor.execute("SELECT user_id, username, password, role FROM Users WHERE username = %s", (username,))
        user = cursor.fetchone()

        cursor.close()
        conn.close()

        if user and check_password_hash(user['password'], password):
            session['loggedin'] = True
            session['user_id'] = user['user_id']
            session['username'] = user['username']
            session['role'] = user['role']
            flash('Login Successful', 'success')
            
            # Role-based redirection
            if user['role'] == 'Donor':
                return redirect('/donor_profile')
            elif user['role'] == 'Hospital':
                return redirect('/hospital_dashboard')
        else:
            flash('Invalid username or password!', 'danger')

    return render_template('login.html')

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Check admin credentials (hardcoded)
        if username == 'admin' and password == 'admin':
            session['loggedin'] = True
            session['role'] = 'Admin'
            return redirect('/admin_dashboard')  # Redirect to admin dashboard
        else:
            flash('Invalid admin credentials!', 'danger')

    return render_template('admin_login.html')  # Render admin login page


#@app.route('/admin_dashboard', methods=['GET', 'POST'])
#def admin_dashboard():
#    if 'loggedin' in session and session['role'] == 'Admin':
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#
#        cursor.execute("""
#            SELECT 
#                u.USER_ID, 
#                u.USERNAME, 
#                u.ROLE, 
#                COALESCE(d.NAME, h.NAME) AS NAME, 
#                d.BLOOD_TYPE 
#            FROM USERS u
#            LEFT JOIN DONORS d ON u.USER_ID = d.USER_ID
#            LEFT JOIN HOSPITALS h ON u.USER_ID = h.USER_ID
#        """)
#        registered_users = cursor.fetchall()
#
#        if request.method == 'POST':
#            if 'delete_user_id' in request.form:
#                user_id = request.form['delete_user_id']
#
#                # Delete associated appointments first
#                cursor.execute("DELETE FROM APPOINTMENTS WHERE DONOR_ID = %s", (user_id,))
#                cursor.execute("DELETE FROM APPOINTMENTS WHERE HOSPITAL_ID = %s", (user_id,))
#
#                # Delete from Donors or Hospitals
#                cursor.execute("DELETE FROM DONORS WHERE USER_ID = %s", (user_id,))
#                cursor.execute("DELETE FROM HOSPITALS WHERE USER_ID = %s", (user_id,))
#
#                # Then delete from Users
#                cursor.execute("DELETE FROM USERS WHERE USER_ID = %s", (user_id,))
#                conn.commit()
#                flash('User removed successfully!', 'success')
#
#        cursor.close()
#        conn.close()
#
#        return render_template(
#            'admin_dashboard.html',
#            registered_users=registered_users
#        )
#    else:
#        flash('Unauthorized access!', 'danger')
#        return redirect('/')
#


@app.route('/admin_dashboard', methods=['GET', 'POST'])
def admin_dashboard():
    if 'loggedin' in session and session['role'] == 'Admin':
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Determine the view to display
        view = request.args.get('view', 'users')  # Default view is 'users'

        if view == 'users':
            # Fetch registered users
            cursor.execute("""
                SELECT 
                    u.user_id, 
                    u.username, 
                    u.role, 
                    COALESCE(d.name, h.name) AS name, 
                    d.blood_type
                FROM Users u
                LEFT JOIN Donors d ON u.user_id = d.user_id
                LEFT JOIN Hospitals h ON u.user_id = h.user_id
            """)
            registered_users = cursor.fetchall()
            data = {'registered_users': registered_users}

        elif view == 'blood_requests':
            # Fetch all blood requests
            cursor.execute("""
                SELECT 
                    br.request_id, 
                    br.hospital_id, 
                    br.blood_type, 
                    br.quantity, 
                    br.requested_date,
                    br.status
                FROM blood_requests br
            """)
            blood_requests = cursor.fetchall()
            data = {'blood_requests': blood_requests}

        elif view == 'appointments':
            # Fetch all appointments
            cursor.execute("""
                SELECT 
                    a.appointment_id,  
                    a.donor_id, 
                    a.hospital_id, 
                    a.date, 
                    a.time,
                    a.status
                FROM appointments a
            """)
            appointments = cursor.fetchall()
            data = {'appointments': appointments}

        else:
            data = {}

        if request.method == 'POST':
        # Handle user deletion
            if 'delete_user_id' in request.form:
                user_id = request.form['delete_user_id']
                cursor.execute("DELETE FROM Appointments WHERE donor_id = %s", (user_id,))
                cursor.execute("DELETE FROM Appointments WHERE hospital_id = %s", (user_id,))
                cursor.execute("DELETE FROM Donors WHERE donor_id = %s", (user_id,))
                cursor.execute("DELETE FROM Hospitals WHERE hospital_id = %s", (user_id,))
                cursor.execute("DELETE FROM Users WHERE user_id = %s", (user_id,))
                conn.commit()
                flash('User removed successfully!', 'success')

            # Handle blood request deletion
            elif 'delete_request_id' in request.form:
                request_id = request.form['delete_request_id']
                cursor.execute("DELETE FROM Blood_Requests WHERE request_id = %s", (request_id,))
                conn.commit()
                flash('Blood request deleted successfully!', 'success')

            # Handle appointment deletion
            elif 'delete_appointment_id' in request.form:
                appointment_id = request.form['delete_appointment_id']
                cursor.execute("DELETE FROM Appointments WHERE appointment_id = %s", (appointment_id,))
                conn.commit()
                flash('Appointment deleted successfully!', 'success')


        cursor.close()
        conn.close()

        return render_template('admin_dashboard.html', view=view, **data)

    else:
        flash('Unauthorized access!', 'danger')
        return redirect('/')

@app.route('/admin_dashboard/update', methods=['GET', 'POST'])
def update_user():
    if 'loggedin' in session and session['role'] == 'Admin':
        user_id = request.args.get('update_user_id')  # Get user ID from the GET request
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        if request.method == 'GET':
            # Fetch user details
            cursor.execute("""
                SELECT 
                    u.user_id, 
                    u.role, 
                    COALESCE(d.name, h.name) AS name, 
                    d.blood_type
                FROM Users u
                LEFT JOIN Donors d ON u.user_id = d.user_id
                LEFT JOIN Hospitals h ON u.user_id = h.user_id
                WHERE u.user_id = %s
            """, (user_id,))
            user = cursor.fetchone()

            cursor.close()
            conn.close()

            if not user:
                flash("User not found!", "danger")
                return redirect('/admin_dashboard?view=users')

            return render_template('update_user.html', user=user)

        elif request.method == 'POST':
            # Update the user's information
            name = request.form['name']
            blood_type = request.form.get('blood_type')  # Only applicable for donors
            role = request.form['role']

            if role == 'Donor':
                cursor.execute("""
                    UPDATE Donors
                    SET name = %s, blood_type = %s
                    WHERE user_id = %s
                """, (name, blood_type, user_id))
            elif role == 'Hospital':
                cursor.execute("""
                    UPDATE Hospitals
                    SET name = %s
                    WHERE user_id = %s
                """, (name, user_id))

            conn.commit()
            cursor.close()
            conn.close()
            flash('User information updated successfully!', 'success')
            return redirect('/admin_dashboard?view=users')
    else:
        flash('Unauthorized access!', 'danger')
        return redirect('/')
    
    
    
#@app.route('/donor_profile', methods=['GET', 'POST'])
#def donor_profile():
#    if 'loggedin' in session and session['role'] == 'Donor':
#        user_id = session['user_id']
#        
#        # Fetch donor details with donor_id
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#        cursor.execute(
#            """
#            SELECT d.donor_id, u.email, d.name, d.contact_info, d.blood_type, l.city, l.state, l.zip_code
#            FROM Donors d
#            JOIN Users u on u.user_id = d.user_id
#            JOIN Locations l ON d.location_id = l.location_id
#            WHERE d.user_id = %s
#            """,
#            (user_id,)
#        )
#        donor = cursor.fetchone()
#
#        if not donor:
#            # Handle case where donor details are not found
#            flash('No donor details found for this user.', 'danger')
#            return redirect('/index')
#
#        view_profile = request.args.get('view_profile') == 'true'
#        cursor.execute(
#            """
#            SELECT br.blood_type, br.quantity, br.requested_date, h.name, l.city, br.hospital_id
#            FROM blood_requests br
#            JOIN Hospitals h ON br.hospital_id = h.hospital_id
#            JOIN Locations l ON h.location_id = l.location_id
#            WHERE br.blood_type = %s AND l.city = %s AND br.status = 'Open'
#            """,
#            (donor['blood_type'], donor['city'])
#            
#        )
#        blood_requests = cursor.fetchall()
#        if request.method == 'POST':
#            hospital_id = request.form['hospital_id']
#            date = request.form['date']
#            time = request.form['time']
#
#            cursor.execute(
#                "INSERT INTO Appointments (donor_id, hospital_id, date, time) VALUES (%s, %s, %s, %s)",
#                (donor['donor_id'], hospital_id, date, time)
#            )
#            conn.commit()
#            flash('Appointment booked successfully!', 'success')
#
#        cursor.close()
#        conn.close()
#        
#        
#        if view_profile:
#            # When "view_profile=true", no need to fetch blood requests
#            cursor.close()
#            conn.close()
#            return render_template('donor_profile.html', donor=donor, blood_requests=blood_requests, view_profile=True)
#
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#        # Fetch blood requests matching donor's blood type AND city
#        
#        cursor.execute(
#            """
#            SELECT br.blood_type, br.quantity, br.requested_date, h.name, l.city, br.hospital_id
#            FROM blood_requests br
#            JOIN Hospitals h ON br.hospital_id = h.hospital_id
#            JOIN Locations l ON h.location_id = l.location_id
#            WHERE br.blood_type = %s AND l.city = %s AND br.status = 'Open'
#            """,
#            (donor['blood_type'], donor['city'])
#        )
#        blood_requests = cursor.fetchall()
#              
#        # If POST request, handle appointment booking
#        if request.method == 'POST':
#            hospital_id = request.form['hospital_id']
#            date = request.form['date']
#            time = request.form['time']
#
#            cursor.execute(
#                "INSERT INTO Appointments (donor_id, hospital_id, date, time) VALUES (%s, %s, %s, %s)",
#                (donor['donor_id'], hospital_id, date, time)
#            )
#            conn.commit()
#            flash('Appointment booked successfully!', 'success')
#
#        cursor.close()
#        conn.close()
#
#        return render_template('donor_profile.html', donor=donor, blood_requests=blood_requests, view_profile=False)
#    else:
#        flash('Unauthorized access!', 'danger')
#        return redirect('/')
#    
    
    
    
    
    
    
@app.route('/donor_profile', methods=['GET', 'POST'])
def donor_profile():
    if 'loggedin' in session and session['role'] == 'Donor':
        user_id = session['user_id']
        
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT d.donor_id, u.email, d.name, d.contact_info, d.blood_type, l.city, l.state, l.zip_code
            FROM Donors d
            JOIN Users u on u.user_id = d.user_id
            JOIN Locations l ON d.location_id = l.location_id
            WHERE d.user_id = %s
        """, (user_id,))
        donor = cursor.fetchone()

        if not donor:
            flash('No donor details found for this user.', 'danger')
            return redirect('/index')

        view_profile = request.args.get('view_profile') == 'true'
        edit_profile = request.args.get('edit_profile') == 'true'
        
        if request.method == 'POST' and request.form.get('action') == 'edit_profile':
            name = request.form['name']
            email=request.form['email']
            
            contact_info = request.form['contact_info']
            blood_type = request.form['blood_type']
            city = request.form['city']
            state = request.form['state']
            zip_code = request.form['zip_code']

            # Update donor details
            cursor.execute("""
                UPDATE Donors d
                JOIN Users u on d.user_id = u.user_id
                JOIN Locations l ON d.location_id = l.location_id
                SET d.name = %s,u.email=%s ,d.contact_info = %s,d.blood_type=%s, l.city = %s, l.state = %s, l.zip_code = %s
                WHERE d.user_id = %s
            """, (name, email,contact_info,blood_type, city, state, zip_code, user_id))
            conn.commit()
            flash('Profile updated successfully!', 'success')
            return redirect('/donor_profile?view_profile=true')

        # Fetch blood requests
        cursor.execute("""
            SELECT br.blood_type, br.quantity, br.requested_date, h.name, l.city, l.state
            FROM Blood_Requests br
            JOIN Hospitals h ON br.hospital_id = h.hospital_id
            JOIN Locations l ON h.location_id = l.location_id
            WHERE br.blood_type = %s AND br.status = 'Pending'
        """, (donor['blood_type'],))
        blood_requests = cursor.fetchall()
        cursor.execute(
            """
            SELECT br.blood_type, br.quantity, br.requested_date, h.name, l.city, br.hospital_id
            FROM blood_requests br
            JOIN Hospitals h ON br.hospital_id = h.hospital_id
            JOIN Locations l ON h.location_id = l.location_id
            WHERE br.blood_type = %s AND l.city = %s AND br.status = 'Open'
            """,
            (donor['blood_type'], donor['city'])
        )
        blood_requests = cursor.fetchall()
              
        # If POST request, handle appointment booking
        if request.method == 'POST':
            hospital_id = request.form['hospital_id']
            date = request.form['date']
            time = request.form['time']

            cursor.execute(
                "INSERT INTO Appointments (donor_id, hospital_id, date, time) VALUES (%s, %s, %s, %s)",
                (donor['donor_id'], hospital_id, date, time)
            )
            conn.commit()
            flash('Appointment booked successfully!', 'success')

        cursor.close()
        conn.close()
      #  conn.close()

        return render_template(
            'donor_profile.html',
            donor=donor,
            blood_requests=blood_requests,
            view_profile=view_profile,
            edit_profile=edit_profile
        )
    else:
        flash('You are not logged in or unauthorized to access this page.', 'danger')
        return redirect('/login')

    ##
#@app.route('/donor_profile', methods=['GET', 'POST'])
#def donor_profile():
#    if 'loggedin' in session and session['role'] == 'Donor':
#        user_id = session['user_id']
#          
#        # Fetch donor details with donor_id
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#        cursor.execute(
#            """
#            SELECT d.donor_id, d.name, d.contact_info, d.blood_type, l.city, l.state, l.zip_code
#            FROM Donors d
#            JOIN Locations l ON d.location_id = l.location_id
#            WHERE d.user_id = %s
#            """,
#            (user_id,)
#        )
#        donor = cursor.fetchone()
#
#        if not donor:
#            # Handle case where donor details are not found
#            flash('No donor details found for this user.', 'danger')
#            return redirect('/index')
#
#        # Use donor['donor_id'] in subsequent operations
#        donor_id = donor['donor_id']
#        # Additional code...
#
#        # Fetch blood requests matching donor's blood type AND city
#        cursor.execute(
#            """
#            SELECT br.blood_type, br.quantity, br.requested_date, h.name, l.city, br.hospital_id
#            FROM blood_requests br
#            JOIN Hospitals h ON br.hospital_id = h.hospital_id
#            JOIN Locations l ON h.location_id = l.location_id
#            WHERE br.blood_type = %s AND l.city = %s AND br.status = 'Open'
#            """,
#            (donor['blood_type'], donor['city'])
#        )
#        blood_requests = cursor.fetchall()
#
#        # If POST request, handle appointment booking
#        if request.method == 'POST':
#            hospital_id = request.form['hospital_id']
#            date = request.form['date']
#            time = request.form['time']
#
#            cursor.execute(
#                "INSERT INTO Appointments (donor_id, hospital_id, date, time) VALUES (%s, %s, %s, %s)",
#                (donor_id, hospital_id, date, time)
#            )
#            conn.commit()
#            flash('Appointment booked successfully!', 'success')
#
#        cursor.close()
#        conn.close()
#
#        return render_template('donor_profile.html', donor=donor, blood_requests=blood_requests)
#    else:
#        flash('Unauthorized access!', 'danger')
#        return redirect('/')
#
#@app.route('/donor_profile/view', methods=['GET'])
#def view_donor_profile():
#    if 'loggedin' in session and session['role'] == 'Donor':
#        user_id = session['user_id']
#
#        # Connect to the database
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#
#        # Fetch donor details including location
#        cursor.execute(
#            """
#            SELECT d.NAME, u.EMAIL, d.CONTACT_INFO, d.BLOOD_TYPE, l.CITY, l.STATE, l.ZIP_CODE
#            FROM DONORS d
#            JOIN USERS u ON d.USER_ID = u.USER_ID
#            JOIN LOCATIONS l ON d.LOCATION_ID = l.LOCATION_ID
#            WHERE d.USER_ID = %s
#            """,
#            (user_id,)
#        )
#        donor = cursor.fetchone()
#
#        cursor.close()
#        conn.close()
#
#        if not donor:
#            flash('No donor details found for this user.', 'danger')
#            return redirect('/index')
#
#        return render_template(
#            'donor_profile.html',
#            donor=donor,
#            view_profile=True
#        )
#    else:
#        flash('Unauthorized access!', 'danger')
#        return redirect('/')


## Donor Profile
#@app.route('/donor_profile', methods=['GET', 'POST'])
#def donor_profile():
#    if 'loggedin' in session and session['role'] == 'Donor':
#        user_id = session['user_id']
#
#        # Fetch donor details
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#        cursor.execute(
#            "SELECT d.name, d.contact_info, d.blood_type, l.city FROM Donors d "
#            "JOIN Locations l ON d.location_id = l.location_id WHERE donor_id = %s",
#            (user_id,)
#        )
#        donor = cursor.fetchone()
#
#        # Fetch blood requests matching donor's blood type AND city
#        cursor.execute(
#            """
#            SELECT br.blood_type, br.quantity, br.request_date, h.hospital_name, l.city, br.hospital_id
#            FROM blood_requests br
#            JOIN Hospitals h ON br.hospital_id = h.hospital_id
#            JOIN Locations l ON h.location_id = l.location_id
#            WHERE br.blood_type = %s AND l.city = %s AND br.status = 'Open'
#            """,
#            (donor['blood_type'], donor['city'])
#        )
#        blood_requests = cursor.fetchall()
#
#        # If POST request, handle appointment booking
#        if request.method == 'POST':
#            hospital_id = request.form['hospital_id']
#            date = request.form['date']
#            time = request.form['time']
#
#            cursor.execute(
#                "INSERT INTO Appointments (donor_id, hospital_id, date, time) VALUES (%s, %s, %s, %s)",
#                (user_id, hospital_id, date, time)
#            )
#            conn.commit()
#            flash('Appointment booked successfully!', 'success')
#
#        cursor.close()
#        conn.close()
#
#        return render_template('donor_profile.html', donor=donor, blood_requests=blood_requests)
#    else:
#        flash('Unauthorized access!', 'danger')
#        return redirect('/')



#@app.route('/donor_profile', methods=['GET', 'POST'])
#def donor_profile():
#    if 'loggedin' in session and session['role'] == 'Donor':
#        user_id = session['user_id']
#
#        # Fetch donor details, including location
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#        cursor.execute(
#            "SELECT d.NAME,d.BLOOD_TYPE, l.CITY FROM DONORS d "
#            "JOIN LOCATIONS l ON d.LOCATION_ID = l.LOCATION_ID WHERE d.USER_ID = %s",
#            (user_id,)
#        )
#        donor = cursor.fetchone()
#
#        if not donor:
#            flash('No donor details found for this user.', 'danger')
#            return redirect('/index')
#
#        # Fetch open blood requests matching donor's blood type and city
#        cursor.execute(
#            """
#            SELECT br.BLOOD_TYPE, br.QUANTITY, br.REQUESTED_DATE, h.NAME, l.CITY, br.HOSPITAL_ID
#            FROM BLOOD_REQUESTS br
#            JOIN HOSPITALS h ON br.HOSPITAL_ID = h.HOSPITAL_ID
#            JOIN LOCATIONS l ON h.LOCATION_ID = l.LOCATION_ID
#            WHERE br.BLOOD_TYPE = %s AND l.CITY = %s AND br.STATUS = 'Open'
#            """,
#            (donor['BLOOD_TYPE'], donor['CITY'])
#        )
#        blood_requests = cursor.fetchall()
#
#        # If POST request, handle appointment booking
#        if request.method == 'POST':
#            hospital_id = request.form['hospital_id']
#            date = request.form['date']
#            time = request.form['time']
#
#            cursor.execute(
#                "INSERT INTO APPOINTMENTS (USER_ID, DONOR_ID, HOSPITAL_ID, DATE, TIME) VALUES (%s, %s, %s, %s, %s)",
#                (user_id, donor_id, hospital_id, date, time)
#            )
#            conn.commit()
#            flash('Appointment booked successfully!', 'success')
#
#        cursor.close()
#        conn.close()
#
#        return render_template('donor_profile.html', donor=donor, blood_requests=blood_requests)
#    else:
#        flash('Unauthorized access!', 'danger')
#        return redirect('/')

#@app.route('/donor_profile', methods=['GET', 'POST'])
#def donor_profile():
#    if 'loggedin' in session and session['role'] == 'Donor':
#        user_id = session['user_id']
#
#        # Connect to the database
#        conn = get_db_connection()
#        cursor = conn.cursor(dictionary=True)
#
#        # Fetch donor details
#        cursor.execute(
#            "SELECT d.NAME, d.BLOOD_TYPE, l.CITY FROM DONORS d "
#            "JOIN LOCATIONS l ON d.LOCATION_ID = l.LOCATION_ID WHERE d.USER_ID = %s",
#            (user_id,)
#        )
#        donor = cursor.fetchone()
#
#        if not donor:
#            # Debug donor query
#            print(f"Donor query failed for USER_ID: {user_id}")
#            flash('No donor details found for this user.', 'danger')
#            return redirect('/index')
#
#        # Fetch blood requests matching donor's blood type and city
#        cursor.execute(
#            """
#            SELECT br.BLOOD_TYPE, br.QUANTITY, br.REQUESTED_DATE, h.NAME AS HOSPITAL_NAME, l.CITY, br.HOSPITAL_ID
#            FROM BLOOD_REQUESTS br
#            JOIN HOSPITALS h ON br.HOSPITAL_ID = h.HOSPITAL_ID
#            JOIN LOCATIONS l ON h.LOCATION_ID = l.LOCATION_ID
#            WHERE br.BLOOD_TYPE = %s AND l.CITY = %s
#            """,
#            (donor['BLOOD_TYPE'], donor['CITY'])
#        )
#        blood_requests = cursor.fetchall()
#
#        if not blood_requests:
#            # Debug blood requests query
#            print(f"No blood requests found for BLOOD_TYPE: {donor['BLOOD_TYPE']} and CITY: {donor['CITY']}")
#
#        # Handle appointment booking
#        if request.method == 'POST':
#            hospital_id = request.form['hospital_id']
#            date = request.form['date']
#            time = request.form['time']
#
#            cursor.execute(
#                "INSERT INTO APPOINTMENTS (USER_ID, DONOR_ID, HOSPITAL_ID, DATE, TIME) VALUES (%s, %s, %s, %s, %s)",
#                (user_id, user_id, hospital_id, date, time)
#            )
#            conn.commit()
#            flash('Appointment booked successfully!', 'success')
#
#        cursor.close()
#        conn.close()
#
#        return render_template('donor_profile.html', donor=donor, blood_requests=blood_requests)
#    else:
#        flash('Unauthorized access!', 'danger')
#        return redirect('/')



# Hospital Dashboard
@app.route('/hospital_dashboard', methods=['GET', 'POST'])
def hospital_dashboard():
    if 'loggedin' in session and session['role'] == 'Hospital':
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Fetch the hospital_id using the user_id stored in the session
        cursor.execute("SELECT hospital_id FROM hospitals WHERE user_id = %s", (session['user_id'],))
        hospital = cursor.fetchone()

        if not hospital:
            flash('You are not registered as a hospital.', 'danger')
            return redirect('/')

        hospital_id = hospital['hospital_id']  # Extract the correct hospital_id

        if request.method == 'POST':
            # Handling blood request submission
            if 'blood_type' in request.form:
                blood_type = request.form['blood_type']
                quantity = request.form['quantity']
                request_date = datetime.now()

                cursor.execute(
                    "INSERT INTO blood_requests (hospital_id, blood_type, quantity, requested_date, status) VALUES (%s, %s, %s, %s, %s)",
                    (hospital_id, blood_type, quantity, request_date, 'Open')
                )
                conn.commit()
                flash('Blood request submitted successfully!', 'success')

            # Handling appointment management
            elif 'appointment_id' in request.form:
                appointment_id = request.form['appointment_id']
                request_id = request.form['request_id']

                # Mark appointment as managed
                cursor.execute(
                    "UPDATE appointments SET status = 'Confirmed' WHERE appointment_id = %s", (appointment_id,)
                )

                # Update the status of the blood request to 'Fulfilled'
                cursor.execute(
                    "UPDATE blood_requests SET status = 'Fulfilled' WHERE request_id = %s", (request_id,)
                )
                conn.commit()
                flash('Appointment managed successfully! Blood request marked as fulfilled.', 'success')

        # Fetch appointments scheduled by donors for this hospital
               # Fetch appointments scheduled by donors for this hospital
        cursor.execute("""
            SELECT DISTINCT a.appointment_id, d.name AS donor_name, a.date, a.time, d.contact_info, d.blood_type, br.request_id
            FROM Appointments a
            JOIN Donors d ON a.donor_id = d.donor_id
            JOIN blood_requests br ON br.hospital_id = a.hospital_id AND br.blood_type = d.blood_type
            WHERE a.hospital_id = %s AND a.status = 'pending' AND br.status = 'Open'
        """, (hospital_id,)) 
        appointments = cursor.fetchall()



        # Fetch open blood requests made by the hospital
        cursor.execute("""
            SELECT request_id, blood_type, quantity, requested_date, status
            FROM blood_requests
            WHERE hospital_id = %s AND status = 'Open'
        """, (hospital_id,))
        blood_requests = cursor.fetchall()

        cursor.close()
        conn.close()

        return render_template(
            'hospital_dashboard.html',
            appointments=appointments,
            blood_requests=blood_requests
        )
    else:
        flash('Unauthorized access!', 'danger')
        return redirect('/')
    


# Search Page
@app.route('/search', methods=['GET', 'POST'])
def search():
    if request.method == 'POST':
        search_term = request.form['search']
        search_by = request.form['search_by']

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        if search_by == 'blood_type':
            # Search by blood type and show relevant donor details
            cursor.execute("""
                SELECT u.user_id, u.username, d.donor_id, d.name, d.blood_type, l.city, d.contact_info
                FROM Users u
                JOIN Donors d ON u.user_id = d.user_id
                JOIN Locations l ON d.location_id = l.location_id
                WHERE d.blood_type = %s
            """, (search_term,))
        
        elif search_by == 'location':
            # Search by city and show relevant donor details from that city
            cursor.execute("""
                SELECT u.user_id, u.username, d.donor_id, d.name, d.blood_type, l.city, d.contact_info
                FROM Users u
                JOIN Donors d ON u.user_id = d.donor_id
                JOIN Locations l ON d.location_id = l.location_id
                WHERE l.city LIKE %s
            """, (f"%{search_term}%",))

        results = cursor.fetchall()
        cursor.close()
        conn.close()

        return render_template('search.html', results=results, search_by=search_by)

    return render_template('search.html')

# Appointment Scheduling
@app.route('/appointments')
def appointments():
    return render_template('appointments.html')

# Logout
@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'info')
    return redirect('/index')

if __name__ == '__main__':
    app.run(debug=True)
