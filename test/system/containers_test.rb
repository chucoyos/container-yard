require "application_system_test_case"

class ContainersTest < ApplicationSystemTestCase
  setup do
    @container = containers(:one)
  end

  test "visiting the index" do
    visit containers_url
    assert_selector "h1", text: "Containers"
  end

  test "should create container" do
    visit containers_url
    click_on "New container"

    fill_in "Cargo owner", with: @container.cargo_owner
    fill_in "Container type", with: @container.container_type
    fill_in "Number", with: @container.number
    fill_in "Size", with: @container.size
    fill_in "User", with: @container.user_id
    click_on "Create Container"

    assert_text "Container was successfully created"
    click_on "Back"
  end

  test "should update Container" do
    visit container_url(@container)
    click_on "Edit this container", match: :first

    fill_in "Cargo owner", with: @container.cargo_owner
    fill_in "Container type", with: @container.container_type
    fill_in "Number", with: @container.number
    fill_in "Size", with: @container.size
    fill_in "User", with: @container.user_id
    click_on "Update Container"

    assert_text "Container was successfully updated"
    click_on "Back"
  end

  test "should destroy Container" do
    visit container_url(@container)
    click_on "Destroy this container", match: :first

    assert_text "Container was successfully destroyed"
  end
end
