require 'station'

describe Station do
  subject { described_class.new('Holborn', 1) }

  it 'responds to a name' do
    expect(subject.name).to eq('Holborn')
  end

  it 'responds to a zone' do
    expect(subject.zone).to eq(1)
  end
end
