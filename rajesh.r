import requests
import tkinter as tk
from tkinter import messagebox

API_KEY = "YOUR_API_KEY_HERE"     # <-- Put your API key here

def get_weather(city=None):
    city_name_input = city if city else city_entry.get()

    if city_name_input == "":
        messagebox.showwarning("Input Error", "Please enter city name")
        return

    url = f"http://api.openweathermap.org/data/2.5/weather?q={city_name_input}&appid={API_KEY}&units=metric"

    try:
        data = requests.get(url).json()

        if data["cod"] != 200:
            messagebox.showerror("Error", "City not found")
            return

        city_name.set(data['name'])
        temperature.set(str(data['main']['temp']) + " °C")
        weather_desc.set(data['weather'][0]['description'].title())
        humidity.set(str(data['main']['humidity']) + " %")
        wind.set(str(data['wind']['speed']) + " m/s")

    except:
        messagebox.showerror("Error", "Check internet connection or API")


# ---------- GUI ----------
root = tk.Tk()
root.title("Weather Forecasting App")
root.geometry("480x560")
root.config(bg="#0F172A")

# ---- Center Window ----
root.update_idletasks()
w = root.winfo_width()
h = root.winfo_height()
x = (root.winfo_screenwidth() // 2) - (w // 2)
y = (root.winfo_screenheight() // 2) - (h // 2)
root.geometry(f"+{x}+{y}")

# ---- Gradient Header ----
header = tk.Canvas(root, width=500, height=90, highlightthickness=0)
header.pack()

for i in range(90):
    color = "#1E293B"
    header.create_line(0, i, 500, i, fill=color)

header.create_text(240, 40, text="🌦 Weather Forecasting App",
                   fill="white", font=("Segoe UI", 18, "bold"))

# ---- Input Section ----
city_label = tk.Label(root, text="Enter City Name", font=("Segoe UI", 11),
                      bg="#0F172A", fg="#E5E7EB")
city_label.pack(pady=(10, 5))

city_entry = tk.Entry(root, font=("Segoe UI", 12), width=25, relief="flat",
                       bg="#1F2937", fg="white", insertbackground="white")
city_entry.pack(pady=5, ipady=5)

btn = tk.Button(root, text="Get Weather", font=("Segoe UI", 11, "bold"),
                bg="#10B981", fg="white", activebackground="#059669",
                relief="flat", command=get_weather, width=18)
btn.pack(pady=10)


# -------------- KARNATAKA CITY BUTTONS --------------
karnataka_frame = tk.LabelFrame(root, text="Karnataka Popular Cities",
                                bg="#0F172A", fg="white", padx=10, pady=10)
karnataka_frame.pack(pady=5)

cities = [
    "Bengaluru", "Mysuru", "Mangaluru",
    "Hubballi", "Belagavi", "Kalaburagi",
    "Shivamogga", "Ballari", "Davangere", "Udupi"
]

row = 0
col = 0
for city in cities:
    tk.Button(karnataka_frame, text=city,
              font=("Segoe UI", 9, "bold"),
              bg="#1F2937", fg="#93C5FD",
              relief="flat", width=13,
              command=lambda c=city: get_weather(c)
              ).grid(row=row, column=col, padx=5, pady=3)

    col += 1
    if col == 2:
        col = 0
        row += 1


# ---- Card Box ----
card = tk.Frame(root, bg="#111827", width=350, height=250)
card.pack(pady=10)
card.pack_propagate(False)

city_name = tk.StringVar()
temperature = tk.StringVar()
weather_desc = tk.StringVar()
humidity = tk.StringVar()
wind = tk.StringVar()

title = tk.Label(card, textvariable=city_name, font=("Segoe UI", 16, "bold"),
                 bg="#111827", fg="#38BDF8")
title.pack(pady=5)

tk.Label(card, textvariable=temperature, font=("Segoe UI", 32, "bold"),
         bg="#111827", fg="#FBBF24").pack()

tk.Label(card, textvariable=weather_desc, font=("Segoe UI", 14),
         bg="#111827", fg="#A5B4FC").pack(pady=5)

info_frame = tk.Frame(card, bg="#111827")
info_frame.pack(pady=5)

tk.Label(info_frame, text="Humidity: ", font=("Segoe UI", 12),
         bg="#111827", fg="#D1D5DB").grid(row=0, column=0, sticky="w")
tk.Label(info_frame, textvariable=humidity, font=("Segoe UI", 12, "bold"),
         bg="#111827", fg="#93C5FD").grid(row=0, column=1)

tk.Label(info_frame, text="Wind: ", font=("Segoe UI", 12),
         bg="#111827", fg="#D1D5DB").grid(row=1, column=0, sticky="w", pady=5)
tk.Label(info_frame, textvariable=wind, font=("Segoe UI", 12, "bold"),
         bg="#111827", fg="#FCA5A5").grid(row=1, column=1)

footer = tk.Label(root, text="Developed by Rishi",
                  font=("Segoe UI", 10), bg="#0F172A", fg="#6B7280")
footer.pack(side="bottom", pady=10)

root.mainloop()