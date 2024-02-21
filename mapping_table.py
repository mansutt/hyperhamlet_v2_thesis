import pandas as pd
from rdflib import Graph, Namespace, RDF, RDFS
import os
import json

# Directories
csv_dir = 'classes_mysql_export_cleaned/'
ttl_dir = 'classes_ttl/'

# Initialize mapping dictionary
mapping_table = {}

# List all CSV files in the cleaned directory
csv_files = [f for f in os.listdir(csv_dir) if f.endswith('.csv')]

for csv_file in csv_files:
    # Derive TTL file name from CSV file name
    ttl_file = csv_file.replace('.csv', '.ttl')
    
    # Read CSV
    df = pd.read_csv(os.path.join(csv_dir, csv_file))
    
    # Load TTL
    g = Graph()
    ttl_path = os.path.join(ttl_dir, ttl_file)
    g.parse(ttl_path, format="turtle")
    
    # Extract RDF classes from TTL file
    classes = [s for s in g.subjects(RDF.type, RDFS.Class)]
    
    # Match CSV rows to TTL classes based on their position
    for i, row in df.iterrows():
        if i < len(classes):
            csv_name = row['name']
            class_uri = classes[i]
            # Save the match in the mapping table
            mapping_table[csv_name] = class_uri
        else:
            print(f"No matching class for {csv_name} in {ttl_file}")


# Specify path for the output JSON file
output_json_path = 'mapping_table.json'

# Save mapping table as JSON
with open(output_json_path, 'w') as json_file:
    json.dump(mapping_table, json_file)
