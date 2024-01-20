import requests
import json
key="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"
response = requests.post(
  url="https://openrouter.ai/api/v1/chat/completions",
  headers={
    "Authorization": f"Bearer {key}",
  },
  data=json.dumps({
    "model": "mistralai/mixtral-8x7b-instruct", # Optional
    "messages": [
      {"role": "user", "content": "Can you build a resume for me?"}
    ]
  })
)


json_response = response.json()

# Extract and print the "content" part
for choice in json_response.get('choices', []):
   content = choice.get('message', {}).get('content')
   if content:
      print(content)
