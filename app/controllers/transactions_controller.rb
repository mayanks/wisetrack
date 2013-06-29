class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  # GET /transactions
  # GET /transactions.json
  def index
    #valid_account_ids = current_user.accounts.map{|a|a.id}
    if params[:account_id]
      @account = current_user.accounts.find(params[:account_id])
    elsif params[:category_id]
      @category = Category.find(params[:category_id])
    else
      @account = current_user.accounts.current_accounts.first
    end

    if @account
      @transactions = Transaction.where(:account_id => @account.id).order("date desc, created_at desc").limit(100)
      @transaction = Transaction.new(:date => Date.today, :account_id => @account.id)
    else
      @transactions = Transaction.where(:category_id => @category.id).order("date desc, created_at desc").limit(100)
    end

    @current_date = Date.today

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = Transaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(params[:transaction])

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to account_transactions_path(@transaction.account), notice: 'Transaction was successfully created.' }
        format.json { render json: @transaction, status: :created, location: @transaction }
      else
        format.html { redirect_to account_transactions_path(current_user.accounts.expense_accounts.first), alert: 'Transaction could not be added.' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def transfer
    from_account = current_user.accounts.find_by_id(params[:debit_from_id])
    to_account = current_user.accounts.find_by_id(params[:credit_to_id])
    amount = params[:amount].to_i if params[:amount]
    date = params[:on].to_date if params[:on]
    category = Category.find_by_name('transfer')

    if amount > 0 and date
      t1 = Transaction.create(:amount => amount, :t_type => Transaction::TYPE_DEBIT, :account_id => from_account.id, :category_id => category.id, :description => "Transferring to #{to_account.name}", :date => date)
      t2 = Transaction.create(:amount => amount, :t_type => Transaction::TYPE_CREDIT, :account_id => to_account.id, :category_id => category.id, :description => "Transferred from #{from_account.name}", :date => date)
    end

    redirect_to account_transactions_path(to_account)
  end

  # PUT /transactions/1
  # PUT /transactions/1.json
  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        @transaction.account.update_transactions
        format.html { redirect_to transactions_path, notice: 'Transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end
end
