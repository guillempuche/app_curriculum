import json
import csv

# Sample JSON data
data = {
    "software_developer": {
        "title": "Mobile and Web Developer",
        "location": "The Netherlands",
        "start_date": 1638316800000,
        "end_date": None,
        "image": "https://res.cloudinary.com/guillempuche/image/upload/v1691842839/app_curriculum/innova-didactic-arduino.jpg",
        "languages": ["English"]
    },
    "software_developer_2": {
        "title": "Mobile and Web Developer",
        "location": "The Netherlands",
        "start_date": None,
        "end_date": 1577836800000,
        "image": "https://res.cloudinary.com/guillempuche/image/upload/v1691842839/app_curriculum/innova-didactic-arduino.jpg",
        "languages": ["English"]
    }
}

# Convert to CSV
with open('output.csv', 'w', newline='',encoding='utf-8') as csvfile:
    fieldnames = ['end_date', 'image', 'languages', 'title', 'location', 'id', 'text', 'start_date']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()  # Write the headers

    for item in data:
        if isinstance(item, dict):
            writer.writerow({
                'end_date': item.get('end_date', ''),
                'image': item.get('image', ''),
                'languages': item.get('languages', ''),
                'title': item.get('title', ''),
                'location': item.get('location', ''),
                'id': item.get('id', ''),
                'text': '',
                'start_date': item.get('start_date', '')
            })
