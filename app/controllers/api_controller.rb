class ApiController < ApplicationController
  protect_from_forgery

  private

  def owner?(item)
    if item.user == current_user
      yield
    else
      render insufficient_permissions_error
    end
  end

  def owner_or_admin?(item)
    if item.user == current_user || current_user.try(:admin?)
      yield
    else
      render insufficient_permissions_error
    end
  end

  def unprocessable_entity_error(item, action)
    {
      json: { error: "#{item.capitalize} could not be #{action}d" },
      status: :unprocessable_entity
    }
  end

  def insufficient_permissions_error
    {
      json: { error: 'Insufficient permissions' },
      status: :unauthorized
    }
  end
end
