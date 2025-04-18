import requests
# url="https://fda1-111-125-237-152.ngrok-free.app/"
# resp = requests.get("https://fda1-111-125-237-152.ngrok-free.app/predict?source=https://firebasestorage.googleapis.com/v0/b/insta-clone-33281.appspot.com/o/posts%2Fark%40gmail.com%2Fd82b1060-b7d5-1e05-95c4-19a7cb3a73d4?alt=media&token=99bbeb2f-3b8b-4d0b-8633-6523063aa97d&save_txt=T",
#                     verify=False)
# print(resp.content)
url = 'https://fda1-111-125-237-152.ngrok-free.app/predict'
file_path = 'C:/Users/reach/Desktop/wp3990037.jpg'
#file_path='https://firebasestorage.googleapis.com/v0/b/insta-clone-33281.appspot.com/o/posts%2Fark%40gmail.com%2Fd82b1060-b7d5-1e05-95c4-19a7cb3a73d4?alt=media&token=99bbeb2f-3b8b-4d0b-8633-6523063aa97d'

params = {
    'save_txt': 'T'
}

with open(file_path, "rb") as f:
    response = requests.post(url, files={"myfile": f}, data=params, verify=False)

print(response.content)