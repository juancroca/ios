require 'rails_helper'

RSpec.describe "courses/new", type: :view do
  before(:each) do
    assign(:course, Course.new())
  end

  it "renders new course form" do
    render

    assert_select "form[action=?][method=?]", courses_path, "post" do
    end
  end
end
