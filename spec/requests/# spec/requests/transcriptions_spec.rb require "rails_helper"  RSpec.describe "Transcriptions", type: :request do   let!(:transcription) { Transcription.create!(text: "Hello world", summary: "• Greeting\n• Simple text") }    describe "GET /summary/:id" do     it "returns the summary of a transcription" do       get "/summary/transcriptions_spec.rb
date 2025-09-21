# spec/requests/transcriptions_spec.rb
require "rails_helper"

RSpec.describe "Transcriptions", type: :request do
  let!(:transcription) { Transcription.create!(text: "Hello world", summary: "• Greeting\n• Simple text") }

  describe "GET /summary/:id" do
    it "returns the summary of a transcription" do
      get "/summary/#{transcription.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["id"]).to eq(transcription.id)
      expect(json["summary"]).to include("Greeting")
    end
  end
end
