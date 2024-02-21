import mysql.connector
from rdflib import Graph, Namespace, RDF, Literal, URIRef, XSD
from datetime import datetime
import json

# MySQL setup
conn = mysql.connector.connect(
    host='localhost', user='root', password='', database='hamlet2_test'
)
cursor = conn.cursor()

# RDFLib setup
g = Graph()
hh = Namespace("http://hyperhamlet.unibas.ch/rdf-schema#")
g.bind("hh", hh)

# Load mapping table from JSON file
with open('mapping_table.json', 'r') as json_file:
    mapping_table = json.load(json_file)

# Function to find the RDF URI based on the mapping table and original MySQL value
def find_rdf_uri(mysql_value):
    base_uri = "http://hyperhamlet.unibas.ch/rdf-schema#"
    mapped_uri = mapping_table.get(mysql_value)
    if mapped_uri:
        return URIRef(mapped_uri) 
    else:
        return None
    
# Define cleaning function
def clean_name(name):
    return name.replace(" ", "_") \
               .replace("(", "") \
               .replace(")", "") \
               .replace("'", "") \
               .replace("/", "_") \
               .replace(",", "") \
               .replace('"', "") \
               .replace(":", "") \
               .replace("-", "") \
               .replace("__", "_")

### IMPORT CONTRIBUTORS

# Ensure the cursor returns dictionary results -> necessary, otherwise no results are returned
cursor = conn.cursor(dictionary=True)

# Query the database for contributors
cursor.execute("SELECT * FROM contributors")
rows = cursor.fetchall()

for row in rows:
    # Using id column from MySQL database as unique identifier for each contributor
    contributor_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#Contributor_{row['id']}")

    # Add triples to the graph
    g.add((contributor_uri, RDF.type, hh.contributors))
    g.add((contributor_uri, hh.ContributorLastName, Literal(row['lastname'], datatype=XSD.string)))
    g.add((contributor_uri, hh.ContributorFirstName, Literal(row['firstname'], datatype=XSD.string)))
    g.add((contributor_uri, hh.ContributorEmail, Literal(row['email'], datatype=XSD.string)))
    g.add((contributor_uri, hh.ContributorEmailPublic, Literal(bool(row['is_public_email']), datatype=XSD.boolean)))

### IMPORT AUTHORS

# Ensure the cursor returns dictionary results
cursor = conn.cursor(dictionary=True)

# Query the database for authors
cursor.execute("SELECT * FROM authors")
rows = cursor.fetchall()

for row in rows:
    author_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#Author_{row['id']}")

    # Add triples to the graph
    g.add((author_uri, RDF.type, hh.authors))
    g.add((author_uri, hh.AuthorLastName, Literal(row['lastname'], datatype=XSD.string)))
    g.add((author_uri, hh.AuthorFirstName, Literal(row['firstname'], datatype=XSD.string)))
    g.add((author_uri, hh.AuthorDescription, Literal(row['description'], datatype=XSD.string)))


# determine gender from table subjects['name']=="WOMAN WRITER" -> Male if not -> empty class "Other" for future use in basic_ontology.ttl if needed (neither female nor male)
# possible problem: this depends on subjects['name']=="WOMAN WRITER" being reliable -> otherwise false gender classifications
cursor.execute("""
SELECT a.id,
       IF(EXISTS(SELECT 1
                 FROM authors_citations ac
                 JOIN citations_subjects cs ON ac.citation_id = cs.citation_id
                 JOIN subjects s ON cs.subject_id = s.id
                 WHERE ac.author_id = a.id AND s.name = 'WOMAN WRITER'),
          'Female', 'Male') AS gender
FROM authors a
""")
gender_rows = cursor.fetchall()

for gender_row in gender_rows:
    author_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#Author_{gender_row['id']}")
    if gender_row['gender'] == 'Female':
        g.add((author_uri, hh.AuthorGender, hh.FemaleAuthor))
    else:
        g.add((author_uri, hh.AuthorGender, hh.MaleAuthor))


### IMPORT CONTRIBUTORS

# Ensure the cursor returns dictionary results
cursor = conn.cursor(dictionary=True)

# Query the database for contributors
cursor.execute("SELECT * FROM contributors")
rows = cursor.fetchall()

for row in rows:
    # Using id column from MySQL database as unique identifier for each contributor
    contributor_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#Contributor_{row['id']}")

    # Add triples to the graph
    g.add((contributor_uri, RDF.type, hh.contributors))
    g.add((contributor_uri, hh.ContributorLastName, Literal(row['lastname'], datatype=XSD.string)))
    g.add((contributor_uri, hh.ContributorFirstName, Literal(row['firstname'], datatype=XSD.string)))
    g.add((contributor_uri, hh.ContributorEmail, Literal(row['email'], datatype=XSD.string)))
    g.add((contributor_uri, hh.ContributorEmailPublic, Literal(bool(row['is_public_email']), datatype=XSD.boolean)))


### IMPORT HAMLETTEXT

# Ensure the cursor returns dictionary results
cursor = conn.cursor(dictionary=True)

# Query the database for hamlettext
cursor.execute("SELECT * FROM hamlettext")
rows = cursor.fetchall()

for row in rows:
    hamlettext_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#HamletText_{row['id']}")

    # Add triples to the graph
    g.add((hamlettext_uri, RDF.type, hh.hamlettext))
    g.add((hamlettext_uri, hh.HamletTextLine, Literal(row['line'], datatype=XSD.string)))
    g.add((hamlettext_uri, hh.HamletTextLineNo, Literal(row['line_no'], datatype=XSD.integer)))
    g.add((hamlettext_uri, hh.HamletTextAct, Literal(row['act'], datatype=XSD.integer)))
    g.add((hamlettext_uri, hh.HamletTextScene, Literal(row['scene'], datatype=XSD.integer)))
    g.add((hamlettext_uri, hh.HamletTextType, Literal(row['type'], datatype=XSD.string)))

    # fetch and link linecategories for this hamlettext
    hamlettext_id = row['id']  # Explicitly capture hamlettext id

    ### LINKS TO LINECATEGORIES
    cursor.execute("""
    SELECT lc.name
    FROM linecategories lc
    JOIN citations_hamlettext cht ON lc.id = cht.linecategory_id
    WHERE cht.hamlettext_id = %s
    """, (hamlettext_id,)) 

    linecategories = cursor.fetchall()

    for linecategory in linecategories:
        cleaned_name = clean_name(linecategory['name'])
        linecategory_uri = find_rdf_uri(cleaned_name)
        if linecategory_uri:
            g.add((hamlettext_uri, hh.HamletTextLineCategory, linecategory_uri))


### IMPORT ROLES

# Ensure the cursor returns dictionary results
cursor = conn.cursor(dictionary=True)

# Query the database for roles
cursor.execute("SELECT * FROM roles")
rows = cursor.fetchall()

for row in rows:
    role_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#Role_{row['id']}")

    # Add triples to the graph
    g.add((role_uri, RDF.type, hh.roles))
    g.add((role_uri, hh.RoleName, Literal(row['name'], datatype=XSD.string)))
    g.add((role_uri, hh.RoleDescription, Literal(row['description'], datatype=XSD.string)))


### IMPORT USERS

# Ensure the cursor returns dictionary results
cursor = conn.cursor(dictionary=True)

# Query the database for users
cursor.execute("SELECT * FROM users")
rows = cursor.fetchall()

for row in rows:
    user_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#User_{row['id']}")

    # Add triples to the graph
    g.add((user_uri, RDF.type, hh.users))
    g.add((user_uri, hh.UserName, Literal(row['username'], datatype=XSD.string)))
    g.add((user_uri, hh.UserEmail, Literal(row['email'], datatype=XSD.string)))
    g.add((user_uri, hh.UserPassword, Literal(row['password'], datatype=XSD.string)))
    g.add((user_uri, hh.UserLogins, Literal(row['logins'], datatype=XSD.string)))
    g.add((user_uri, hh.UserLastLogin, Literal(row['last_login'], datatype=XSD.dateTime)))


### IMPORT CITATIONS + LINK TO OTHER CLASSES


# Query MySQL database for all citations table rows
cursor.execute("SELECT * FROM citations")
rows = cursor.fetchall()


for row in rows:
    # Using id column from csv as unique identifier for each citation
    citation_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#Citation_{row['id']}")
    
    # Creating RDF triples for each property
    g.add((citation_uri, RDF.type, hh.Citation))
    g.add((citation_uri, hh.hasCitationText, Literal(row['text'], datatype=XSD.string)))
    g.add((citation_uri, hh.hasCitationTitle, Literal(row['title'], datatype=XSD.string)))
    g.add((citation_uri, hh.yearFrom, Literal(row['year_from'], datatype=XSD.integer)))
    g.add((citation_uri, hh.yearTo, Literal(row['year_to'], datatype=XSD.integer)))
    g.add((citation_uri, hh.cyearFrom, Literal(row['cyear_from'], datatype=XSD.integer)))
    g.add((citation_uri, hh.cyearTo, Literal(row['cyear_to'], datatype=XSD.integer)))
    g.add((citation_uri, hh.hasLinktext, Literal(row['linktext'], datatype=XSD.string)))
    g.add((citation_uri, hh.hasBibliography, Literal(row['bibliography'], datatype=XSD.string)))
    g.add((citation_uri, hh.hasComment, Literal(row['comment'], datatype=XSD.string)))
    g.add((citation_uri, hh.hasEsource, Literal(row['esource'], datatype=XSD.string)))
    g.add((citation_uri, hh.hasInternalComment, Literal(row['internal_comment'], datatype=XSD.string)))
    g.add((citation_uri, hh.hasSecSrcTxt, Literal(row['secsrc_txt'], datatype=XSD.string)))
    
    # Convert date strings to datetime objects
    if row['entry_date']:
        if isinstance(row['entry_date'], datetime):
            entry_date = row['entry_date']
        else:
            entry_date = datetime.strptime(row['entry_date'], '%Y-%m-%d %H:%M:%S')
        g.add((citation_uri, hh.hasEntryDate, Literal(entry_date, datatype=XSD.dateTime)))

    if row['ok_date']:
        if isinstance(row['ok_date'], datetime):
            ok_date = row['ok_date']
        else:
            ok_date = datetime.strptime(row['ok_date'], '%Y-%m-%d %H:%M:%S')
        g.add((citation_uri, hh.hasEntryDate, Literal(ok_date, datatype=XSD.dateTime)))

    if row['last_modif']:
        if isinstance(row['last_modif'], datetime):
            last_modif = row['last_modif']
        else:
            last_modif = datetime.strptime(row['last_modif'], '%Y-%m-%d %H:%M:%S')
        g.add((citation_uri, hh.hasEntryDate, Literal(last_modif, datatype=XSD.dateTime)))


    # Link to other classes

    # Query authors_citations table for authors related to the citation
    cursor.execute("SELECT author_id FROM authors_citations WHERE citation_id = %s", (row['id'],))

    for author_id in cursor.fetchall():
        # Generate the URI for the author based on the author_id
        author_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#Author_{author_id['author_id']}")
        
        # Link the citation to the author
        g.add((citation_uri, hh.hasAuthor, author_uri))



    # Query contributors table for contributors related to the citation
    cursor.execute("SELECT id FROM contributors WHERE id = %s", (row['contributor_id'],))

    for contributor_id in cursor.fetchall():
        # Generate the URI for the contributor based on the contributor_id
        contributor_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#Contributor_{contributor_id['id']}")
        
        # Link the citation to the contributor
        g.add((citation_uri, hh.contributedBy, contributor_uri))


    # Authormarks
    cursor.execute("SELECT name FROM authormarks WHERE id = %s", (row['authormark_id'],))
    for authormark_name in cursor.fetchall():
        cleaned_name = clean_name(authormark_name['name'])
        authormark_uri = find_rdf_uri(cleaned_name)
        if authormark_uri:
            g.add((citation_uri, hh.hasAuthormarks, authormark_uri))

    
    # Genres
    cursor.execute("SELECT name FROM genres WHERE id = %s", (row['genre_id'],))
    for genre_name in cursor.fetchall():
        cleaned_name = clean_name(genre_name['name'])
        genre_uri = find_rdf_uri(cleaned_name)
        if genre_uri:
            g.add((citation_uri, hh.hasGenre, genre_uri))

    
    # Languages
    cursor.execute("SELECT name FROM languages WHERE id = %s", (row['language_id'],))
    for language_name in cursor.fetchall():
        cleaned_name = clean_name(language_name['name'])
        language_uri = find_rdf_uri(cleaned_name)
        if language_uri:
            g.add((citation_uri, hh.inLanguage, language_uri))

    
    # Generals
    cursor.execute("""
        SELECT g.name 
        FROM generals g
        JOIN citations_generals cg ON g.id = cg.general_id
        WHERE cg.citation_id = %s
    """, (row['id'],))
    for general_name in cursor.fetchall():
        cleaned_name = clean_name(general_name['name'])
        general_uri = find_rdf_uri(cleaned_name)
        if general_uri:
            g.add((citation_uri, hh.hasGeneral, general_uri))


    # Intertextuals
    cursor.execute("""
        SELECT i.name 
        FROM intertextuals i
        JOIN citations_intertextuals ci ON i.id = ci.intertextual_id
        WHERE ci.citation_id = %s
    """, (row['id'],))
    for intertextual_name in cursor.fetchall():
        cleaned_name = clean_name(intertextual_name['name'])
        intertextual_uri = find_rdf_uri(cleaned_name)
        if intertextual_uri:
            g.add((citation_uri, hh.hasIntertextual, intertextual_uri))

    
    # Modifications
    cursor.execute("""
        SELECT m.name 
        FROM modifications m
        JOIN citations_modifications cm ON m.id = cm.modification_id
        WHERE cm.citation_id = %s
    """, (row['id'],))
    for modification_name in cursor.fetchall():
        cleaned_name = clean_name(modification_name['name'])
        modification_uri = find_rdf_uri(cleaned_name)
        # Only add the triple if a valid URI is found
        if modification_uri:
            g.add((citation_uri, hh.hasModifications, URIRef(modification_uri)))
        else:
            # Handle the case where no match is found, since the modification table contains some non-standard values that seem like artifacts
            print(f"No match found for modification: {cleaned_name}")


    # Narratives
    cursor.execute("""
        SELECT n.name 
        FROM narratives n
        JOIN citations_narratives cn ON n.id = cn.narrative_id
        WHERE cn.citation_id = %s
    """, (row['id'],))
    for narrative_name in cursor.fetchall():
        cleaned_name = clean_name(narrative_name['name'])
        narrative_uri = find_rdf_uri(cleaned_name)
        if narrative_uri:
            g.add((citation_uri, hh.hasNarrative, narrative_uri))

    
    # Overlaps
    cursor.execute("""
        SELECT o.name 
        FROM overlaps o
        JOIN citations_overlaps co ON o.id = co.overlap_id
        WHERE co.citation_id = %s
    """, (row['id'],))
    for overlap_name in cursor.fetchall():
        cleaned_name = clean_name(overlap_name['name'])
        overlap_uri = find_rdf_uri(cleaned_name)
        if overlap_uri:
            g.add((citation_uri, hh.hasOverlap, overlap_uri))


    # Quotmarks
    cursor.execute("""
        SELECT q.name 
        FROM quotmarks q
        JOIN citations_quotmarks cq ON q.id = cq.quotmark_id
        WHERE cq.citation_id = %s
    """, (row['id'],))
    for quotmark_name in cursor.fetchall():
        cleaned_name = clean_name(quotmark_name['name'])
        quotmark_uri = find_rdf_uri(cleaned_name)
        if quotmark_uri:
            g.add((citation_uri, hh.hasQuotMark, quotmark_uri))


    # Secondaries
    cursor.execute("""
        SELECT s.name 
        FROM secondaries s
        JOIN citations_secondaries cs ON s.id = cs.secondary_id
        WHERE cs.citation_id = %s
    """, (row['id'],))
    for secondary_name in cursor.fetchall():
        cleaned_name = clean_name(secondary_name['name'])
        secondary_uri = find_rdf_uri(cleaned_name)
        if secondary_uri:
            g.add((citation_uri, hh.hasSecondary, secondary_uri))


    # Subjects
    cursor.execute("""
        SELECT s.name 
        FROM subjects s
        JOIN citations_subjects cs ON s.id = cs.subject_id
        WHERE cs.citation_id = %s
    """, (row['id'],))
    for subject_name in cursor.fetchall():
        cleaned_name = clean_name(subject_name['name'])
        subject_uri = find_rdf_uri(cleaned_name)
        if subject_uri:
            g.add((citation_uri, hh.hasSubject, subject_uri))


    # Textuals
    cursor.execute("""
        SELECT t.name 
        FROM textuals t
        JOIN citations_textuals ct ON t.id = ct.textual_id
        WHERE ct.citation_id = %s
    """, (row['id'],))
    for textual_name in cursor.fetchall():
        cleaned_name = clean_name(textual_name['name'])
        textual_uri = find_rdf_uri(cleaned_name)
        if textual_uri:
            g.add((citation_uri, hh.hasTextual, textual_uri))


    # Workmarks
    cursor.execute("""
        SELECT w.name 
        FROM workmarks w
        JOIN citations_workmarks cw ON w.id = cw.workmark_id
        WHERE cw.citation_id = %s
    """, (row['id'],))
    for workmark_name in cursor.fetchall():
        cleaned_name = clean_name(workmark_name['name'])
        workmark_uri = find_rdf_uri(cleaned_name)
        if workmark_uri:
            g.add((citation_uri, hh.hasWorkmark, workmark_uri))


    # HamletText -> unique values from hamlettext table
    cursor.execute("""
        SELECT ht.id 
        FROM hamlettext ht
        JOIN citations_hamlettext cht ON ht.id = cht.hamlettext_id
        WHERE cht.citation_id = %s
    """, (row['id'],))
    hamlettexts = cursor.fetchall()

    for hamlettext in hamlettexts:
        # Create the URI for the related HamletText using its ID
        hamlettext_uri = URIRef(f"http://hyperhamlet.unibas.ch/rdf-schema#HamletText_{hamlettext['id']}")
        # Link the citation to the HamletText
        g.add((citation_uri, hh.hasHamletText, hamlettext_uri))


# export graph to turtle file
g.serialize(destination="mysql_import.ttl", format="turtle")



# close cursor and connection
cursor.close()
conn.close()
