require 'spec_helper'

feature "access pages by read_only unsubscribed users" do
  let(:brain_tree_page) { BrainTreePage.new }
  let!(:yet_to_subscribe_user) {create(:user, :read_only, :braintree)}

  feature 'billing page' do
    
    before :each do
      login_as(yet_to_subscribe_user, scope: :user)
    end

    scenario 'should have correct contents in page' do
      brain_tree_page.visit_billing_page
      expect(page).to have_content 'Days left till end of Free Trial'
      expect(page).to have_link 'Subscribe Now', href: subscribe_path
      expect(page).not_to have_content 'Next Billing Date'
      expect(page).not_to have_link 'Change Payment Settings', href: change_payment_path
    end

  end

end