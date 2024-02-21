import re

# search for terms enclosed in <>
pattern = re.compile(r'\s<([^>]+)>')
# search for strings starting with ^^xsd:string and optionally ending with ;
exclude_pattern = re.compile(r'\^\^xsd:string\s*;?$')

file_path = 'mysql_import.ttl'  

def line_needs_check(line):
    """Determines if a line does not end with ^^xsd:string and thus needs further checking."""
    return not exclude_pattern.search(line)

with open(file_path, 'r', encoding='utf-8') as file:
    for line_number, line in enumerate(file, 1):
        # Check if line ends with ^^xsd:string; if not, then check for potential IRI issues
        if line_needs_check(line) and pattern.search(line):
            print(f"Line {line_number} might have issues: {line.strip()}")
