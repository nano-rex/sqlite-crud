def open_folder():
    global filepath1
    filepath1 = filedialog.askopenfilename(filetypes=[("Excel Files", "*.xlsx")])
