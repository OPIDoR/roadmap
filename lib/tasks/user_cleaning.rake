namespace :usercleaning do
  desc 'Remove users who haven\'t accepted invitation after 1 month.'
  task non_accepted_invitations: :environment do
    Rails.logger.info 'Deleting user uncomfirmed users invited over a month ago'
    User
      .where('invitation_sent_at < ? AND invitation_accepted_at IS NULL ', 1.month.ago)
      .each do |user|
      Rails.logger.info user.email + ' deleted'
      user.destroy
    end
  end

  desc 'Anonymize users who haven\'t been connected for five years.'
  task anonymize_users_after_5_years: :environment do
    Rails.logger.info 'Anonymizing users who have not connected for the last 5 years'
    User.where('last_sign_in_at < ? ', 5.years.ago).each do |user|
      user.firstname = 'anonymous'
      user.surname = 'user'
      user.email = 'anonymous' + user.id.to_s + '@opidor.fr'
      user.last_sign_in_at = nil

      Rails.logger.info "User #{user.id} anonymized" if user.save
    end
  end
end
