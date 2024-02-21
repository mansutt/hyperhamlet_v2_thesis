This folder contains all csv files that become classes or subclasses, depending on whether they have a parent or not.
All of these csv files are exports from MySQL, done with MySQL Workbench.

clean_csv.py loops over all items with file ending .csv inside this folder, cleans them up and saves the cleaned version in the foler classes_mysql_export_cleaned
