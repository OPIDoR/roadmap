class UserMailer < ActionMailer::Base
	default from: 'info-opidor@inist.fr'

  def welcome_notification(user)
    @user = user
    FastGettext.with_locale FastGettext.default_locale do
      mail(to: @user.email,
           subject: _('Welcome to %{application_name}') % { application_name: Rails.configuration.branding[:application][:name] }
           )
    end
  end

	def sharing_notification(role, user)
    @role = role
    @user = user
    FastGettext.with_locale FastGettext.default_locale do
  		mail(to: @role.user.email,
           subject: _('A Data Management Plan in %{application_name} has been shared with you by %{user_name}') % 
           { 
             application_name: Rails.configuration.branding[:application][:name],
             user_name: @user.name
            }
      )
    end
	end

	def permissions_change_notification(role, current_user)
		@role = role
                @current_user = current_user
		FastGettext.with_locale FastGettext.default_locale do
      mail(to: @role.user.email,
           subject: "#{_('Changed permissions on a DMP in')} #{Rails.configuration.branding[:application][:name]}")
    end
	end

	def project_access_removed_notification(user, plan, current_user)
		@user = user
		@plan = plan
                @current_user = current_user
    FastGettext.with_locale FastGettext.default_locale do
  		mail(to: @user.email,
           subject: "#{_('Permissions removed on a DMP in')} #{Rails.configuration.branding[:application][:name]}")
    end
	end

  def api_token_granted_notification(user)
      @user = user
      FastGettext.with_locale FastGettext.default_locale do
        mail(to: @user.email,
             subject: "#{_('API rights in')} #{Rails.configuration.branding[:application][:name]}")
      end
  end

  def anonymization_warning(user)
    @user = user
    @end_date = (@user.last_sign_in_at + 5.years).to_date
    FastGettext.with_locale FastGettext.default_locale do
      mail(to: @user.email, subject: "#{_('Account expiration in')} #{Rails.configuration.branding[:application][:name]}")
    end
  end

  def anonymization_notice(user)
    @user = user
    FastGettext.with_locale FastGettext.default_locale do
      mail(to: @user.email, subject: "#{_('Account expired')} #{Rails.configuration.branding[:application][:name]}")
    end
  end
end
