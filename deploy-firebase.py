import os
import json
import requests
import subprocess
import zipfile
import io

def get_firebase_token():
    try:
        result = subprocess.run(['firebase', 'login:ci'], capture_output=True, text=True)
        return result.stdout.strip()
    except:
        return None

def deploy_to_firebase():
    project_id = 'saeedkhanportfolio'
    
    # Get Firebase token
    token = get_firebase_token()
    if not token:
        print("Failed to get Firebase token")
        return
    
    # Create a zip of the build/web directory
    zip_buffer = io.BytesIO()
    with zipfile.ZipFile(zip_buffer, 'w', zipfile.ZIP_DEFLATED) as zip_file:
        web_dir = 'build/web'
        for root, dirs, files in os.walk(web_dir):
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, web_dir)
                zip_file.write(file_path, arcname)
    
    zip_buffer.seek(0)
    
    # Deploy using Firebase Hosting API
    url = f"https://firebasehosting.googleapis.com/v1beta1/sites/{project_id}/releases"
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json'
    }
    
    # Create release
    release_data = {
        'config': {
            'rewrites': [{'source': '**', 'destination': '/index.html'}]
        }
    }
    
    response = requests.post(url, headers=headers, json=release_data)
    if response.status_code == 200:
        release = response.json()
        print(f"Release created: {release['name']}")
        
        # Upload files
        upload_url = release['uploadUrl']
        files = {'file': ('site.zip', zip_buffer.getvalue(), 'application/zip')}
        
        upload_response = requests.post(upload_url, files=files)
        if upload_response.status_code == 200:
            print("Deployment successful!")
        else:
            print(f"Upload failed: {upload_response.text}")
    else:
        print(f"Failed to create release: {response.text}")

if __name__ == "__main__":
    deploy_to_firebase()
