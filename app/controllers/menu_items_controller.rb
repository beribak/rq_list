class MenuItemsController < ApplicationController
  before_action :set_section
  before_action :set_menu_item, only: [ :edit, :update, :destroy ]

  def new
    @menu_item = @section.menu_items.build
  end

  def create
    @menu_item = @section.menu_items.build(menu_item_params)

    if @menu_item.save
      redirect_to menu_path(@section.menu), notice: "Menu item was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to menu_path(@section.menu), notice: "Menu item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to menu_path(@section.menu), notice: "Menu item was successfully deleted."
  end

  private

  def set_section
    @section = Section.find(params[:section_id])
  end

  def set_menu_item
    @menu_item = @section.menu_items.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :position)
  end
end
