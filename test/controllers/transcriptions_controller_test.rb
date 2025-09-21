require "test_helper"

class TranscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "summary endpoint returns stored summary" do
    t = Transcription.create!(text: "We discussed integration and follow up", summary: "1. Discussed integration\n2. Action: follow up with team")

    get summary_path(t.id)
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal t.id, json["id"]
    assert_includes json["summary"], "Discussed integration"
  end
end
