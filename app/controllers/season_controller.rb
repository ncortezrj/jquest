class SeasonController < ApplicationController
  before_filter :can!
  rescue_from Pundit::NotAuthorizedError, with: :deny_access

  def index
    render './index'
  end

  def can!
    # A season module must be found
    raise Pundit::NotAuthorizedError.new "You don't have the permission to see this." unless season
  end

  # Current controller engine
  def engine_name
    self.class.to_s.split("::").first
  end

  # Current season
  def season
    @season ||= policy_scope(Season).find_by_engine_name(engine_name)
  end

  # User progression
  def progression
    # This method must be implemented in a child controller
    raise NotImplementedError
  end


  protected
    def deny_access(e)
      redirect_to '/', :alert => e.message
    end
end
