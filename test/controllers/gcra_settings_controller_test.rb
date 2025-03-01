require 'test_helper'

class GcraSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gcra_setting = gcra_settings(:one)
  end

  test 'should get index' do
    get gcra_settings_url

    assert_response :success
  end

  test 'should get new' do
    get new_gcra_setting_url

    assert_response :success
  end

  test 'should create gcra_setting' do
    assert_difference('GcraSetting.count') do
      post gcra_settings_url, params: { gcra_setting: {} }
    end

    assert_redirected_to gcra_setting_url(GcraSetting.last)
  end

  test 'should show gcra_setting' do
    get gcra_setting_url(@gcra_setting)

    assert_response :success
  end

  test 'should get edit' do
    get edit_gcra_setting_url(@gcra_setting)

    assert_response :success
  end

  test 'should update gcra_setting' do
    patch gcra_setting_url(@gcra_setting), params: { gcra_setting: {} }

    assert_redirected_to gcra_setting_url(@gcra_setting)
  end

  test 'should destroy gcra_setting' do
    assert_difference('GcraSetting.count', -1) do
      delete gcra_setting_url(@gcra_setting)
    end

    assert_redirected_to gcra_settings_url
  end
end
