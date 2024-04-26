import pandas as pd
from pymongo import MongoClient
from datetime import  datetime
# Replace with your connection string and database name
connection_string = "mongodb://localhost:27017/"
database_name = "tiqn"

# Excel file path (replace with your actual path)
excel_file = r"\\fs\tiqn\03.Department\01.Operation Management\03.HR-GA\01.HR\Toray's employees information All in one.xlsx"

# Connect to MongoDB
client = MongoClient(connection_string)
db = client[database_name]

# Read data from Excel using pandas
data = pd.read_excel(excel_file)

# Convert pandas dataframe to dictionary (adjust based on your data structure)
data_dict = data.to_dict(orient="records")

# Access the collection you want to update (replace with your collection name)
collection = db["data"]

# Loop through each data entry
for entry in data_dict:
  print(entry)
  # Update document in MongoDB collection based on a unique identifier (replace with your logic)
  filter = {"_id": entry["_id"]}  # Assuming "_id" is a unique identifier in your data
  update = {"$set": entry}  # Update all fields in the document
  collected={}
  collected.update({'empId': 'TIQN-XXX' if entry['Emp Code'] == 0 else entry['Emp Code']})
  collected.update({'name': 'Họ Văn Tên' if entry['Fullname'] == 0 else entry['Fullname']})
  collected.update({'attFingerId': 0 if entry['Finger Id'] == 0 else entry['Finger Id']})
  collected.update({'department': '' if entry['Department'] == 0 else entry['Department']})
  collected.update({'section': '' if entry['Section'] == 0 else  entry['Section']})
  collected.update({'group': '' if entry['Group'] == 0 else  entry['Group']})
  collected.update({'lineTeam': entry['Line/ Team'] if entry['Line/ Team'] == 0 else ''})
  collected.update({'gender': entry['Gender']  if entry['Gender'] == 0 else 'F'})
  collected.update({'position': entry['Position']}  if entry['Position'] == 0 else '')
  collected.update({'level': entry['Level'] if entry['Level'] == 0 else ''})
  collected.update({'directIndirect': entry['Direct/ Indirect'] if entry['Direct/ Indirect'] == 0 else ''})
  collected.update({'sewingNonSewing': entry['Sewing/Non sewing'] if entry['Sewing/Non sewing'] == 0 else ''})
  collected.update({'supporting': entry['Supporting'] if entry['Supporting'] == 0 else ''})
  # collected.update({'dob': entry['DOB']})
  collected.update({'joiningDate': entry['Joining date'] if entry['Joining date'] == 0 else datetime(1900, 1, 1, 0, 0)})
  collected.update({'workStatus': int( entry['Working/Resigned'] if entry['Working/Resigned'] == 0 else 0)})
  collected.update({'maternity': int(entry['Maternity'] if entry['Maternity'] == 0 else 0)})
  update = {"$set": collected}
  collection.update_one(filter, update, upsert=True)  # Upsert inserts if no document matches the filter

# Close the connection
client.close()

print("Data updated in MongoDB collection!")
