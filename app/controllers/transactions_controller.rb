class TransactionsController < ApplicationController
  include Pagy::Backend
  before_action :set_transaction, only: %i[show edit update destroy]

  # GET /transactions or /transactions.json
  def index
    @q = Transaction.ransack(params[:q])
    @pagy, @transactions = pagy(@q.result.includes(:customer, :user))

    respond_to do |format|
      format.html
      format.csv do
        send_data TransactionsCsvService.generate(@transactions), filename: "transactions-#{Date.today}.csv"
      end
    end
  end

  # GET /transactions/1 or /transactions/1.json
  def show; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit; end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy

    respond_to do |format|
      format.html do
        redirect_to transactions_path, status: :see_other, notice: 'Transaction was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def summary
    @transactions = Transaction.includes(:customer, deals: :item).order(created_at: :desc)

    # Hash structure: { customer_name => { item_name => { date => { tax_exclusive, tax_inclusive } } } }
    @summary_data = @transactions.each_with_object({}) do |transaction, summary|
      customer_name = transaction.customer.name
      summary[customer_name] ||= {}

      transaction.deals.each do |deal|
        item_name = deal.item.name
        summary[customer_name][item_name] ||= {}

        date = transaction.created_at.to_date
        summary[customer_name][item_name][date] ||= { tax_exclusive: 0, tax_inclusive: 0 }

        amount = deal.price_cents * deal.quantity / 100.0
        summary[customer_name][item_name][date][:tax_exclusive] += amount
        summary[customer_name][item_name][date][:tax_inclusive] += amount * 1.16
      end
    end

    @dates = @transactions.map { |t| t.created_at.to_date }.uniq.sort
    @tax_mode = params[:tax_mode] || 'exclusive'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:user_id, :customer_id, :amount,
                                        deals_attributes: %i[id price quantity item_id _destroy])
  end
end
