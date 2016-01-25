class TendersPage
  include Capybara::DSL

  def visit_home_page
    visit '/'
    self
  end

  def visit_terms_of_service_page
    visit '/terms-of-service'
    self
  end

  def visit_account_page
    visit '/users/edit'
    self
  end

  def visit_resend_confirmation_page
    visit 'users/confirmation/new'
    self
  end

  # read only
  def visit_current_tenders_page
    visit '/current_tenders'
    self
  end

  def visit_past_tenders_page
    visit '/past_tenders'
    self
  end

  def visit_keywords_tenders_page
    visit '/keywords_tenders'
    self
  end

  def visit_watched_tenders_page
    visit '/watched_tenders'
    self
  end

  # write only
  def visit_new_tender_page
    visit '/tenders/new'
    self
  end

  def visit_current_posted_tenders_page
    visit '/current_posted_tenders'
    self
  end

  def visit_past_posted_tenders_page
    visit '/past_posted_tenders'
    self
  end
end