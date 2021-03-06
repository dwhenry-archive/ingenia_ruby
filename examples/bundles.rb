require './helper'

##
# Run a full set of API calls on bundles
##


#
# Setup
#
# Set API key to the test user for this gem
require 'ingenia_api'
Ingenia::Api.api_key = "API_KEY"

##
# Create
#
example "Create" do
  # Create a new bundle
  @new_bundle = Ingenia::Bundle.create(:name => "new bundle")
  puts "\n created a new bundle:"
  puts "#{@new_bundle}".green
end


##
# Index
#
example "Index" do
  # Get a list of all your bundles
  bundles = Ingenia::Bundle.all
  puts "got #{bundles.length} bundles".green

  # Get the first bundle
  @test_bundle = bundles.first

  puts "\n First Bundle: ".green
  puts "#{@test_bundle}".green

  @test_bundle_id = @test_bundle['id']
  @test_bundle_name = @test_bundle['name']
end


##
# Show
#
example "Show" do
  # Get the updated bundle, including it's text
  @test_bundle = Ingenia::Bundle.get(@test_bundle_id)
  puts "\n updated bundle:"
  puts "#{@test_bundle}".green
end


##
# Update
# 
example "Update" do
  # Update its text
  response = Ingenia::Bundle.update(@test_bundle_id, :name => "updated bundle name new" )
  puts "#{response}".green
end


##
# Destroy
#
example "Destroy" do
  # Remove this new bundle
  response =  Ingenia::Bundle.destroy(@new_bundle['id'])
  puts "#{response}".green
end

