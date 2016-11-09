# turn bourne shell into an awk string

# remove comments
s/#.*//

# remove leading whitespace
s/^[ 	]*//

# remove blank lines
/^$/d

# escape all backslashes
s/\\/\\\\/g

# escape all double quotes
s/"/\\"/g

# shell escape all single quotes
s/'/'\\''/g

# add opening doublequote to the start
s/^/"/

# add closing doublequote and awk line continuation to the end
s/$/\\n" \\/
