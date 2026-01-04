class SectionsController < ApplicationController
  before_action :set_menu
  before_action :set_section, only: [ :edit, :update, :destroy ]

  def new
    @section = @menu.sections.build
  end

  def create
    @section = @menu.sections.build(section_params)
    @section.content_locale = I18n.locale.to_s

    if @section.save
      trigger_translations(@section, [ :name ])
      redirect_to @menu, notice: "Section was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @section.update(section_params)
      trigger_translations(@section, [ :name ])
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

  def trigger_translations(record, fields)
    target_locale = record.opposite_locale
    fields.each do |field|
      TranslateContentJob.perform_later(record, field, target_locale)
    end
  end
end
