FactoryGirl.define do
  factory :tender do
    ref_no {Faker::Company.ein}
    buyer_company_name
    buyer_name {Faker::Name.name}
    buyer_contact_number {Faker::PhoneNumber.phone_number}
    buyer_email {Faker::Internet.email}
    description {Faker::Hipster.sentence}

    trait :gebiz do
      external_link "gebiz.gov"
    end

    trait :non_gebiz do
      external_link {Faker::Internet.url}
    end

    trait :inhouse do
      external_link 'InHouse'
    end

    trait :current do
      published_date {Faker::Date.between(2.days.ago, Date.today)}
      closing_datetime {Faker::Time.between(Time.now, Time.now + 1.month)}
    end

    factory :gebiz_tender, traits: [:gebiz]
    factory :non_gebiz_tender, traits: [:non_gebiz]
  end
end