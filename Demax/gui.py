def open_folder():
    global filepath1
    initialdir = "/path/to/default/directory"  # Set the default directory here
    filepath1 = filedialog.askopenfilename(initialdir=initialdir, filetypes=[("Excel Files", "*.xlsx")])
