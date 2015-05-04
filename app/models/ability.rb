class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    end

    if user.id.nil?
      send("visitor")
    else
      send(user.role.to_s)
    end

    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  def visitor
    can :read, :all

    cannot :show, Chapter, :showable_by_visitor => false
  end

  def user
    visitor
    puts "here User"

    can :show, Chapter
  end

  def admin
    user
    puts "here Admin"

    can :edit, :all
    can :manage, :all
  end
end
