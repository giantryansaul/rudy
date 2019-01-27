max_str = 30

with open("input.txt", "r") as f:
    text = f.readlines()

new_lines=[]

for line in text:
    new_lines.append(line.strip("\n"))

print("\\n".join(new_lines))
