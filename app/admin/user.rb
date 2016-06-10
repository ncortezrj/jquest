ActiveAdmin.register User do
  permit_params :email, :phone_number, :password, :password_confirmation,
                :otp_required_for_login,
                :role, :created_at, :updated_at, :confirmed_at,
                :school_id, :group_id

  menu label: 'Users', parent: 'Team'

  active_admin_import({
    validate: false
  })

  index do
    selectable_column
    id_column
    column :email
    column :phone_number
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show :title => proc{|user| user.email }

  filter :email
  filter :phone_number
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :school
  filter :group

  form do |f|
    f.inputs "Details" do
      f.input :email
      f.input :phone_number
      f.input :role, as: :select, collection: User.roles.keys
      f.input :otp_required_for_login, as: :boolean
      f.input :confirmed_at, as: :datepicker
      f.input :school_id, :as => :select,  collection: School.all
      f.input :group_id, :as => :select,  collection: Group.all
    end

    f.inputs "Password" do
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  sidebar "User activity", only: [:show, :edit] do
    ul do
      li link_to "Activities",  admin_user_activities_path(user)
    end
  end
end
