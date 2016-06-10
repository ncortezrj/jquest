class UserPolicy  < ApplicationPolicy

  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      case @user.role.to_sym
        when :teacher
          scope.where group: @user.group
        else
          scope.all
      end
    end
  end


  def create?
    @user and @user.role? :teacher, :admin
  end

  def import?
    create?
  end

  def index?
    create?
  end

  def show?
    create? or @user == @model
  end

  def update?
    create? or @user == @model
  end

  def destroy?
    @user and @user.role? :admin
  end

  def destroy_all?
    destroy?
  end


end
