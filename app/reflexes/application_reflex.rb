# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  delegate :current_user, :true_user, to: :connection

  def initalize(*args)
    super
    Current.organization = current_user&.organizations&.find_by(id: session[:organization_id])
  end

  def authorized_user(include_true_user = false)
    @authorized_user = if include_true_user
      AuthorizedUser.new(true_user || current_user || User.new)
    else
      AuthorizedUser.new(current_user || User.new)
    end
  end
end
