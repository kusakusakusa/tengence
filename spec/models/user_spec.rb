require "spec_helper"

feature User, type: :model do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should_not validate_presence_of :braintree_subscription_id }
  it { should_not validate_presence_of :default_payment_method_token }
  it { should_not validate_presence_of :braintree_customer_id }

  it { should have_many(:watched_tenders).dependent(:destroy) }
  it { should have_many(:viewed_tenders).dependent(:destroy) }
  it { should have_many(:current_tenders).through(:watched_tenders) }
  it { should have_many(:past_tenders).through(:watched_tenders) }
  it { should have_many(:current_posted_tenders) }
  it { should have_many(:past_posted_tenders) }
  it { should have_many(:trial_tenders).dependent(:destroy) }

  it { should callback(:hash_email).before(:create) }
  it { should callback(:register_braintree_customer).after(:commit).on(:create) }
  it { should callback(:destroy_braintree_customer).before(:destroy) }
  it { should_not callback(:hash_email).before(:save) }

  let!(:user) { create(:user, :read_only) }
  let!(:write_only_user) { create(:user, :write_only) }
  let(:tender) { create(:gebiz_tender) }

  feature 'validations' do

    feature 'keywords' do

      scenario 'valid for less than 20' do
        user.keywords = "lol,ok"
        expect(user.valid?).to eq true
      end

      scenario 'invalid for more than 20' do
        user.keywords = "lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,"
        expect(user.valid?).to eq false
      end

      scenario 'valid for users with whitelisted emails for more than 20 keywords' do
        user = create(:user, email: 'vljc17@gmail.com')
        user.keywords = "lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,lol,"
        expect(user.valid?).to eq true
      end

    end

  end

  feature 'scope' do

    feature 'confirmed' do

      scenario 'should not include unconfirmed/[ending_reconfirmation users' do
        unconfirmed_user = create(:user, :unconfirmed)
        pending_reconfirmation_user = create(:user, :pending_reconfirmation)
        expect(User.confirmed.include? pending_reconfirmation_user).to eq false
        expect(User.confirmed.include? unconfirmed_user).to eq false
      end

      scenario 'should include users with unconfirmed_email == "" as confirmed users' do
        user = create(:user, :read_only, unconfirmed_email: '')
        expect(User.confirmed.include? user).to eq true
      end

    end

    feature 'read_only' do

      scenario 'should not include write_only_user' do
        expect(User.read_only.all.include?(write_only_user)).to eq false
      end

      scenario 'should include read_only_user' do
        expect(User.read_only.all.include?(user)).to eq true
      end

    end

    feature 'write_only' do

      scenario 'should include write_only_user' do
        expect(User.write_only.all.include?(write_only_user)).to eq true
      end

      scenario 'should not include read_only_user' do
        expect(User.write_only.all.include?(user)).to eq false
      end

    end

  end

  feature 'class methods' do

    scenario 'email_available?' do
      expect(User.email_available?(user.email)).to eq false
      expect(User.email_available?('one@piece.com')).to eq true
    end

  end

  feature 'instance methods' do

    let!(:unconfirmed_user) { create(:user, :unconfirmed) }
    let!(:pending_reconfirmation_user) { create(:user, :pending_reconfirmation) }
    let!(:subscribed_user) { create(:user, :subscribed_one_month) }
    let!(:unsubscribed_user) { create(:user, :unsubscribed_one_month) }

    scenario 'name' do
      expect(user.name).to eq "#{user.first_name} #{user.last_name}"
    end

    scenario 'yet_to_subscribe?' do
      expect(subscribed_user.yet_to_subscribe?).to eq false
      expect(user.yet_to_subscribe?).to eq true
      expect(unsubscribed_user.yet_to_subscribe?).to eq false
      Timecop.freeze(Time.current + 31.days) do
        expect(unsubscribed_user.yet_to_subscribe?).to eq false
      end
    end

    scenario 'subscribed?' do
      expect(subscribed_user.subscribed?).to eq true
      expect(user.subscribed?).to eq false
      expect(unsubscribed_user.subscribed?).to eq false
      Timecop.freeze(Time.current + 31.days) do
        expect(unsubscribed_user.subscribed?).to eq false
      end
    end

    scenario 'unsubscribed?' do
      expect(subscribed_user.unsubscribed?).to eq false
      expect(user.unsubscribed?).to eq false
      expect(unsubscribed_user.unsubscribed?).to eq true
      Timecop.freeze(Time.current + 31.days) do
        expect(unsubscribed_user.unsubscribed?).to eq true
      end
    end

    scenario 'can_resubscribe?' do
      expect(subscribed_user.can_resubscribe?).to eq false
      expect(user.can_resubscribe?).to eq false
      expect(unsubscribed_user.can_resubscribe?).to eq false
      Timecop.freeze(Time.current + 31.days) do
        expect(unsubscribed_user.can_resubscribe?).to eq true
      end
    end

    scenario 'cannot_resubscribe?' do
      expect(subscribed_user.cannot_resubscribe?).to eq false
      expect(user.cannot_resubscribe?).to eq false
      expect(unsubscribed_user.cannot_resubscribe?).to eq true
      Timecop.freeze(Time.current + 31.days) do
        expect(unsubscribed_user.cannot_resubscribe?).to eq false
      end
    end

    scenario 'finished_trial_but_yet_to_subscribe?' do
      expect(subscribed_user.finished_trial_but_yet_to_subscribe?).to eq false
      expect(user.finished_trial_but_yet_to_subscribe?).to eq false
      Timecop.freeze(Time.current + 31.days) do
        expect(user.finished_trial_but_yet_to_subscribe?).to eq true
      end
      expect(unsubscribed_user.finished_trial_but_yet_to_subscribe?).to eq false
      Timecop.freeze(Time.current + 31.days) do
        expect(unsubscribed_user.finished_trial_but_yet_to_subscribe?).to eq false
      end
    end

    scenario 'fully_confirmed?' do
      expect(user.fully_confirmed?).to eq true
      expect(unconfirmed_user.fully_confirmed?).to eq false
      expect(pending_reconfirmation_user.fully_confirmed?).to eq false
    end

    scenario 'trial_tender_ids' do
      expect(user.trial_tenders.count).to eq 0
      TrialTender.create(user_id: user.id, tender_id: tender.ref_no)
      expect(user.reload.trial_tenders.count).to eq 1
    end

    scenario 'read_only?' do
      expect(user.read_only?).to eq true
      expect(write_only_user.read_only?).to eq false
    end

    scenario 'write_only?' do
      expect(user.write_only?).to eq false
      expect(write_only_user.write_only?).to eq true
    end

  end

end