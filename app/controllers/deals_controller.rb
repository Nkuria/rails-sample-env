class DealsController < ApplicationController
  before_action :set_deal, only: %i[show edit update destroy]

  # GET /deals/1 or /deals/1.json
  def show; end

  # DELETE /deals/1 or /deals/1.json
  def destroy
    @deal.destroy

    respond_to do |format|
      format.html { redirect_to deals_path, status: :see_other, notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_deal
    @deal = Deal.find(params[:id])
  end
end
