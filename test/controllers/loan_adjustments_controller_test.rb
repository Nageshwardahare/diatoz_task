require "test_helper"

class LoanAdjustmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get loan_adjustments_new_url
    assert_response :success
  end
end
