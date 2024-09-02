# frozen_string_literal: true

require 'open3'

Given('I run the Shypple CLI') do
  @stdin, @stdout, @stderr, @wait_thr = Open3.popen3('ruby shypple.rb')
end

When('I input {string}') do |input|
  @stdin.puts(input)
end

Then('I should see the following keywords:') do |table|
  @stdin.close
  actual_output = @stdout.read

  # Extract keywords from the table
  keywords = table.raw.flatten

  # Check if each keyword is included in the actual output
  keywords.each do |keyword|
    expect(actual_output).to include(keyword)
  end
end
