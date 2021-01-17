# frozen_string_literal: true

RSpec.shared_examples 'representable' do |factory_name, fields_array_by_value = [], fields_array_by_name = []|
  let(:object) { create(factory_name.to_sym) }

  describe '#represent' do
    it 'returns representable result with appropriate fields' do
      result = object.represent
      expect(result.to_json).to include(*(fields_array_by_value + fields_array_by_name))
    end
  end
end
