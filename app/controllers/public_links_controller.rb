# PublicLinksController
require 'rqrcode'

class PublicLinksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find_by!(username: params[:username])
    @public_links = Link.where(user_id: @user.id, public: true)
    @qr = RQRCode::QRCode.new(request.original_url)
    @svg = @qr.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
  end
end
