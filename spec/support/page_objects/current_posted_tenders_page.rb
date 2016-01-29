class CurrentPostedTendersPage
  include Capybara::DSL
  include TendersPageFunctions

  def visit_page
    visit '/current_posted_tenders'
    self
  end

  def seed_data user_id
    102.times do
      Tender.create(
        ref_no: 'InHouse-' + (Time.now.to_f*1000).to_i.to_s,
        buyer_company_name: Faker::Company.name,
        buyer_contact_number: Faker::PhoneNumber.phone_number,
        buyer_name: Faker::Name.name,
        buyer_email: Faker::Internet.email,
        description: Faker::Lorem.sentences(5).join(" "),
        long_description: Faker::Lorem.sentences(10).join("\r\n"),
        published_date: Faker::Date.between(7.days.ago, Time.now.in_time_zone('Singapore').to_date),
        closing_datetime: Faker::Time.between(DateTime.now + 7.days, DateTime.now + 14.days),
        postee_id: user_id
      )
    end

    101.times do
      Tender.create(
        ref_no: 'InHouse-' + (Time.now.to_f*1000).to_i.to_s,
        buyer_company_name: Faker::Company.name,
        buyer_contact_number: Faker::PhoneNumber.phone_number,
        buyer_name: Faker::Name.name,
        buyer_email: Faker::Internet.email,
        description: Faker::Lorem.sentences(5).join(" "),
        long_description: Faker::Lorem.sentences(10).join("\r\n"),
        published_date: Faker::Date.between(Time.now.in_time_zone('Singapore').to_date - 7.days, Time.now.in_time_zone('Singapore').to_date - 6.days),
        closing_datetime: Faker::Time.between(Time.now.in_time_zone('Singapore') - 2.days, Time.now.in_time_zone('Singapore').to_date - 1.days),
        postee_id: user_id
      )
    end
  end

end