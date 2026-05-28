from flask import Flask, render_template, request, redirect, session
import sqlite3
import os

app = Flask(__name__)
app.secret_key = "ebook_secret"

UPLOAD_FOLDER = "static/books"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

# Ensure upload folder exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

# ---------------- DATABASE ----------------
def get_db():
    conn = sqlite3.connect("database.db")
    conn.row_factory = sqlite3.Row
    return conn

# ---------------- FRONT PAGE / HOME ----------------
@app.route("/")
def home():
    return render_template("index.html")  # Welcome page

# ---------------- LOGIN ----------------
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        role = request.form["role"]

        conn = get_db()
        cur = conn.cursor()

        if role == "admin":
            cur.execute(
                "SELECT * FROM admin WHERE username=? AND password=?",
                (username, password)
            )
            admin = cur.fetchone()
            conn.close()

            if admin:
                session["admin"] = username
                return redirect("/admin")
        else:
            cur.execute(
                "SELECT * FROM users WHERE username=? AND password=?",
                (username, password)
            )
            user = cur.fetchone()
            conn.close()

            if user:
                session["user"] = username
                return redirect("/user")

        return "❌ Invalid Login Details"

    return render_template("login.html")

# ---------------- USER REGISTRATION ----------------
@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        conn = get_db()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO users (username, password) VALUES (?, ?)",
            (username, password)
        )
        conn.commit()
        conn.close()

        return redirect("/login")

    return render_template("register.html")

# ---------------- ADMIN DASHBOARD ----------------
@app.route("/admin")
def admin_dashboard():
    if "admin" not in session:
        return redirect("/login")
    return render_template("admin.html")

# ---------------- UPLOAD BOOK ----------------
@app.route("/upload", methods=["GET", "POST"])
def upload():
    if "admin" not in session:
        return redirect("/login")

    if request.method == "POST":
        title = request.form["title"]
        author = request.form["author"]
        book = request.files["book"]

        if book.filename == "":
            return "❌ No file selected"

        filename = book.filename
        book.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))

        conn = get_db()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO books (title, author, filename) VALUES (?, ?, ?)",
            (title, author, filename)
        )
        conn.commit()
        conn.close()

        return "✅ Book Uploaded Successfully"

    return render_template("upload.html")

# ---------------- USER DASHBOARD ----------------
@app.route("/user")
def user_dashboard():
    if "user" not in session:
        return redirect("/login")

    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM books")
    books = cur.fetchall()
    conn.close()

    return render_template("user.html", books=books)

# ---------------- LOGOUT ----------------
@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")

# ---------------- RUN ----------------
if __name__ == "__main__":
    app.run(debug=True)
