# frozen_string_literal: true

require 'open3'

Given('I run the Shypple CLI') do
  @stdin, @stdout, @stderr, @wait_thr = Open3.popen3('ruby shypple.rb')
end

When('I input {string}') do |input|
  @stdin.puts(input)
end

Then('I should see {string}') do |expected_output|
  @stdin.close
  output = @stdout.read
  expect(output).to include(expected_output)
end
