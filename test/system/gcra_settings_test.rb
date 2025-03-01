require 'application_system_test_case'

class GcraSettingsTest < ApplicationSystemTestCase
  setup do
    @gcra_setting = gcra_settings(:one)
  end

  test 'visiting the index' do
    visit gcra_settings_url

    assert_selector 'h1', text: 'Gcra Settings'
  end

  test 'creating a Gcra setting' do
    visit gcra_settings_url
    click_on 'New Gcra Setting'

    click_on 'Create Gcra setting'

    assert_text 'Gcra setting was successfully created'
    click_on 'Back'
  end

  test 'updating a Gcra setting' do
    visit gcra_settings_url
    click_on 'Edit', match: :first

    click_on 'Update Gcra setting'

    assert_text 'Gcra setting was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Gcra setting' do
    visit gcra_settings_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Gcra setting was successfully destroyed'
  end
end
