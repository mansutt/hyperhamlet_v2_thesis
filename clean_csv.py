import os
import pandas as pd

# Define source and destination directories
source_dir = 'classes_mysql_export/'
dest_dir = 'classes_mysql_export_cleaned/'

# Ensure the destination directory exists, otherwise create it
if not os.path.exists(dest_dir):
    os.makedirs(dest_dir)

# Function to clean up the 'name' column values
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

# Loop through all CSV files in the source directory
for csv_file in os.listdir(source_dir):
    if csv_file.endswith('.csv'):
        # Read the current CSV file
        df = pd.read_csv(os.path.join(source_dir, csv_file))
        
        # Clean up the 'name' column
        df['name'] = df['name'].apply(clean_name)
        
        # Order the rows by the 'name' column alphabetically
        df_sorted = df.sort_values(by='name')
        
        # Save the cleaned and sorted dataframe to a new CSV in the destination directory
        df_sorted.to_csv(os.path.join(dest_dir, csv_file), index=False)

print("Cleaning and reordering complete.")

