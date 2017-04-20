require 'pry'

def maxFlowerShops(length, intervals)
  state = {
    left_boundary: 0,   # the leftmost index that can still be planted on
    occupied_plots: [], # the number of planted flowers on the indexes to the right of left_boundary
    num_flower_shops: 0,
  }

  sort_intervals(intervals).each do |interval|
    if can_add_interval?(interval, state)
      state = add_interval(interval, state)
    end
  end

  state[:num_flower_shops]
end

def sort_intervals(intervals)
  intervals.
    sort_by{ |i| i[1] }.
    group_by{ |i| i[1] }.
    values.
    map(&:sort).
    map(&:reverse).
    map { |i| i.take(3) }.
    flatten(1)
end

def can_add_interval?(interval, state)
  interval[0] >= state[:left_boundary]
end

def get_new_left_boundary(current_boundary, plots)
  if i = plots.index(3)
    [current_boundary + i + 1, plots.drop(i + 1)]
  else
    [current_boundary, plots]
  end
end

def add_interval(interval, state)
  new_plots = get_new_occupied_plots(state[:left_boundary], interval, state[:occupied_plots])
  new_left_boundary, new_plots = get_new_left_boundary(state[:left_boundary], new_plots)

  {
    left_boundary: new_left_boundary,
    occupied_plots: new_plots,
    num_flower_shops: state[:num_flower_shops] + 1,
  }
end

def get_new_occupied_plots(left_boundary, interval, plots)
  right_boundary = interval[1] - left_boundary

  if plots.length < right_boundary
    plots += Array.new((right_boundary - plots.length), 0)
  end

  shifted_interval = [interval[0] - left_boundary, right_boundary - 1]

  plots.map.with_index do |plot, i|
    if (shifted_interval[0]..shifted_interval[1]).include?(i)
      plot + 1
    else
      plot
    end
  end
end

def run_max_flower(filename)
  fp = File.open(filename, 'r')

  _L = Integer(fp.readline);

  _intervals_rows = 0
  _intervals_cols = 0
  _intervals_rows = Integer(fp.readline)
  _intervals_cols = Integer(fp.readline)
  _intervals = Array.new(_intervals_rows)
  for _intervals_i in (0.._intervals_rows-1)
    _intervals_t = fp.readline.strip
    _intervals[_intervals_i] = _intervals_t.split(' ').map(&:to_i)
  end
  fp.close()
  #puts _L
  #puts "#{_intervals}"
  start_time = Time.now
  res = maxFlowerShops(_L, _intervals);
  end_time = Time.now

  puts "\nresult for #{filename}: #{res}"
  puts "time elapsed: #{end_time - start_time}"
  res
end

if !$running_specs
  [
    'int_9_10.txt',
    'int_100_100.txt',
    'int_1000_20000.txt',
    'int_10000_2000.txt',
    'int_50000_10000.txt',
    'int_500000_100000.txt',
  ].each do |file|
    run_max_flower(file)
  end
end