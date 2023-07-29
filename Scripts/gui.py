#!/bin/python3

# GUI
import tkinter as tk
from tkinter import ttk
from tkinter import filedialog as fd
import openpyxl
import shutil

# Root window
root = tk.Tk()
root.title('Display a Text File')
root.resizable(False, False)
root.geometry('550x250')

# Text editor
text = tk.Text(root, height=12)
text.grid(column=0, row=0, sticky='nsew')

def open_text_file():
    # file type
    filetypes = (
        ('Excel files', '*.xlsx'),
        ('All files', '*.*')
    )
    # show the open file dialog
    filepath = fd.askopenfilename(filetypes=filetypes)
    
    if filepath:
        # Create the new file path with "INV_" as the prefix
        new_filepath = "INV_" + filepath
        
        # Copy the original file to the new file path
        shutil.copyfile(filepath, new_filepath)
        
        # Update the text widget with the new file path
        text.delete('1.0', tk.END)
        text.insert(tk.END, new_filepath)

# open file button
open_button = ttk.Button(
    root,
    text='Open a File',
    command=open_text_file
)

open_button.grid(column=0, row=1, sticky='w', padx=10, pady=10)

# run the application
root.mainloop()
