ActiveAdmin.register User do
  permit_params :email, :phone_number, :password, :password_confirmation,
                :otp_required_for_login, :home_country, :spoken_language,
                :role, :created_at, :updated_at, :confirmed_at, :invitable,
                :school_id, :group_id, :firstname, :lastname, :level

  belongs_to :group, :optional => true
  menu label: 'Users', parent: 'Team'

  before_create do |user|
    user.skip_confirmation!
  end

  before_update do |user|
    user.skip_reconfirmation!
  end

  active_admin_import({
    validate: false
  })

  batch_action :invite do |ids, inputs|
    User.find(ids).each do |user|
      user.invite!
    end
    redirect_to collection_path, :flash =>{
      :notice =>  ids.length.to_s + ' user'.pluralize(ids.length) + ' invited.'
    }
  end

  batch_action :reset, confirm: "This will remove every activities for the selected user(s)" do |ids, inputs|
    User.find(ids).each do |user|
      user.reset!
    end
    redirect_to collection_path, :flash =>{
      :notice =>  ids.length.to_s + ' user'.pluralize(ids.length) + ' restored.'
    }
  end

  member_action :reset, method: :get do
    resource.reset!
    redirect_to resource_path, notice: "Restored to initial state"
  end

  member_action :invite, method: :get do
    resource.invite!
    redirect_to resource_path, notice: "Invited to jQuest"
  end

  member_action :sign_in_as, method: :get do
    # Sign in with devise
    sign_in resource, { :bypass => true }
    # Redirect to root
    redirect_to root_path
  end

  action_item :invite, only: :show do
    link_to 'Invite User', invite_admin_user_path, :confirm => "Are you sure?"
  end

  action_item :sign_in_as, only: :show do
    link_to "Sign in as User", sign_in_as_admin_user_path
  end

  index do
    selectable_column
    id_column
    column :email
    column :firstname
    column :lastname
    column :group
    column :level do |user|
      user.points.find_or_create_by(season: user.member_of).level
    end
    column :round do |user|
      user.points.find_or_create_by(season: user.member_of).round
    end
    column :home_country
    column 'Activities', :activity_count
    column 'Assignments', :assignment_count
    actions
  end


  show :title => proc{|user| user.email } do
    columns do
      column do
        default_main_content
      end
      column do

        panel link_to("User progression",  admin_user_points_path(user)) do
          table_for user.points do
            column :season
            column :level
            column :round
            column "Points", :value
          end
        end

        panel link_to("User assignments",  admin_user_assignments_path(user)) do
          table_for user.assignments.pending.includes(:resource).order('created_at desc') do
            caption 'Pending'
            column :season
            column :resource
            column :level
          end
        end

        panel link_to("User activities",  admin_user_activities_path(user)) do
          table_for user.activities.includes(:season).order('created_at desc') do
            column :season
            column :taxonomy
            column :points
            column :created_at
          end
        end

      end
    end
  end

  filter :email
  filter :firstname
  filter :lastname
  filter :school
  filter :activity_count
  filter :assignment_count
  filter :group

  form do |f|
    f.inputs "Details" do
      f.input :email
      f.input :phone_number
      f.input :firstname
      f.input :lastname
      f.input :role, as: :radio
      f.input :otp_required_for_login, as: :boolean
      f.input :home_country
      f.input :spoken_language
      f.input :school_id, :as => :select,  collection: School.all
      f.input :group_id, :as => :select,  collection: Group.all
    end

    f.inputs "Password" do
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
