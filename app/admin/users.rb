ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :email, :password_digest, :remember_digest, :admin, :activation_digest, :activated, :activated_at, :reset_digest, :reset_sent_at, :unique_name, :profile
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :password_digest, :remember_digest, :admin, :activation_digest, :activated, :activated_at, :reset_digest, :reset_sent_at, :unique_name, :profile]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
