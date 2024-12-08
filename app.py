#admin
import logging
from flask import Flask, render_template, request, redirect, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
import mysql.connector
import traceback

app = Flask(__name__)
app.secret_key = 'your_secret_key'

    # Database connection details
db_config = {
        'user': 'root',
        'password': '42692',
        'host': 'localhost',
        'database': 'bd'
    }
logging.basicConfig(
    filename='login_logs.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
def log_event_to_db(user_id, event_type, description):
    conn = get_db_connection()
    cursor = conn.cursor()
    timestamp = datetime.now()
    cursor.execute(
        """
        INSERT INTO Logs (user_id, event_type, description, timestamp)
        VALUES (%s, %s, %s, %s)
        """,
        (user_id, event_type, description, timestamp)
    )
    conn.commit()
    cursor.close()
    conn.close()
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
        try:
            # Check if the username already exists
            cursor.execute("SELECT * FROM USERS WHERE USERNAME = %s", (username,))
            existing_user = cursor.fetchone()

            if existing_user:
                flash('Username already exists. Please choose another one.', 'danger')
                return render_template('register.html')  # Stay on the same page if username is taken

            # Check if location exists
            cursor.execute(
                "SELECT LOCATION_ID FROM LOCATIONS WHERE CITY=%s AND STATE=%s AND ZIP_CODE=%s",
                (city, state, zip_code)  # Adjusted for correct variables
            )
            location = cursor.fetchone()

            if not location:
                # Insert new location if it doesn't exist
                cursor.execute(
                    "INSERT INTO LOCATIONS (CITY, STATE, ZIP_CODE) VALUES (%s, %s, %s)",
                    (city, state, zip_code)
                )
                conn.commit()
                location_id = cursor.lastrowid
            else:
                location_id = location['LOCATION_ID']

            # Insert into Users table
            cursor.execute(
                "INSERT INTO USERS (USERNAME, PASSWORD, ROLE, EMAIL) VALUES (%s, %s, %s, %s)",
                (username, password, role, email)
            )
            conn.commit()
            user_id = cursor.lastrowid

            # Insert into Donors or Hospitals table based on role
            if role == 'Donor':
                blood_type = request.form['blood_type']
                cursor.execute(
                    "INSERT INTO DONORS (USER_ID, NAME, CONTACT_INFO, LOCATION_ID, BLOOD_TYPE) VALUES (%s, %s, %s, %s, %s)",
                    (user_id, name, contact_info, location_id, blood_type)
                )
                conn.commit()
                flash('Registration successful! Please login.', 'success')
            elif role == 'Hospital':
                cursor.execute(
                    "INSERT INTO HOSPITALS (USER_ID, NAME, CONTACT_INFO, LOCATION_ID) VALUES (%s, %s, %s, %s)",
                    (user_id, name, contact_info, location_id)
                )
                conn.commit()
                flash('Registration successful! Please login.', 'success')
            return render_template('register.html', redirect_to_login=True)
        except mysql.connector.Error as e:
            # Handle any database errors
            flash(f'Database error: {str(e)}', 'danger')
            conn.rollback()  # Rollback in case of error

        except Exception as e:
            # Handle any unexpected errors
            flash(f'An unexpected error occurred: {str(e)}', 'danger')

        finally:
            cursor.close()
            conn.close()

        return render_template('register.html')  # Stay on the same page after registration

    return render_template('register.html')




# Login Page


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        try:
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)

            # Execute query to fetch the user by username
            cursor.execute("SELECT user_id, username, password, role, active FROM Users WHERE username = %s", (username,))
            user = cursor.fetchone()

            if user and user['active']==1 and check_password_hash(user['password'], password):
                # Update last_login timestamp on successful login
                cursor.execute("UPDATE Users SET last_login = %s WHERE user_id = %s", (datetime.now(), user['user_id']))
                
                conn.commit()

                # Set session variables
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
                # Log failed login attempt manually
                flash('invalid username or password')
                try:
                    cursor.execute("INSERT INTO Logs (user_id, event_type, description) VALUES (%s, %s, %s)",
                    (None, 'Login', f"Failed login attempt for username: {username}.")
                                 )
                    conn.commit()
                    print("Log inserted successfully.")  # Debugging
                except mysql.connector.Error as err:
                    print(f"Error inserting log: {err}")

        except mysql.connector.Error as db_error:
            # Handle database errors
            flash(f'Database error: {str(db_error)}', 'danger')
            app.logger.error(f'Database error during login attempt for username: {username}. Error: {str(db_error)}')
        
        except Exception as e:
            # Catch any unexpected errors
            flash('An unexpected error occurred. Please try again later.', 'danger')
            app.logger.error(f'Unexpected error during login attempt for username: {username}. Error: {traceback.format_exc()}')
        
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()

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




@app.route('/admin_dashboard', methods=['GET', 'POST'])
def admin_dashboard():
    if 'loggedin' in session and session['role'] == 'Admin':
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Determine the view to display
        view = request.args.get('view', 'users')  # Default view is 'users'
        viewbr= request.args.get('view','blood_requests')
        viewapp=request.args.get('view','appointments')
        donor_id = request.args.get('donor_id')
        user_status = request.args.get('status', 'active')
        donors = []
        chat = []
        data={}
        if view == 'hospital_chats':
        # Fetch all hospitals who have sent messages
           cursor.execute("""
               SELECT DISTINCT h.hospital_id, h.name
               FROM hospitals h
               JOIN messages m ON h.hospital_id = m.hospital_id
           """)
           hospitals = cursor.fetchall()

    # If a hospital is selected, fetch their chat messages
           if hospital_id:
              cursor.execute("""
                  SELECT sender_role, content, timestamp
                  FROM messages
                  WHERE hospital_id = %s
                  ORDER BY timestamp ASC
              """, (hospital_id,))
              chat = cursor.fetchall()

        elif view == 'donor_chats':
            # Fetch all donors who have sent messages
            cursor.execute("""
                SELECT DISTINCT d.donor_id, d.name
                FROM donors d
                JOIN messages m ON d.donor_id = m.donor_id
            """)
            donors = cursor.fetchall()

            # If a donor is selected, fetch their chat messages
            if donor_id:
                cursor.execute("""
                    SELECT sender_role, content, timestamp AS timestamp
                    FROM messages
                    WHERE donor_id = %s
                    ORDER BY timestamp ASC
                """, (donor_id,))
                chat = cursor.fetchall()

        elif view == 'users':
            # Fetch users based on status
            if user_status == 'active':
                cursor.execute("""
                    SELECT 
                        u.user_id, 
                        u.username, 
                        u.role, 
                        COALESCE(d.name, h.name) AS name, 
                        d.blood_type,
                        u.active
                    FROM Users u
                    LEFT JOIN Donors d ON u.user_id = d.user_id
                    LEFT JOIN Hospitals h ON u.user_id = h.user_id
                    WHERE u.active = 1
                """)
                active_users = cursor.fetchall()
                data['registered_users'] = active_users
            elif user_status == 'inactive':
                cursor.execute("""
                    SELECT 
                        u.user_id, 
                        u.username, 
                        u.role, 
                        COALESCE(d.name, h.name) AS name, 
                        d.blood_type,
                        u.active
                    FROM Users u
                    LEFT JOIN Donors d ON u.user_id = d.user_id
                    LEFT JOIN Hospitals h ON u.user_id = h.user_id
                    WHERE u.active = 0
                """)
                inactive_users = cursor.fetchall()
                data['registered_users'] = inactive_users

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
                FROM blood_requests br where active = 1
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
                FROM appointments a where active = 1
            """)
            appointments = cursor.fetchall()
            data = {'appointments': appointments}

        else:
            data = {}
        if request.method == 'POST' and 'send_reply' in request.form:
            message = request.form['message']
            donor_id = request.form['donor_id']
            if donor_id and message.strip():
                # Insert the admin reply into the messages table
                cursor.execute("""
                    INSERT INTO messages (donor_id, sender_role, content)
                    VALUES (%s, 'Admin', %s)
                """, (donor_id, message))
                conn.commit()
                flash('Reply sent to donor!', 'success')
            else:
                flash('Failed to send reply. Ensure donor is selected and the message is not empty.', 'danger')

            return redirect(f'/admin_dashboard?view=donor_chats&donor_id={donor_id}')
        
        if request.method == 'POST':
            # Handle user soft deletion
            if 'delete_user_id' in request.form:
                user_id = request.form['delete_user_id']
                cursor.execute("UPDATE Users SET active = 0 WHERE user_id = %s", (user_id,))
                cursor.execute("UPDATE Donors SET active = 0 WHERE user_id = %s", (user_id,))
                cursor.execute("UPDATE Hospitals SET active = 0 WHERE user_id = %s", (user_id,))
                conn.commit()
                flash('User deactivated successfully!,kindly refresh ', 'success')
        
            # Handle blood request soft deletion
            elif 'delete_request_id' in request.form:
                request_id = request.form['delete_request_id']
                cursor.execute("UPDATE Blood_Requests SET active = 0 WHERE request_id = %s", (request_id,))
                conn.commit()
                flash('Blood request deactivated successfully!, Kindly refresh', 'success')
                return render_template('admin_dashboard.html', view=viewbr,donors=donors,chat=chat,donor_id=donor_id,**data)
            # Handle appointment soft deletion
            elif 'delete_appointment_id' in request.form:
                appointment_id = request.form['delete_appointment_id']
                cursor.execute("UPDATE Appointments SET active = 0 WHERE appointment_id = %s", (appointment_id,))
                conn.commit()
                flash('Appointment deactivated successfully!, kindly refresh', 'success')
                return render_template('admin_dashboard.html', view=viewapp, **data)
            elif 'activate_user' in request.form:
                user_id = request.form['activate_user']
                cursor.execute("UPDATE Users SET active = 1 WHERE user_id = %s", (user_id,))
                cursor.execute("UPDATE Donors SET active = 1 WHERE user_id = %s", (user_id,))
                cursor.execute("UPDATE Hospitals SET active = 1 WHERE user_id = %s", (user_id,))
                conn.commit()
                flash('user activated successfully!,Kindly refresh', 'success')

        cursor.close()
        conn.close()

        return render_template('admin_dashboard.html', view=view,donors=donors,chat=chat,user_status=user_status,donor_id=donor_id,**data)

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
    
    
       
    
    
    
    
@app.route('/donor_profile', methods=['GET', 'POST'])
def donor_profile():
    if 'loggedin' in session and session['role'] == 'Donor':
        user_id = session['user_id']
        
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT d.donor_id, u.email, d.name, d.contact_info, d.blood_type, l.city, l.state, l.zip_code
            FROM Donors d
            JOIN Users u ON d.user_id = u.user_id
            JOIN Locations l ON d.location_id = l.location_id
            WHERE d.user_id = %s
        """, (user_id,))
        donor = cursor.fetchone()

        if not donor:
            flash('No donor details found for this user.', 'danger')
            return redirect('/index')
        
        donor_id = donor['donor_id']
        contact_admin = request.args.get('contact_admin') == 'true'
        chat = []

        if contact_admin:
            # Fetch chat messages
            cursor.execute("""
                SELECT sender_role, content, timestamp
                FROM messages
                WHERE donor_id = %s
                ORDER BY timestamp ASC
            """, (donor_id,))
            chat = cursor.fetchall()

            # Handle new message
            if request.method == 'POST' and 'send_message' in request.form:
                message = request.form['message']
                cursor.execute("""
                    INSERT INTO messages (donor_id, sender_role, content)
                    VALUES (%s, 'Donor', %s)
                """, (donor_id, message))
                conn.commit()
                flash('Message sent to admin!', 'success')
                return redirect('/donor_profile?contact_admin=true')
        cursor.execute("""
            SELECT message, created_at
            FROM notifications
            WHERE donor_id = %s
            ORDER BY created_at DESC
        """, (donor['donor_id'],))
        notifications = cursor.fetchall()   
        view_appointments = request.args.get('view_appointments') == 'true'
        view_profile = request.args.get('view_profile') == 'true'
        edit_profile = request.args.get('edit_profile') == 'true'
        appointments = []
        if view_appointments:
            cursor.execute("""
                SELECT a.appointment_id, h.name AS hospital_name, a.date, a.time, a.status, d.blood_type
                FROM Appointments a
                JOIN Hospitals h ON a.hospital_id = h.hospital_id
                JOIN Donors d ON a.donor_id = d.donor_id
                WHERE a.donor_id = %s AND a.active=1
                ORDER BY a.date DESC, a.time DESC
            """, (donor['donor_id'],))
            appointments = cursor.fetchall() 
        if request.method == 'POST' and request.form.get('action') == 'edit_profile':
            # Handle profile updates
            name = request.form['name']
            email = request.form['email']
            contact_info = request.form['contact_info']
            blood_type = request.form['blood_type']
            city = request.form['city']
            state = request.form['state']
            zip_code = request.form['zip_code']

            cursor.execute("""
                UPDATE Donors d
                JOIN Users u ON d.user_id = u.user_id
                JOIN Locations l ON d.location_id = l.location_id
                SET d.name = %s, u.email = %s, d.contact_info = %s, d.blood_type = %s, l.city = %s, l.state = %s, l.zip_code = %s
                WHERE d.user_id = %s
            """, (name, email, contact_info, blood_type, city, state, zip_code, user_id))
            conn.commit()
            flash('Profile updated successfully!', 'success')
            return redirect('/donor_profile?view_profile=true')

        # Fetch blood requests
        if donor['blood_type'] == 'O-':
            # Universal donor: fetch all requests matching the city
            cursor.execute("""
                SELECT br.blood_type, br.quantity, br.requested_date, h.name, l.city, br.hospital_id
                FROM blood_requests br
                JOIN Hospitals h ON br.hospital_id = h.hospital_id
                JOIN Locations l ON h.location_id = l.location_id
                WHERE l.city = %s AND br.status = 'Open' AND br.active = 1
            """, (donor['city'],))
        else:
            # Match both blood type and city for other donors
            cursor.execute("""
                SELECT br.blood_type, br.quantity, br.requested_date, h.name, l.city, br.hospital_id
                FROM blood_requests br
                JOIN Hospitals h ON br.hospital_id = h.hospital_id
                JOIN Locations l ON h.location_id = l.location_id
                WHERE br.blood_type = %s AND l.city = %s AND br.status = 'Open' AND br.active=1
            """, (donor['blood_type'], donor['city']))

        blood_requests = cursor.fetchall()

        # Handle appointment booking
        if request.method == 'POST' and 'hospital_id' in request.form:
            hospital_id = request.form['hospital_id']
            date = request.form['date']
            time = request.form['time']

            cursor.execute("""
                INSERT INTO Appointments (donor_id, hospital_id, date, time)
                VALUES (%s, %s, %s, %s)
            """, (donor['donor_id'], hospital_id, date, time))
            conn.commit()
            flash('Appointment booked successfully!', 'success')

        cursor.close()
        conn.close()

        return render_template(
            'donor_profile.html',
            donor=donor,
            blood_requests=blood_requests,
            view_profile=view_profile,
            edit_profile=edit_profile,
            view_appointments=view_appointments,
            appointments=appointments,
            contact_admin=contact_admin,
            chat=chat,
            notifications=notifications
        )
    else:
        flash('You are not logged in or unauthorized to access this page.', 'danger')
        return redirect('/login')





# Hospital Dashboard
@app.route('/hospital_dashboard', methods=['GET', 'POST'])
def hospital_dashboard():
    if 'loggedin' in session and session['role'] == 'Hospital':
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Fetch hospital details
        cursor.execute("""
            SELECT h.hospital_id, h.name AS hospital_name,l.state AS hospital_state, l.city AS hospital_city, h.location_id, u.email as h_email
            FROM hospitals h
            JOIN users u ON h.user_id = u.user_id
            JOIN locations l ON h.location_id = l.location_id
            WHERE h.user_id = %s
        """, (session['user_id'],))
        hospital = cursor.fetchone()

        if not hospital:
            flash('You are not registered as a hospital.', 'danger')
            return redirect('/')

        # Check if the request is for viewing the profile
        edit_profile = request.args.get('edit_profile') == 'true'
        hospital_id = hospital['hospital_id']
        view = request.args.get('view', 'appointments')  # Default view is appointments
        chat = []
        if view == 'chat':
            # Fetch chat messages for this hospital
            cursor.execute("""
                SELECT sender_role, content, timestamp
                FROM messages
                WHERE hospital_id = %s
                ORDER BY timestamp ASC
            """, (hospital_id,))
            chat = cursor.fetchall()

            # Handle sending a message
            if request.method == 'POST' and 'send_message' in request.form:
                message_content = request.form['message']
                if message_content.strip():
                    cursor.execute("""
                        INSERT INTO messages (hospital_id, sender_role, content)
                        VALUES (%s, 'Hospital', %s)
                    """, (hospital_id, message_content))
                    conn.commit()
                    flash('Message sent to Admin!', 'success')
                else:
                    flash('Message cannot be empty.', 'danger')
        if edit_profile:
            if request.method == 'POST':
                # Update hospital information
                hospital_name = request.form['hospital_name']
                hospital_city = request.form['hospital_city']
                h_email = request.form['h_email']
                hospital_state = request.form['hospital_state']

                cursor.execute("""
                    UPDATE hospitals h
                    JOIN locations l ON h.location_id = l.location_id
                    JOIN users u ON h.user_id = u.user_id
                    SET h.name = %s, l.city = %s, u.email = %s, l.state = %s
                    WHERE h.hospital_id = %s
                """, (hospital_name, hospital_city, h_email, hospital_state, hospital['hospital_id']))
                conn.commit()
                flash('Profile updated successfully!', 'success')
                return redirect('/hospital_dashboard?view_profile=true')

            return render_template('hospital_dashboard.html', hospital=hospital, edit_profile=True)

        # Check if the request is for viewing the profile
        view_profile = request.args.get('view_profile') == 'true'

        if view_profile:
            return render_template('hospital_dashboard.html', hospital=hospital, view_profile=True)

        if view_profile:
            # Render only the hospital profile
            return render_template('hospital_dashboard.html', hospital=hospital, view_profile=True)

        hospital_id = hospital['hospital_id']

        if request.method == 'POST':
            # Handle new blood request
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

            # Handle appointment management
            elif 'appointment_id' in request.form:
                appointment_id = request.form['appointment_id']
                request_id = request.form['request_id']

                # Mark appointment as managed
                cursor.execute(
                    "UPDATE appointments SET status = 'Confirmed' WHERE appointment_id = %s", (appointment_id,)
                )

                # Update blood request status to 'Fulfilled'
                cursor.execute(
                    "UPDATE blood_requests SET status = 'Fulfilled' WHERE request_id = %s", (request_id,)
                )
                conn.commit()
                flash('Appointment managed successfully!', 'success')
                cursor.execute("""
                    SELECT donor_id FROM appointments WHERE appointment_id = %s
                """, (appointment_id,))
                donor_id = cursor.fetchone()['donor_id']
                message = "Your appointment with hospital {} has been confirmed, You can visit the Hospital.".format(hospital['hospital_name'])

                cursor.execute("""
                    INSERT INTO notifications (donor_id, message) VALUES (%s, %s)
                """, (donor_id, message))
                conn.commit()
                flash('Appointment managed successfully and notification sent to the donor!', 'success')
            # Handle appointment rejection
            elif 'reject_appointment_id' in request.form:
                reject_appointment_id = request.form['reject_appointment_id']

                # Update appointment status to 'Cancelled'
                cursor.execute(
                    "UPDATE appointments SET status = 'Cancelled' WHERE appointment_id = %s", (reject_appointment_id,)
                )
                conn.commit()
                flash('Appointment rejected successfully!', 'success')
                cursor.execute("""
                    SELECT donor_id FROM appointments WHERE appointment_id = %s
                """, (reject_appointment_id,))
                donor_id = cursor.fetchone()['donor_id']
                message = "Your appointment with hospital {} has been rejected, please select different time and date.".format(hospital['hospital_name'])

                cursor.execute("""
                    INSERT INTO notifications (donor_id, message) VALUES (%s, %s)
                """, (donor_id, message))
                conn.commit()
                flash('Appointment rejected and notification sent to the donor!', 'success')

            # Handle blood request deletion
            elif 'delete_request_id' in request.form:
                delete_request_id = request.form['delete_request_id']

                # Delete the blood request if it is open
                cursor.execute(
                    "UPDATE blood_requests SET active = 0 WHERE request_id = %s AND status = 'Open'", (delete_request_id,)
                )
                conn.commit()
                flash('Blood request deleted successfully.', 'success')

        # Fetch appointments for this hospital
        cursor.execute("""
            SELECT DISTINCT a.appointment_id, d.name AS donor_name, a.date, a.time, d.contact_info, d.blood_type, br.request_id
            FROM appointments a
            JOIN donors d ON a.donor_id = d.donor_id
            JOIN blood_requests br ON br.hospital_id = a.hospital_id AND br.blood_type = d.blood_type OR d.blood_type = 'O-'
            WHERE a.hospital_id = %s AND a.status = 'Pending' AND br.status = 'Open' AND a.active = 1
        """, (hospital_id,))
        appointments = cursor.fetchall()

        # Fetch open blood requests made by this hospital
        cursor.execute("""
            SELECT request_id, blood_type, quantity, requested_date, status
            FROM blood_requests
            WHERE hospital_id = %s AND active = 1
        """, (hospital_id,))
        blood_requests = cursor.fetchall()

        cursor.close()
        conn.close()

        return render_template(
            'hospital_dashboard.html',
            appointments=appointments,
            blood_requests=blood_requests,
            hospital=hospital,
            chat=chat,
            view=view,
            view_profile=False
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

# Logout
@app.route('/logout')
def logout():
    session.clear()
    flash(f'You have been logged out.', 'info')
    return redirect('/login')

if __name__ == '__main__':
    app.run(debug=True)
