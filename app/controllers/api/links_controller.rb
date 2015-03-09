class Api::LinksController < Api::BaseController
  respond_to :json

  def create
    url = params[:link][:url]
    link_data = Link.discover(url)
    respond_with Link.create(link_data), location: nil
  end

  def index
    respond_with Link.all
  end

  def update
    @link = Link.find(params[:id])
    @link.update_attributes(link_params)
    respond_with @link
  end

  def destroy
    link = Link.find(params[:id])
    link.destroy
    render json: nil, status: :ok
  end

  def buffer
    respond_with Link.unused.approved
  end

  private

  def link_params
    params.require(:link).permit(
      :title,
      :description,
      :category,
      :approved
    )
  end
end