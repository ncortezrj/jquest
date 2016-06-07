ActiveAdmin.register Activity do
  permit_params :user_id, :season_id, :resource_id, :resource_type, :points, :taxonomy
  belongs_to :user, :optional => true


  form do |f|
    f.inputs "Details" do
      f.input :user
      f.input :season
      f.input :resource_type, as: :select, collection: Activity::resource_types
      f.input :resource_id
      f.input :points
      f.input :taxonomy
    end
    f.actions
  end
end