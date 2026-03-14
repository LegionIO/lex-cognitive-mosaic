# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveMosaic::Client do
  subject(:client) { described_class.new }

  it 'includes the runner module' do
    expect(client).to respond_to(:create_tessera)
  end

  it 'includes all runner methods' do
    %i[create_tessera create_mosaic place_tessera
       list_tesserae list_mosaics mosaic_status].each do |m|
      expect(client).to respond_to(m)
    end
  end
end
