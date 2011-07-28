When /^(?:|I )click "([^"]*)"$/ do |action|
  click_link_or_button(action)
end

Then /^it should redirect$/ do
  if /<meta content=['"](?<delay>\d+);url=(?<destination>[^'"]+)['"]\s+http-equiv=['"]refresh['"]>/ =~ page.body
    sleep delay.to_i
    visit destination
  else
    raise 'No redirect found.'
  end
end

Then /^(?:|I )?should not see "([^"]*)"$/ do |text|
  page.should_not have_xpath("//*[contains(text(),'#{text}') and not(ancestor-or-self::*[contains(@style, 'display: none') or contains(@style, 'display:none')])]")
end