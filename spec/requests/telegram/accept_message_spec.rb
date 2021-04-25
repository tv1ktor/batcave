# frozen_string_literal: true

RSpec.describe TelegramController, type: :request do
  describe "POST /telegram" do
    let(:action) { "/telegram" }

    it "allows request Telegram"

    it "blocks non-telegram IP addresses" do
      allow(Telega::Processor).to receive(:new).with(any_args)

      post action, headers: {"REMOTE_ADDR" => "84.172.79.173"}

      aggregate_failures do
        expect(Telega::Processor).not_to have_received(:new)
        expect(response).to have_http_status :ok
      end
    end
  end
end
