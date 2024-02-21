import pandas as pd
import os
from rdflib import Graph, Namespace, RDF, RDFS, Literal, URIRef

# RDFLib setup
g = Graph()
hh = Namespace("http://hyperhamlet.unibas.ch/rdf-schema#")
g.bind("hh", hh)

# Specify the directory containing CSV files
directory_path = 'classes_mysql_export_cleaned/'

# Ensure the output directory exists, otherwise create it
output_dir = 'classes_ttl/'
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Function to create a safe URI fragment from name and prefix
def create_uri(name, prefix, namespace):
    # Truncate name to a maximum of 30 characters
    truncated_name = name[:30] if len(name) > 30 else name
    safe_name = (truncated_name
                 .replace(" ", "_")
                 .replace("(", "")
                 .replace(")", "")
                 .replace("'", "")
                 .replace("/", "_")
                 .replace(",", "")
                 .replace('"', "")
                 .replace(":", "")
                 .replace("__", "_")  # Replace double underscores, which might occur after previous replacements
                 .replace("&#039;", "_")) # replace HTML tag with underscore since no apostrophes are allowed in URIs
    return URIRef(namespace + prefix.upper() + "_" + safe_name)

# Find all CSV files in the specified directory
csv_files = [os.path.join(directory_path, f) for f in os.listdir(directory_path) if f.endswith('.csv')]

# Load basic ontology to find the superclass URIs
basic_ontology = Graph()
basic_ontology_path = 'basic_ontology.ttl'
basic_ontology.parse(basic_ontology_path, format='turtle')

# Function to find superclass URI for a given prefix
def find_superclass_uri(prefix, graph):
    for s, _, _ in graph.triples((None, RDF.type, RDFS.Class)):
        if s.split('#')[-1].lower() == prefix.lower():
            return s
    return None

# Loop through each CSV file
for file_path in csv_files:
    g = Graph()
    g.bind("hh", hh)
    
    df = pd.read_csv(file_path)
    entities_dict = df.to_dict(orient='records')
    
    prefix = os.path.basename(file_path).split('.')[0]
    
    # Find the superclass URI based on the prefix
    superclass_uri = find_superclass_uri(prefix, basic_ontology)
    
    for entry in entities_dict:
        class_uri = create_uri(entry['name'], prefix, str(hh))
        
        if pd.isnull(entry['parent']):
            g.add((class_uri, RDF.type, RDFS.Class))
            # Make it subclass of the superclass if one is found
            if superclass_uri:
                g.add((class_uri, RDFS.subClassOf, superclass_uri))
        else:
            # Convert parent_id to float for comparison, as it appears in CSV as float (%todo: fixable)
            parent_id = float(entry['parent'])  
            # Find the parent entry using float comparison
            parent_entry = next((e for e in entities_dict if float(e['id']) == parent_id), None)
            if parent_entry:
                parent_uri = create_uri(parent_entry['name'], prefix, str(hh))
                g.add((class_uri, RDF.type, RDFS.Class))
                g.add((class_uri, RDFS.subClassOf, parent_uri))
            else:
                print(f"No parent found for {entry['name']} with parent ID {entry['parent']}. Created as class.")
                if superclass_uri:
                    g.add((class_uri, RDF.type, RDFS.Class))
                    g.add((class_uri, RDFS.subClassOf, superclass_uri))

    ttl_filename = os.path.join(output_dir, prefix + '.ttl')
    g.serialize(destination=ttl_filename, format="turtle")

