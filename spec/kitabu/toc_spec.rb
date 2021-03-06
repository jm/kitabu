# encoding: utf-8
require File.dirname(__FILE__) + "/../spec_helper"

HTML = <<-HTML
  <h1>Item 1</h1>
  <h2>Item 1.2</h2>
  <h3>Item 1.1.3</h3>
  <h4>Item 1.1.1.4</h4>
  <h5>Item 1.1.1.1.5</h5>
  <h6>Item 1.1.1.1.1.6</h6>
  
  <h2>Item 2.1</h2>
  <h2>Item 2.1 again</h2>
  <h2>Internacionalização</h2>
HTML

HTML.force_encoding("utf-8") if RUBY_VERSION >= '1.9'

shared_examples_for "Table of contents" do
  it "should not have body tag" do
    @contents.should_not have_tag("body")
  end
  
  it "should generate toc" do
    @toc.should have_tag("div.level2.item-1-2", "Item 1.2")
    @toc.should have_tag("div.level3.item-1-1-3", "Item 1.1.3")
    @toc.should have_tag("div.level4.item-1-1-1-4", "Item 1.1.1.4")
    @toc.should have_tag("div.level5.item-1-1-1-1-5", "Item 1.1.1.1.5")
    @toc.should have_tag("div.level6.item-1-1-1-1-1-6", "Item 1.1.1.1.1.6")
    
    @toc.should have_tag("div.level2.item-2-1", "Item 2.1")
    @toc.should have_tag("div.level2.item-2-1-again", "Item 2.1 again")
    
    @toc.should have_tag("div.level2.internacionalizacao", "Internacionalização")
  end
  
  it "should add ID attribute to content" do
    @contents.should have_tag("h2#item-1-2", "Item 1.2")
    @contents.should have_tag("h3#item-1-1-3", "Item 1.1.3")
    @contents.should have_tag("h4#item-1-1-1-4", "Item 1.1.1.4")
    @contents.should have_tag("h5#item-1-1-1-1-5", "Item 1.1.1.1.5")
    @contents.should have_tag("h6#item-1-1-1-1-1-6", "Item 1.1.1.1.1.6")
    
    @contents.should have_tag("h2#item-2-1", "Item 2.1")
    @contents.should have_tag("h2#item-2-1-again", "Item 2.1 again")
    
    @contents.should have_tag("h2#internacionalizacao", "Internacionalização")
  end
end

describe "Kitabu::Base" do
  describe "Hpricot" do
    before(:each) do
      Kitabu::Base.stub!(:nokogiri?).and_return(false)
      Kitabu::Base.stub!(:hpricot?).and_return(true)
      
      @contents, @toc = Kitabu::Base.table_of_contents(HTML)
    end
    
    it_should_behave_like "Table of contents"
  end
  
  describe "Nokogiri" do
    before(:each) do
      Kitabu::Base.stub!(:nokogiri?).and_return(true)
      Kitabu::Base.stub!(:hpricot?).and_return(false)
      
      @contents, @toc = Kitabu::Base.table_of_contents(HTML)
    end
    
    it_should_behave_like "Table of contents"
  end
end
