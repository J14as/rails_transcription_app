# 🎙️ Rails Transcription App

[![Ruby](https://img.shields.io/badge/Ruby-3.3.x-red)](https://www.ruby-lang.org/) 
[![Rails](https://img.shields.io/badge/Rails-7.1.x-blue)](https://rubyonrails.org/) 
[![HuggingFace](https://img.shields.io/badge/HuggingFace-API-yellowgreen)](https://huggingface.co/) 
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A **Ruby on Rails** application for real-time audio transcription and AI-powered summarization.  
Users can record audio live in the browser or upload audio files, then get concise, bullet-point summaries using HuggingFace models.

---

## 🚀 Features

- **Live transcription** using the **Web Speech API** in the browser.  
- **Audio file transcription** via backend stubs (can integrate Deepgram, OpenAI Whisper, etc.).  
- **AI summarization** using **HuggingFace Transformers**.  
- **Summary in bullet points** for readability.  
- **Background processing support** with **Sidekiq** (optional).  
- **Frontend interactivity** handled by **StimulusJS**.  
- **File storage** via **ActiveStorage**.  

---

## 🛠️ Tech Stack & Tools

| Layer        | Technology / Library        | Purpose |
|--------------|----------------------------|---------|
| Backend      | Ruby 3.3.x, Rails 7.1.x    | Core framework, routing, controllers, models |
| Frontend     | StimulusJS, Web Speech API  | Live transcription and interactivity |
| Audio        | ActiveStorage               | Store audio uploads |
| Summarization| HuggingFace Inference API   | AI-powered summarization |
| Background   | Sidekiq + Redis (optional) | Asynchronous job processing |
| HTTP Client  | HTTParty                    | API requests to HuggingFace |
| Testing      | RSpec                       | Endpoint testing and validations |
| Deployment   | GitHub, optional Docker     | Version control and deployment |

---

## 🖥️ Screenshots

![Transcription Page](./screenshots/transcribe_page.png)  
*Live transcription with real-time updates*

![Summary Page](./screenshots/summary_page.png)  
*Clean summary with bullet points*

> Add your screenshots in the `/screenshots` folder to display here.

---

## ⚡ Setup Instructions

### Prerequisites

- Ruby 3.3.x  
- Rails 7.1.x  
- Node.js & Yarn  
- Redis (for Sidekiq, optional)  
- Git  

### Installation

1. Clone the repo:

```bash
git clone https://github.com/J14as/rails_transcription_app.git
cd rails_transcription_app
```

2.Install dependencies:
```bash
bundle install
```

3.Setup database:

```bash
rails db:create db:migrate
```

4.Add environment variables:

Create a .env file in the project root:
```bash
HUGGINGFACE_API_KEY=your_huggingface_api_key
```

5.Start Rails server:
```bash
rails server
```


6.Open in browser:

```bash
http://localhost:3000/transcribe
```
📝 Usage

Navigate to /transcribe to record audio live or upload audio files.

The live transcription appears as you speak.

After stopping, the full transcription and AI-generated summary are displayed.

Fetch only the summary using:

GET /summary/:id

⚙️ API Endpoints
Endpoint	Method	Description
/transcriptions	POST	Accepts audio and/or text, returns transcription + summary
/summary/:id	GET	Returns summarized conversation for a given transcription ID
🧪 Testing

Basic tests for the summarization endpoint are included using RSpec:

bundle exec rspec spec/requests/summary_spec.rb

🙌 Contributing

Contributions are welcome!

Fork the repo

Create your feature branch (git checkout -b feature/my-feature)

Commit your changes (git commit -am 'Add feature')

Push to the branch (git push origin feature/my-feature)

Open a Pull Request

📫 Contact

Created by Jayesh Borkar

GitHub: J14as
