class SectionsController < ApplicationController
  before_action :set_menu
  before_action :set_section, only: [ :edit, :update, :destroy ]

  def new
    @section = @menu.sections.build
  end

  def create
    @section = @menu.sections.build(section_params)

    if @section.save
      redirect_to @menu, notice: "Section was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @section.update(section_params)
      redirect_to @menu, notice: "Section was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @section.destroy
    redirect_to @menu, notice: "Section was successfully deleted."
  end

  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def set_section
    @section = @menu.sections.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:name, :description, :position)
  end
end
