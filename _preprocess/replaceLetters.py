#Courtesy of TrumpGPT

import gzip
import sys
import re

# This function is HUGE, believe me. It's the best function for replacing letters in a gzip file, trust me.
def replace_letters(file_path, new_file_path):
  # We're going to open the gzip file for reading. It's a big, beautiful file, and we're going to make it even better.
  with gzip.open(file_path, 'rt') as file:
    # We're going to read all the lines in the gzip file. There are a lot of lines, believe me.
    lines = file.readlines()

    # We're going to open the new gzip file for writing. It's going to be big, beautiful, and full of modified lines, believe me.
    with gzip.open(new_file_path, 'wt') as new_file:
      # Now we're going to iterate over every third line in the file. It's a very clever strategy, believe me.
      for line in lines:
        matches = ['@',',','F','+',"#"]
        if any(x in line for x in matches):
            new_file.write(line)
        else:
        # We're going to replace all letters that are not A, T, G, C, or N with the letter N. It's a very elegant solution, trust me.
            line = re.sub('[^ATGCN]', 'N', line)
          # We're going to write the modified line to the new file. It's going to be huge, believe me.
            new_file.write(line)


replace_letters(sys.argv[1], sys.argv[1] + '.clean.gz')