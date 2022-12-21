import math
def quadratic(a, b, c):
    discriminant = int(b**2-(4*a*c))
    if discriminant < 0:
        discriminant = 0 - discriminant
        add_i = True
    else:
        add_i = False
    discriminant_val = square_rooting_with_roots(discriminant)
    # part 2: get the bits and bobs in order
    top_other = -b
    bottom = 2*a
    part_one = fractionalize(top_other, bottom)
    part_two = fractionalize(discriminant_val[0], bottom)
    root_bit = str(discriminant_val[1])
    if root_bit != "1":
        root_bit = "√" + root_bit
    else:
        root_bit = ""
    # part 3: format
    if add_i:
        return part_one + " +- " + part_two + root_bit + "i"
    else:
        return part_one + " +- " + part_two + root_bit

# this is basically a square rooting function right here, extracted from below function. outputs [int,root]
def square_rooting_with_roots(a):
    b = a
    int_bit = 1
    for i in range (2,int(math.sqrt(b))+1,1):
        while b % i**2 == 0:
            int_bit *= i
            b /= (i**2)
    return [int_bit,int(b)]
# prime factoriztion function, inspired off the internet. outputs list of prime factors.
def prime_factorization(a):
    b = a
    factorization = []
    if b<0:
        b = -b
        factorization.append(-1)
    for i in range(2, b+1,1):
        while b % i == 0:
            factorization.append(i)
            b /= i
    return factorization
# i need to manually find the overlap of these 2 lists because they friggin intersect literally shaking and crying rn
def merge_lists(a,b):
    merge = []
    for item in a:
        if item in b:
            merge.append(item)
            b.remove(item)
    return merge
# returns the simplified form of a fraction a/b, using LCM. outputs num/deno, or just int. As strings.
def fractionalize(a,b):
    a_fact = prime_factorization(a)
    b_fact = prime_factorization(b)
    lcm = 1
    #stole this too off the internet, thats normal right
    lcm_list = merge_lists(a_fact,b_fact)
    for item in lcm_list:
        lcm *= item
    if a/lcm == 0:
        return "0"
    elif b/lcm == 1:
        return str(int(a/lcm))
    elif b/lcm == -1:
        return str(int(-a/lcm))
    else:
        return str(int(a/lcm)) + "/" + str(int(b/lcm))


#the UI part of the video
#oh god...
import tkinter as tk
window = tk.Tk()
window.geometry("200x200")
#ui
def compute():
    a_in = entry_a.get()
    b_in = entry_b.get()
    c_in = entry_c.get()
    try:
        answer = quadratic(int(a_in), int(b_in), int(c_in))
        lbl_out.configure(text=str(answer))
    except ValueError:
        lbl_out.configure(text="ERROR! Integers Only Please.")
def clear():
    entry_a.delete(0,tk.END)
    entry_b.delete(0, tk.END)
    entry_c.delete(0, tk.END)
#top label
frame1 = tk.Frame(master = window,relief = tk.RIDGE, borderwidth = 5)
lbl_title = tk.Label(text="Quadratic Formula Calculator", bg = "#3b3636",fg = "white", master = frame1)
lbl_title.pack(fill = tk.X)
frame1a = tk.Frame(master=window)
lbl_thing = tk.Label(text = "ax²+bx+c = 0", master = frame1a)
lbl_thing.pack(fill = tk.X)
#middle grid thing
frame2 = tk.Frame(master = window)
for i in range(3):
    letter = "a"
    if i == 1:
        letter = "b"
    elif i == 2:
        letter = "c"
    lbl = tk.Label(master = frame2, text = letter + ":", borderwidth = 1,width = 2)
    lbl.grid(row=i, column=0, sticky = "e")
frame2.columnconfigure(1, weight=1, minsize=180)
entry_a = tk.Entry(master = frame2, borderwidth = 1, relief = tk.GROOVE)
entry_a.grid(row=0,column = 1,sticky = "ew")
entry_b = tk.Entry(master = frame2, borderwidth = 1, relief = tk.GROOVE)
entry_b.grid(row=1,column = 1,sticky = "ew")
entry_c = tk.Entry(master = frame2, borderwidth = 1, relief = tk.GROOVE)
entry_c.grid(row=2,column = 1,sticky = "ew")
#compute and clear buttons
frame3 = tk.Frame(master= window, borderwidth = 5, relief = tk.RAISED,bg = "#3b3636")
btn_compute = tk.Button(master=frame3, text = "Compute!", bg="green", fg= "white", relief = tk.RAISED,command = compute)
btn_compute.pack(side = tk.LEFT, padx = 10,ipadx = 5)
btn_clear = tk.Button(master=frame3, text = "Clear", bg="red", fg= "white", relief = tk.RAISED, command = clear)
btn_clear.pack(side = tk.RIGHT, padx = 10, ipadx = 5)
#output zone
frame4 = tk.Frame(master = window, borderwidth = 5, relief = tk.SUNKEN)
lbl_x = tk.Label(master = frame4, text="x= ", width = 3)
lbl_x.grid(row=0, column = 0, sticky = "e")
lbl_out = tk.Label(master = frame4, text="Press Compute when done.")
lbl_out.grid(row=0, column = 1, sticky = "w")

lbl_name = tk.Label(master=window, text = "Made by Andy Chang")
lbl_name.config(font=("Comic Sans",8))

#packaging
frame1.pack(fill = tk.X)
frame1a.pack(fill = tk.X)
frame2.pack(fill = tk.X)
frame3.pack(fill = tk.X, ipady = 5)
frame4.pack(fill = tk.X)
lbl_name.pack(fill=tk.X, side = tk.RIGHT)
window.mainloop()