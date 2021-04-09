ActiveAdmin.register Message do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :room_id, :content, :addressee_user_id, :read
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :room_id, :content, :addressee_user_id, :read]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
