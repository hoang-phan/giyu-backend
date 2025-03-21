class Api::BaseController < InheritedResources::Base
  skip_forgery_protection

  respond_to :json

  protected

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.all)
  end

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find(params[:id]))
  end

  def build_resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.new(permitted_params[resource_request_name]))
  end

  private

  def resource_request_name
    resource_class.name.underscore.to_sym
  end
end
