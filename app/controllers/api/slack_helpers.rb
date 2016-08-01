module API
  module SlackHelpers
    def slack_client
      @slack_client ||= Slack::Web::Client.new
    end

    def slack_invite_url
      @slack_invite_url ||= slack_hostname + '/api/users.admin.invite'
    end

    def slack_invite_uri
      @slack_invite_uri ||= URI.parse(slack_invite_url)
    end

    def slack_invite_headers
      {'Content-Type' =>'application/json'}
    end

    def slack_invite_user!(user)
      # Build request BODY
      payload = {
        token: slack_client.token,
        email: user.email
      }
      # Send it to slack
      response = Net::HTTP.post_form(slack_invite_uri, payload)
      # Test response statis
      if response.code.to_i == 200
        # Check body
        body = JSON.parse response.body
        # Mark the user as invited
        user.update_attribute :invited_to_channel_at, Time.now
        # Throw an error if not ok
        raise body['error'] unless body['ok']
      else
        raise "Unable to reach Slack or invite user (#{response.code})."
      end
    end

    def slack_hostname
      @slack_hostname ||= begin
        # Get team info
        res = slack_client.team_info
        # Something is wrong!
        error! 'Unable to reach slack API' unless res[:ok]
        # Build the full hostname
        "https://#{res[:team][:domain]}.slack.com"
      end
    end

    def slack_members
      # Get user list
      res = slack_client.users_list(presence: 1)
      # Something when wrong?
      error! 'Unable to get information about the slack channels' unless res[:ok]
      # Get members for result
      members = res.members or []
      # Remove deleted members
      members.select { |u| not u['deleted'] }
    end

    def slack_status_for(user)
      members = slack_members
      # Return a hash
      OpenStruct.new(
        total: members.length,
        active: members.select { |u| u.presence == 'active' }.length,
        hostname: slack_hostname,
        is_member: members.select { |u| u.profile.email == current_user.email }.length > 0,
        is_invited: !current_user.invited_to_channel_at.nil?)
    end
  end
end
