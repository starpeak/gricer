Given /^I still work on this feature$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^put me the raw result$/ do
  # Only use this for debugging a output if you don't know what went wrong
  raise page.body
end

When /^(?:|I )wait a second$/ do 
  sleep 1
end

When /^(?:|I )wait (?:|for )(\d+) second(?:|s)$/ do |secs|
  sleep secs.to_i
end

# Then /^wait (\d+) seconds?$/ do |delay|
#   sleep delay.to_i
# end

Then /^wait$/ do
  sleep 60
end
