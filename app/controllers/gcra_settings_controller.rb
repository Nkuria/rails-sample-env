class GcraSettingsController < ApplicationController
  before_action :set_gcra_setting, only: %i[show edit update destroy]

  # GET /gcra_settings or /gcra_settings.json
  def index
    @gcra_settings = if current_company
                       current_company.gcra_settings.all
                     else
                       GcraSetting.all
                     end
  end

  # GET /gcra_settings/1 or /gcra_settings/1.json
  def show; end

  # GET /gcra_settings/new
  def new
    @gcra_setting = GcraSetting.new
  end

  # GET /gcra_settings/1/edit
  def edit; end

  # POST /gcra_settings or /gcra_settings.json
  def create
    @gcra_setting = GcraSetting.new(gcra_setting_params)

    respond_to do |format|
      if @gcra_setting.save
        format.html { redirect_to gcra_settings_url, notice: 'GCRA setting was successfully created.' }
        format.json { render :show, status: :created, location: @gcra_setting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gcra_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gcra_settings/1 or /gcra_settings/1.json
  def update
    respond_to do |format|
      if @gcra_setting.update(gcra_setting_params)
        format.html { redirect_to gcra_settings_url, notice: 'GCRA setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @gcra_setting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gcra_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gcra_settings/1 or /gcra_settings/1.json
  def destroy
    @gcra_setting.destroy

    respond_to do |format|
      format.html { redirect_to gcra_settings_url, notice: 'GCRA setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gcra_setting
    @gcra_setting = GcraSetting.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def gcra_setting_params
    params.fetch(:gcra_setting, {}).permit(:company_id, :name, :bucket_size, :emission_interval)
  end
end
