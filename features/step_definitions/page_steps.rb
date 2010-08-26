### Pages

# helps create a simple content page (parent: "index") with a slug, contents, and template
def create_content_page(page_slug, page_contents, template = nil)
  @home = @site.pages.where(:slug => "index").first || Factory(:page)
  page = @site.pages.create(:slug => page_slug, :body => page_contents, :parent => @home, :title => "some title", :published => true, :raw_template => template)
  page.should be_valid
  page
end

# creates a page
Given /^a simple page named "([^"]*)" with the body:$/ do |page_slug, page_contents|
  @page = create_content_page(page_slug, page_contents)
end

Given /^a page named "([^"]*)" with the template:$/ do |page_slug, template|
  @page = create_content_page(page_slug, '', template)
end

# # creates a part within a page
# Given /^the page named "([^"]*)" has the part "([^"]*)" with the content:$/ do |page_slug, part_slug, part_contents|
#   page = @site.pages.where(:slug => page_slug).first
#   raise "Could not find page: #{page_slug}" unless page
# 
#   # find or crate page part
#   part = page.parts.where(:slug => part_slug).first
#   unless part
#     part = page.parts.build(:name => part_slug.titleize, :slug => part_slug)
#   end
# 
#   # set part value
#   part.value = part_contents
#   part.should be_valid
# 
#   # save page with embedded part
#   page.save
# end


# update a page
When /^I update the "([^"]*)" page with the template:$/ do |page_slug, template|
  puts "*************"
  page = @site.pages.where(:slug => page_slug).first
  page.update_attributes :raw_template => template
end

# try to render a page by slug
When /^I view the rendered page at "([^"]*)"$/ do |path|
  visit "http://#{@site.domains.first}#{path}"
end

# checks to see if a string is in the slug
Then /^I should have "(.*)" in the (.*) page$/ do |content, page_slug|
  page = @site.pages.where(:slug => page_slug).first
  raise "Could not find page: #{page_slug}" unless page

  page.raw_template.should == content
end

# checks if the rendered body matches a string
Then /^the rendered output should look like:$/ do |body_contents|
  page.body.should == body_contents
end


