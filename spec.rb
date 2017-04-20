require './max_flower_shops_template.rb'
require 'rspec'

describe '#add_interval' do
  let(:initial_state) {
    {
      num_flower_shops: 0,
      left_boundary: 0,
      occupied_plots: [],
    }
  }

  it 'updates the num_flower_shops' do
    new_state = add_interval([0,1], initial_state)

    expect(new_state[:num_flower_shops]).to eq(1)
  end

  describe '#get_new_occupied_plots' do
    it 'updates plots' do
      expect(get_new_occupied_plots(0, [0,1], [])).to eq([1])
      expect(get_new_occupied_plots(0, [0,5], [])).to eq([1,1,1,1,1])
      expect(get_new_occupied_plots(2, [4,6], [])).to eq([0,0,1,1])
      expect(get_new_occupied_plots(2, [4,6], [0,1,2,1,0])).to eq([0,1,3,2,0])
    end
  end

  describe '#get_new_left_boundary' do
    it 'updates the left boundary and plots' do
      expect(get_new_left_boundary(0, [0,1])).to eq([0, [0,1]])
      expect(get_new_left_boundary(0, [0,2])).to eq([0, [0,2]])
      expect(get_new_left_boundary(0, [3])).to eq([1, []])
      expect(get_new_left_boundary(0, [0,3])).to eq([2, []])
    end
  end

  it 'updates the occupied plots' do
    new_state = add_interval([0,1], initial_state)
    expect(new_state[:occupied_plots]).to eq([1])

    new_state2 = add_interval([0,1], new_state)
    expect(new_state2[:occupied_plots]).to eq([2])

    new_state3 = add_interval([0,1], new_state2)
    expect(new_state3[:occupied_plots]).to eq([])

    new_state4 = add_interval([1,5], new_state3)
    expect(new_state4[:occupied_plots]).to eq([1,1,1,1])

    new_state5 = add_interval([3,5], new_state4)
    expect(new_state5[:occupied_plots]).to eq([1,1,2,2])
  end

  it 'updates the left boundary' do
    new_state = add_interval([0,1], initial_state)

    expect(new_state[:left_boundary]).to eq(0)

    new_state2 = add_interval([0,1], new_state)
    new_state3 = add_interval([0,1], new_state2)

    expect(new_state3[:left_boundary]).to eq(1)
  end
end
