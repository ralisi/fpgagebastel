from struct import *

print "memory_initialization_radix=16;"
print "memory_initialization_vector=",
f = open("blink.bin", "rb")
bytes = f.read()
output = ""
for i in range(0,len(bytes), 4):
    output += "\n"
    number = unpack (">I", bytes[i:i+4])[0]
    output += "{0:08X}".format(number)
    output += ","

print output[:-1] + ";"
