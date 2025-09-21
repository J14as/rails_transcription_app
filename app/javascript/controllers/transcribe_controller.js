import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transcribe"
export default class extends Controller {
  static targets = ["startBtn", "stopBtn", "live", "final", "summary"]

  connect() {
    this.mediaRecorder = null
    this.audioChunks = []
    this.recognition = null
    this.clientTranscript = ""
  }

  supportsSpeechRecognition() {
    return !!(window.SpeechRecognition || window.webkitSpeechRecognition)
  }

  async start() {
    this.startBtnTarget.disabled = true
    this.stopBtnTarget.disabled = false
    this.liveTarget.textContent = ""
    this.finalTarget.textContent = ""
    this.summaryTarget.textContent = ""
    this.clientTranscript = ""
    this.audioChunks = []

    // Web Speech API for live text
    if (this.supportsSpeechRecognition()) {
      const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
      this.recognition = new SpeechRecognition()
      this.recognition.lang = "en-US"
      this.recognition.interimResults = true
      this.recognition.continuous = true

      this.recognition.onresult = (event) => {
        let interim = ""
        let final = ""
        for (let i = event.resultIndex; i < event.results.length; ++i) {
          const res = event.results[i]
          if (res.isFinal) {
            final += res[0].transcript
          } else {
            interim += res[0].transcript
          }
        }
        this.clientTranscript += final
        this.liveTarget.textContent = this.clientTranscript + interim
      }

      this.recognition.onerror = (e) => {
        console.warn("SpeechRecognition error", e)
      }

      try {
        this.recognition.start()
      } catch (e) {
        console.warn("recognition start error", e)
      }
    } else {
      this.liveTarget.textContent = "(Live transcription not supported in this browser.)"
    }

    // Start MediaRecorder
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
      this.mediaRecorder = new MediaRecorder(stream)
      this.mediaRecorder.ondataavailable = (e) => {
        if (e.data && e.data.size > 0) this.audioChunks.push(e.data)
      }
      this.mediaRecorder.start(250)
    } catch (e) {
      console.error("microphone permission error", e)
      this.startBtnTarget.disabled = false
      this.stopBtnTarget.disabled = true
    }
  }

  async stop() {
    this.stopBtnTarget.disabled = true
    this.startBtnTarget.disabled = false

    if (this.recognition) {
      try { this.recognition.stop() } catch (e) { /* ignore */ }
    }

    if (this.mediaRecorder && this.mediaRecorder.state !== "inactive") {
      this.mediaRecorder.stop()
      // small wait for last chunk
      await new Promise(r => setTimeout(r, 300))

      const blob = new Blob(this.audioChunks, { type: "audio/webm" })
      this.finalTarget.textContent = this.clientTranscript || "(no client transcript)"

      // Prepare form data
      const form = new FormData()
      form.append("audio", blob, "recording.webm")
      form.append("client_transcript", this.clientTranscript)

      const token = document.querySelector('meta[name="csrf-token"]').content

      try {
        const resp = await fetch("/transcriptions", {
          method: "POST",
          headers: { "X-CSRF-Token": token },
          body: form
        })
        const json = await resp.json()  
        this.finalTarget.textContent = json.text
        this.summaryTarget.textContent = json.summary
      } catch (err) {
        console.error("Upload failed", err)
        this.summaryTarget.textContent = "(summary failed)"
      }
    }
  }
}
