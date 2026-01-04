class MenusController < ApplicationController
  before_action :authenticate_user!, except: [ :public ]
  before_action :set_menu, only: [ :show, :edit, :update, :destroy, :qr_code ]
  before_action :set_public_menu, only: [ :public ]

  def index
    @menus = current_user.menus.order(created_at: :desc)
  end

  def show
    @sections = @menu.sections.includes(:menu_items)
  end

  def public
    @sections = @menu.sections.includes(:menu_items)
    render layout: "application"
  end

  def new
    @menu = current_user.menus.new
  end

  def create
    @menu = current_user.menus.new(menu_params)

    if @menu.save
      redirect_to @menu, notice: "Menu was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @menu.update(menu_params)
      redirect_to @menu, notice: "Menu was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu.destroy
    redirect_to menus_url, notice: "Menu was successfully deleted."
  end

  def qr_code
    require "rqrcode"

    # Generate the URL for the public menu page (customer view)
    menu_url = public_menu_url(@menu, host: request.base_url)

    # Generate QR code
    @qr = RQRCode::QRCode.new(menu_url)

    respond_to do |format|
      format.html
      format.svg do
        render inline: @qr.as_svg(
          color: "000",
          shape_rendering: "crispEdges",
          module_size: 6,
          standalone: true,
          use_path: true
        ), content_type: "image/svg+xml"
      end
      format.png do
        png = @qr.as_png(
          bit_depth: 1,
          border_modules: 4,
          color_mode: ChunkyPNG::COLOR_GRAYSCALE,
          color: "black",
          file: nil,
          fill: "white",
          module_px_size: 6,
          resize_exactly_to: false,
          resize_gte_to: false,
          size: 300
        )
        send_data png.to_s, type: "image/png", disposition: "inline"
      end
    end
  end

  private

  def set_menu
    @menu = current_user.menus.find(params[:id])
  end

  def set_public_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :description)
  end
end
