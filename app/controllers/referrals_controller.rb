class ReferralsController < ApplicationController
  # GET /referrals
  # GET /referrals.json
  def index
    @referrals = Referral.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @referrals }
    end
  end

  # GET /referrals/1
  # GET /referrals/1.json
  def show
    @referral = Referral.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @referral }
    end
  end

  # GET /referrals/new
  # GET /referrals/new.json
  def new
    @referral = Referral.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @referral }
    end
  end

  # GET /referrals/1/edit
  def edit
    @referral = Referral.find(params[:id])
  end

  # POST /referrals
  # POST /referrals.json
  def create
    @referral = Referral.new(params[:referral])

    respond_to do |format|
      if @referral.save
        format.html { redirect_to @referral, notice: 'Referral was successfully created.' }
        format.json { render json: @referral, status: :created, location: @referral }
      else
        format.html { render action: "new" }
        format.json { render json: @referral.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /referrals/1
  # PUT /referrals/1.json
  def update
    @referral = Referral.find(params[:id])

    respond_to do |format|
      if @referral.update_attributes(params[:referral])
        format.html { redirect_to @referral, notice: 'Referral was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @referral.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /referrals/1
  # DELETE /referrals/1.json
  def destroy
    @referral = Referral.find(params[:id])
    @referral.destroy

    respond_to do |format|
      format.html { redirect_to referrals_url }
      format.json { head :ok }
    end
  end

  # POST /referrals/bulk_create/[facebook_id].json
  def bulk_create
    puts params
    @referrals = Referral.bulk_create(params[:id], params[:referrals] )
    respond_to do |format|
      format.json { render json: @referrals }
    end

  end

	# GET /referrals/accept/1.json
  def accept

    @referral = Referral.accept(params[:id])
    respond_to do |format|
      format.json { render json: @referral }
    end

  end

end
