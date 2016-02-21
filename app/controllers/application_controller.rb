class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :intercept_bots

  before_action do
    if user_signed_in? && current_user.email == 'vljc17@gmail.com'
      Rack::MiniProfiler.authorize_request
    end
  end

  protected
    def deny_read_only_access
      if user_signed_in? && current_user.read_only?
        flash[:alert] = "You are not authorized to view this page."
        redirect_to current_tenders_path
      end
    end

    def deny_write_only_access
      if user_signed_in? && current_user.write_only?
        flash[:alert] = "You are not authorized to view this page."
        redirect_to current_posted_tenders_path
      end
    end

    def devise_parameter_sanitizer
      if resource_class == User
        User::ParameterSanitizer.new(User, :user, params)
      else
        super # Use the default one
      end
    end

    def deny_unconfirmed_users
      if user_signed_in? && !current_user.fully_confirmed?
        flash[:warning] = "Please confirm your account first. We regret that email delivery might be delayed. Also, check your junk/spam folder in case the confirmation email got delivered there instead of your inbox."
        redirect_to new_user_confirmation_path
      end
    end

    def deny_confirmed_users
      if user_signed_in? && current_user.fully_confirmed?
        flash[:success] = "Your account has been confirmed."
        if current_user.read_only?
          redirect_to current_tenders_path
        elsif current_user.write_only?
          redirect_to current_posted_tenders_path
        end
      end
    end

    def check_user_keywords
      if user_signed_in? && current_user.keywords.blank?
        flash[:info] = "Get started with Tengence by filling in keywords related to your business."
        redirect_to keywords_tenders_path
      end
    end

    def intercept_bots
      user_agent = request.user_agent
      if user_agent =~ /libwww-perl/
        render nothing: true, status: 403
      end
    end
end
