#!/bin/python3

import tkinter as tk
from tkinter import ttk
from tkinter import filedialog as fd
import pandas as pd
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
        def add_prefix_to_last_word(text, prefix):
           words = text.split("/") # Split the text by forward slashes
           last_word = words[-1] # Get the last word after the last forward slash
           new_last_word = prefix + last_word # Add the prefix to the last word
           words[-1] = new_last_word # Replace the last word with the updated one 
           modified_text = "/".join(words) # Join the words back together with forward slashes
           return modified_text
        text = filepath
        prefix = "INV_"
        new_filepath = add_prefix_to_last_word(filepath, prefix)
        shutil.copyfile(filepath, new_filepath)
        
        # Update the text widget with the new file path
        text.delete('1.0', tk.END)
        text.insert(tk.END, new_filepath)
        
        # Call the xlsx() function to perform the desired operations
        xlsx()

def xlsx(): 
     shutil.copyfile('/home/user/Templates/INV_GCH.xlsx', new_filepath) # Copy Invoice template as destination xlsx

     df = pd.read_excel(filepath, sheet_name='Sheet1', header=None)
     # Rest of the code...

# open file button
open_button = ttk.Button(
    root,
    text='Open a File',
    command=open_text_file
)

open_button.grid(column=0, row=1, sticky='w', padx=10, pady=10)

# run the application
root.mainloop()
