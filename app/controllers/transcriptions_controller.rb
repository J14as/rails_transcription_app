class TranscriptionsController < ApplicationController
  protect_from_forgery with: :exception

   def summary
    transcription = Transcription.find(params[:id])

    respond_to do |format|
      format.json do
        render json: {
          id: transcription.id,
          summary: transcription.summary || "(no summary available)"
        }
      end

      format.html do
        render :summary, locals: { transcription: transcription }
      end
    end
  end

  def create
    client_text = params[:client_transcript]
    transcription = Transcription.create!(text: client_text || "")

    if params[:audio].present?
      transcription.audio.attach(params[:audio])
      final_text = transcribe_audio(transcription)
      transcription.update!(text: final_text)
      transcription.update!(summary: HuggingfaceSummarizer.call(final_text))
    else
      transcription.update!(summary: HuggingfaceSummarizer.call(transcription.text)) if transcription.text.present?
    end

    render json: { id: transcription.id, text: transcription.text, summary: transcription.summary }
  rescue => e
    Rails.logger.error "Transcription/Summary error: #{e.class} #{e.message}"
    transcription.update!(summary: "(summary failed)") if transcription
    render json: { id: transcription&.id, text: transcription&.text, summary: transcription&.summary }
  end

  private

  def transcribe_audio(transcription)
    # Placeholder: replace with Whisper/Deepgram
    transcription.text
  end
end
