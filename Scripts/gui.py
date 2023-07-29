import tkinter as tk
from tkinter import filedialog
import pandas as pd
import os

def add_text_to_xlsx():
    # Open file dialog to select .xlsx file
    file_path = filedialog.askopenfilename(filetypes=[("Excel files", "*.xlsx")])
    
    if file_path:
        # Read the original file
        df = pd.read_excel(file_path)
        
        # Add "testing" to the bottom line
        df.loc[len(df)] = ["testing"]
        
        # Create the new file path with "INV_" as the prefix
        file_dir, file_name = os.path.split(file_path)
        new_file_name = f"INV_{file_name}"
        new_file_path = os.path.join(file_dir, new_file_name)
        
        # Save the modified dataframe as a new .xlsx file
        df.to_excel(new_file_path, index=False)
        
        # Show a message box with the new file path
        tk.messagebox.showinfo("File Saved", f"The modified file has been saved as:\n{new_file_path}")

# Create the GUI window
window = tk.Tk()
window.title("Add Text to XLSX")
window.geometry("300x100")

# Create the button
button = tk.Button(window, text="Select XLSX File", command=add_text_to_xlsx)
button.pack(pady=20)

# Run the GUI window
window.mainloop()
