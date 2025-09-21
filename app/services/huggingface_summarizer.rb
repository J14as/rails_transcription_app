class HuggingfaceSummarizer
  def self.call(text)
    return "" if text.blank?

    api_key = ENV.fetch("HUGGINGFACE_API_KEY")
    model = "sshleifer/distilbart-cnn-12-6"

    response = HTTParty.post(
      "https://api-inference.huggingface.co/models/#{model}",
      headers: {
        "Authorization" => "Bearer #{api_key}",
        "Content-Type" => "application/json"
      },
      body: { inputs: text }.to_json,
      timeout: 60
    )

    if response.code == 200 && response.parsed_response[0]&.dig("summary_text")
      raw_summary = response.parsed_response[0]["summary_text"].to_s.strip

      # Format into max 3 bullet points
      bullets = raw_summary.split(/[\.\n]/).map(&:strip).reject(&:empty?)[0..2]
      bullets.map { |b| "• #{b}" }.join("\n")
    else
      Rails.logger.error "HuggingFace API error: #{response.body}"
      "(summary failed)"
    end
  rescue => e
    Rails.logger.error "HuggingFace summarize failed: #{e.class} #{e.message}"
    "(summary failed)"
  end
end
